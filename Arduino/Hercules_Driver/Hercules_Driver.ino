// pin ctrl
#define PINCS           6           // all mos cs
#define PINM1F          4
#define PINM1R          5
#define PINM2F          7
#define PINM2R          8
#define PINPWMA         9           // PWM channel A (motor A speed)
#define PINPWMB         10          // PWM channel B (motor B speed)

String txtMsg = "";
char s;
int motorSpeed = 0;

void setup()
{
    Serial.begin(19200);
    Serial.println("HERCULES 4WD TEST");

    pinMode(PINCS, OUTPUT);
    pinMode(PINM1F, OUTPUT);
    pinMode(PINM1R, OUTPUT);
    pinMode(PINM2F, OUTPUT);
    pinMode(PINM2R, OUTPUT);

    motorSetSpeed(255);

    motorForward(100);
    motorStop(1000);

    motorReverse(100);
    motorStop(1000);

    motorTurnRight(100);
    motorStop(1000);

    motorTurnLeft(100);
    motorStop(1000);
}


void loop()
{
    while (Serial.available() > 0)
    {
        s = (char)Serial.read();
        if (s == '\n')
        {
            Serial.print("Command: ");
            Serial.print(txtMsg);

            Serial.print(" Char: ");
            char charBuf[5];
            txtMsg.toCharArray(charBuf, 3);

            if ( charBuf[0] == 'S' && charBuf[1] == 'A')
            {
                motorStop(100);
                Serial.print(" Action: Stop");
            }

            if ( charBuf[0] == 'M' && charBuf[1] == 'F')
            {
                motorForward(100);
                Serial.print(" Action: Forward");
            }

            if ( charBuf[0] == 'M' && charBuf[1] == 'R')
            {
                motorReverse(100);
                Serial.print(" Action: Reverse");
            }

            if ( charBuf[0] == 'T' && charBuf[1] == 'R')
            {
                motorTurnRight(100);
                Serial.print(" Action: Right");
            }

            if ( charBuf[0] == 'T' && charBuf[1] == 'L')
            {
                motorTurnLeft(100);
                Serial.print(" Action: Left");
            }

            Serial.println(";");
            txtMsg = "";
        }
        else
        {
            txtMsg += s;
        }
    }
}


void motorSetSpeed(int power)
{
    motorSpeed = power;
    analogWrite(PINPWMA, motorSpeed);
    analogWrite(PINPWMB, motorSpeed);
}

void motorStop(int duration)
{
    digitalWrite(PINCS, LOW);
    digitalWrite(PINM1F, LOW);

    digitalWrite(PINM1R, LOW);
    digitalWrite(PINM2F, LOW);

    digitalWrite(PINM2R, LOW);
    delay(duration);
}

void motorForward(int duration)
{
    digitalWrite(PINM1R, HIGH);
    digitalWrite(PINM1F, LOW);

    digitalWrite(PINM2R, HIGH);
    digitalWrite(PINM2F, LOW);

    digitalWrite(PINCS, HIGH);
    delay(duration);
}

void motorReverse(int duration)
{
    digitalWrite(PINM1R, LOW);
    digitalWrite(PINM1F, HIGH);

    digitalWrite(PINM2R, LOW);
    digitalWrite(PINM2F, HIGH);

    digitalWrite(PINCS, HIGH);
    delay(duration);
}

void motorTurnLeft(int duration)
{
    digitalWrite(PINM1R, LOW);
    digitalWrite(PINM1F, HIGH);

    digitalWrite(PINM2R, HIGH);
    digitalWrite(PINM2F, LOW);

    digitalWrite(PINCS, HIGH);
    delay(duration);
}


void motorTurnRight(int duration)
{
    digitalWrite(PINM1R, HIGH);
    digitalWrite(PINM1F, LOW);

    digitalWrite(PINM2R, LOW);
    digitalWrite(PINM2F, HIGH);

    digitalWrite(PINCS, HIGH);
    delay(duration);
}
