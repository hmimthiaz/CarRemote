#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>


void setup()
{
    ble_begin();

    // Enable serial
    Serial.begin(19200);
    Serial1.begin(19200);
}

String BLEMsg = "";
char b;

String txtMsg = "";
char s;

void loop()
{

    while (ble_available())
    {
        b = (char)ble_read();
        if (b == '\n')
        {
            Serial.println(BLEMsg);
            Serial1.println(BLEMsg);
            BLEMsg = "";
        }
        else
        {
            BLEMsg += b;
        }
    }


    while (Serial1.available() > 0)
    {
        s = (char)Serial1.read();
        if (s == '\n')
        {
            Serial.println(txtMsg);
            txtMsg = "";
        }
        else
        {
            txtMsg += s;
        }
    }

    if (!ble_connected())
    {
        Serial1.println("SA");
    }

    ble_do_events();
}

