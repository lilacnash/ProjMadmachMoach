int byteRead;

void setup()
{
    Serial.print("Setup\n");
    // Turn the Serial Protocol ON
    //Serial.begin(9600);
    Serial.begin(115200);
    while (!Serial) {
      ;
    }
    pinMode(7, OUTPUT);
    pinMode(LED_BUILTIN, OUTPUT);
    establishContact();  // send a byte to establish contact until receiver responds
}

void loop()
{
    /* check if data has been sent from the computer: */
    if (Serial.available() > 0) {
        /* read the most recent byte */
        byteRead = Serial.read();
        
        /*ECHO the value that was read, back to the serial port. */
        Serial.println(byteRead);
        Serial.print(" The Arduino received: ");
        Serial.println(byteRead, BIN);
        
        /*If received 1 (49 = ascii value of one) from serial port then set the output pin 7 to 5v */
        if (byteRead == 49) {
            digitalWrite(7, HIGH);
            digitalWrite(LED_BUILTIN, HIGH);
        }
        
        /*If received 0 (48 = ascii value of zero) from serial port then set the output pin 7 to 0v */
        if (byteRead == 48) {
            digitalWrite(7, LOW);
            digitalWrite(LED_BUILTIN, LOW);
        }
        
        /* skip any extra byte in the buffer: */
        /*while (Serial.available() > 0) {
          byteRead = Serial.read();
        }*/
    }
}

void serialEvent()
{
    if (Serial.available() > 0) {
        
        /*If received W (87 = ascii value of zero) from serial port then client exited, Wait for a new incoming connection */
        if (byteRead == 87) {
            establishContact();
        }
        
    }
}


void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");   // send an initial string
    delay(300);
  }
}

