
// Author: Ariel Tankus.
// Created: 07.03.2018.


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <math.h>
#include <errno.h>

#include <fcntl.h> 
#include <string.h>
#include <termios.h>

#define ROUND(x)        (floor((x)+0.5))
#define DATE_STR_BUF_SIZE    1000

void sigIntrpHandler(int sig);
void Randomize_rand();
int rand_discrete_interval(int interval_start, int interval_end);
int set_interface_attribs (int fd, int speed, int parity);
void set_blocking (int fd, int should_block);
void FileNameWithDateTime(const char *filename_prefix,
                          const char *filename_suffix,
                          char **fname, char **date_str);

const char *arduino_port_base = "/dev/ttyACM";
const int max_num_ports = 16;   /* #ports to try if current one does not
                                 * exist. */
const char *log_file_name_prefix = "sync_pulse_loop";
const char *log_file_name_suffix = ".log";
const int num_toggles = 1000;
const int SLEEP_INTERVAL_START_US =  500000;
const int SLEEP_INTERVAL_END_US   = 1000000;

int fd;
FILE *logfile;
char *log_file_name;
char *date_str;

void main()
{
    unsigned int usecs = 1000000;
    struct timespec tv, pre_tv;
    char arduino_port[30];
    char handshake_buf[30];
    
    FileNameWithDateTime(log_file_name_prefix, log_file_name_suffix,
                         &log_file_name, &date_str);
    
    logfile = fopen(log_file_name, "w");
    if (logfile == (FILE *)NULL) {
        printf("Failed to open log file on %s\n", logfile);
        exit(1);
    }

    for (int i = 0; i < max_num_ports; i++) {
        sprintf(arduino_port, "%s%d", arduino_port_base, i);

//        fd = open (arduino_port, O_WRONLY | O_NOCTTY | O_SYNC);
        fd = open (arduino_port, O_RDWR | O_NOCTTY | O_SYNC);
        if (fd < 0)
            continue;    /* to next port number. */

        printf("Opened arduino on %s\n", arduino_port);
        break;
    }
    if (fd < 0) {
        printf("Failed to open arduino on any port.\n");
        printf("errno = %d\n", errno);
        perror("Reason");
        exit(1);
    }

    set_interface_attribs (fd, B115200, 0);  // set speed to 115,200 bps, 8n1 (no parity)
    set_blocking (fd, 0);                // set no blocking
    
    while (read(fd, handshake_buf, 5) <=0)
        ;

    write(fd, "0", 1);           // always start from 0. Send 2 characters.
    
    Randomize_rand();

    signal(2, &sigIntrpHandler);   /* handle keyboard interrupt. */

    for (int i = 0; i < num_toggles; i++) {

        if (clock_gettime(CLOCK_REALTIME, &pre_tv) == -1) {
            fprintf(stderr, "Error measuring times.");;
            perror("Reason");
        }
        write(fd, "1", 1);
        
        if (clock_gettime(CLOCK_REALTIME, &tv) == -1) {
            fprintf(stderr, "Error measuring times.");;
            perror("Reason");
        }
        fprintf(logfile, "%ld %06ld Event: CHEETAH_SIGNAL (pre: %ld %06ld)\n",
                (long)tv.tv_sec, tv.tv_nsec/1000,
                (long)pre_tv.tv_sec, pre_tv.tv_nsec/1000);
        
        usecs = rand_discrete_interval(SLEEP_INTERVAL_START_US,
                                       SLEEP_INTERVAL_END_US);
        printf("Sync sent: %d. 1   Going to sleep for %.3f sec.\n", 2*i+1,
                (float)usecs/1000000);
        usleep(usecs);

        if (clock_gettime(CLOCK_REALTIME, &pre_tv) == -1) {
            fprintf(stderr, "Error measuring times.");;
            perror("Reason");
        }

        write(fd, "0", 1);

        if (clock_gettime(CLOCK_REALTIME, &tv) == -1) {
            fprintf(stderr, "Error measuring times.");;
            perror("Reason");
        }
        fprintf(logfile, "%ld %06ld Event: CHEETAH_SIGNAL (pre: %ld %06ld)\n",
                (long)tv.tv_sec, tv.tv_nsec/1000,
                (long)pre_tv.tv_sec, pre_tv.tv_nsec/1000);
        
        usecs = rand_discrete_interval(SLEEP_INTERVAL_START_US,
                                       SLEEP_INTERVAL_END_US);
        printf("Sync sent: %d. 0   Going to sleep for %.3f sec.\n", 2*i+2,
                (float)usecs/1000000);
        usleep(usecs);
    }
    
    close(fd);
    fclose(logfile);
}


