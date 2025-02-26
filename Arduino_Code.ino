#include <LiquidCrystal.h> // lcd Header
LiquidCrystal lcd(7, 6, 5, 4, 3, 2); // pins for LCD Connection

#define buzzer 12 // buzzer pin
#define led 13    //led pin

#define x A0 // x_out pin of Accelerometer
#define y A1 // y_out pin of Accelerometer
#define z A2 // z_out pin of Accelerometer

/*variables*/
int xsample = 0;
int ysample = 0;
int zsample = 0;
long start;
int buz = 0;
bool earthquakeDetected = false; // Flag to track earthquake detection

/*Macros*/
#define samples 50
#define maxVal 50  // max change limit
#define minVal -50 // min change limit

void setup()
{
  lcd.begin(16, 2); //initializing lcd
  Serial.begin(9600); // initializing serial
  delay(1000);
  lcd.print("EarthQuake ");
  lcd.setCursor(0, 1);
  lcd.print("Detector ");
  delay(2000);
  lcd.clear();
  lcd.print("Calibrating.....");
  lcd.setCursor(0, 1);
  lcd.print("Please wait...");
  pinMode(buzzer, OUTPUT);
  pinMode(led, OUTPUT);
  buz = 0;
  digitalWrite(buzzer, buz);
  digitalWrite(led, buz);
  for (int i = 0; i < samples; i++) // taking samples for calibration
  {
    xsample += analogRead(x);
    ysample += analogRead(y);
    zsample += analogRead(z);
  }

  xsample /= samples; // taking avg for x
  ysample /= samples; // taking avg for y
  zsample /= samples; // taking avg for z

  delay(3000);
  lcd.clear();
  lcd.print("Calibrated");
  delay(1000);
  lcd.clear();
  lcd.print("Device Ready");
  delay(1000);
  lcd.clear();
  lcd.print(" X Y Z ");
}

void loop()
{
  int value1 = analogRead(x); // reading x out
  int value2 = analogRead(y); //reading y out
  int value3 = analogRead(z); //reading z out

  int xValue = xsample - value1; // finding change in x
  int yValue = ysample - value2; // finding change in y
  int zValue = zsample - value3; // finding change in z

  /*displying change in x, y and z axis values over lcd*/
  lcd.setCursor(0, 1);
  lcd.print(xValue);
  lcd.setCursor(6, 1);
  lcd.print(yValue);
  lcd.setCursor(12, 1);
  lcd.print(zValue);
  delay(100);

  /* comparing change with predefined limits*/
  if (xValue < minVal || xValue > maxVal || yValue < minVal || yValue > maxVal || zValue < minVal || zValue > maxVal)
  {
    if (buz == 0)
    {
      start = millis(); // timer start
      buz = 1;          // buzzer / led flag activated
      earthquakeDetected = true; // Earthquake detected
    }
  }
  else if (buz == 1 && earthquakeDetected) // buzzer flag activated then alerting earthquake
  {
    lcd.setCursor(0, 0);
    lcd.print("Earthquake Alert ");
    digitalWrite(buzzer, HIGH); // Turn on the buzzer
    buz = 2; // Set the flag to prevent repeated buzzing
  }
  else
  {
    lcd.clear();
    lcd.print(" X Y Z ");
  }

  if (buz == 2)
  {
    // Stop the buzzer after buzzing once
    if (millis() >= start + 2000) // Buzz for 5 seconds
    {
      digitalWrite(buzzer, LOW); // Turn off the buzzer
      buz = 0; // Reset the buzzer flag
      earthquakeDetected = false; // Reset the earthquake detection flag
    }
  }

  digitalWrite(led, buz); // led on and off command

  /*sending values to processing for plot over the graph*/
  Serial.print("x=");
  Serial.println(xValue);
  Serial.print("y=");
  Serial.println(yValue);
  Serial.print("z=");
  Serial.println(zValue);
  Serial.println(" $");
}