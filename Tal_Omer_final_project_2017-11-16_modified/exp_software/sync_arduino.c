
// Author: Ariel Tankus.
// Created: 07.03.2018.


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <math.h>
#include <errno.h>

#define ROUND(x)        (floor((x)+0.5))

void sigIntrpHandler(int sig);
void Randomize_rand();
int rand_discrete_interval(int interval_start, int interval_end);

const char *arduino_port_base = "/dev/ttyACM";
const int max_num_ports = 16;   /* #ports to try if current one does not
                                 * exist. */
const char *log_file_name = "sync_pulse_loop.log";
const int num_toggles = 1000;
const int SLEEP_INTERVAL_START_US =  500000;
const int SLEEP_INTERVAL_END_US   = 1000000;

FILE *fid;
FILE *logfile;

void main()
{
    unsigned int usecs = 1000000;
    struct timespec tv, pre_tv;
    char arduino_port[30];

    logfile = fopen(log_file_name, "w");
    if (logfile == (FILE *)NULL) {
        printf("Failed to open log file on %s\n", logfile);
        exit(1);
    }

    for (int i = 0; i < max_num_ports; i++) {
        sprintf(arduino_port, "%s%d", arduino_port_base, i);
        fid = fopen(arduino_port, "w");
        if (fid == (FILE *)NULL) {
            if (errno == EACCES) {
                /* port does not exist - try the next port number: */
                continue;
            }
            printf("Failed to open arduino on %s\n", arduino_port);
            printf("errno = %d\n", errno);
            perror("Reason");
            exit(1);
        }

        printf("Opened arduino on %s\n", arduino_port);
        break;
    }
    if (fid == (FILE *)NULL) {
        printf("Failed to open arduino on any port.\n");
        printf("errno = %d\n", errno);
        perror("Reason");
        exit(1);
    }
    
    Randomize_rand();

    signal(2, &sigIntrpHandler);   /* handle keyboard interrupt. */

    fprintf(fid, "0\n");  /* always start from 0. */
    
    for (int i = 0; i < num_toggles; i++) {

        if (clock_gettime(CLOCK_REALTIME, &pre_tv) == -1) {
            fprintf(stderr, "Error measuring times.");;
            perror("Reason");
        }
        fprintf(fid, "1\n");
        
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

        fprintf(fid, "0\n");

        if (clock_gettime(CLOCK_REALTIME, &tv) == -1) {
            fprintf(stderr, "Error measuring times.");
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
    
    fclose(fid);
    fclose(logfile);
}


void sigIntrpHandler(int sig)
{
    fclose(logfile);
    fclose(fid);

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