void sigIntrpHandler(int sig)
{
    fclose(logfile);   // ensure everything is written to the disk.

    write(fd, "W", 1);   // tells the Arduino to wait for an incoming connection.
    if (close(fd) < 0)
        perror("Failed to close serial port: ");

    free(log_file_name);
    free(date_str);
    
    exit(0);
}

void Randomize_rand()
{
    long long t;
    struct timespec tv, pre_tv;

    if (clock_gettime(CLOCK_REALTIME, &tv) == -1) {
        fprintf(stderr, "Error measuring times.");;
        perror("Reason");
    }
    
    t = (long long)time((time_t *)NULL);
    fprintf(logfile, "%ld %06ld Event: RANDOM_SEED %Ld\n", (long)tv.tv_sec,
            tv.tv_nsec/1000, t);

    srand(t);
}

/*
 * Return a random number in a given discrete range.
 */
int rand_discrete_interval(int interval_start, int interval_end)
{
    /* scale the random number to the range:
       [interval_start-0.5, interval_end+0.5]
       so that each integer has an interval of length 1 around it.
       Thus all integers will have the same probability. */
    return (ROUND((double)rand() / (double)RAND_MAX *
                  ((double)(interval_end - interval_start + 1)) +
                  interval_start - 0.5));
}

int set_interface_attribs (int fd, int speed, int parity)
{
        struct termios tty;
        memset (&tty, 0, sizeof tty);
        if (tcgetattr (fd, &tty) != 0)
        {
                perror("error %d from tcgetattr");
                return -1;
        }

        cfsetospeed (&tty, speed);
        cfsetispeed (&tty, speed);

        tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
        // disable IGNBRK for mismatched speed tests; otherwise receive break
        // as \000 chars
        tty.c_iflag &= ~IGNBRK;         // disable break processing
        tty.c_lflag = 0;                // no signaling chars, no echo,
                                        // no canonical processing
        tty.c_oflag = 0;                // no remapping, no delays
        tty.c_cc[VMIN]  = 0;            // read doesn't block
        tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

        tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl

        tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
                                        // enable reading
        tty.c_cflag &= ~(PARENB | PARODD);      // shut off parity
        tty.c_cflag |= parity;
        tty.c_cflag &= ~CSTOPB;
        tty.c_cflag &= ~CRTSCTS;

        if (tcsetattr (fd, TCSANOW, &tty) != 0)
        {
                perror("error %d from tcsetattr");
                return -1;
        }
        return 0;
}

void set_blocking (int fd, int should_block)
{
        struct termios tty;
        memset (&tty, 0, sizeof tty);
        if (tcgetattr (fd, &tty) != 0)
        {
                perror("error %d from tggetattr");
                return;
        }

        tty.c_cc[VMIN]  = should_block ? 1 : 0;
        tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

        if (tcsetattr (fd, TCSANOW, &tty) != 0)
                perror("error %d setting term attributes");
}


/* Returns the filename with current date & time.
   The returned string need to be deallocated using free(). */
void FileNameWithDateTime(const char *filename_prefix,
                          const char *filename_suffix,
                          char **fname, char **date_str)
{
    time_t now;

    time(&now);
    struct tm *split_time = localtime(&now);

    /* create a recording file named with the current date and time: */
    *date_str = (char *)malloc(sizeof(char)*DATE_STR_BUF_SIZE);
    sprintf(*date_str, "_%d-%02d-%02d_%02d-%02d-%02d",
            split_time->tm_year + 1900, split_time->tm_mon + 1,
            split_time->tm_mday, split_time->tm_hour, split_time->tm_min,
            split_time->tm_sec);
    *fname = (char *)malloc(sizeof(char)*(strlen(filename_prefix) +
                                         strlen(*date_str) +
                                         strlen(filename_suffix)+1));

    strcpy(*fname, filename_prefix);
    strcat(*fname, *date_str);
    strcat(*fname, filename_suffix);
}
