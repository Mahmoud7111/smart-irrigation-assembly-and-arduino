#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

// Pins
const int relayPin  = 4;          // Relay module connected to digital pin 4
const int sensorPin = A0;         // Soil moisture sensor connected to analog pin A0

// Relay logic 
const bool relayActiveLow = true; // Defines whether the relay is active-low 

// Calibration values (adjust to your sensor)
const int dryAnalog = 600;        // Analog reading measured when soil is completely dry
const int wetAnalog = 100;        // Analog reading measured when soil is fully wet

void setup() {
   Serial.begin(9600);             // Starts serial communication at 9600 baud for debugging

  pinMode(relayPin, OUTPUT);      // Sets the relay pin as an output
  digitalWrite(relayPin, relayActiveLow ? HIGH : LOW); // Ensures pump starts OFF

  lcd.init();
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("SMART IRRIGATION");
  lcd.setCursor(0,1);
  lcd.print("System Ready");
  delay(1000);
}

void loop() {
  // 1. Read real sensor value
  int raw = analogRead(sensorPin);      // Reads raw 0–1023 analog value from the moisture sensor

  // 2. Convert to 0–100% moisture
    int moisture = map(raw, dryAnalog, wetAnalog, 0, 100); // Converts raw value to a percentage         //600 → 0% moisture
                                                                                                        //100 → 100% moisture
  moisture = constrain(moisture, 0, 100);         // Ensures moisture stays between 0 and 100   //constrain() limits a value to stay within a range. //“If moisture goes below 0 → make it 0
                                                                                                                                                    //If moisture goes above 100 → make it 100

  // Serial Monitor 
  Serial.print("Moisture: ");
  Serial.print(moisture);
  Serial.println("%");

  // 3. Compare with thresholds 
  if (moisture <= 50) {
    // DRY
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("STATUS: DRY");
    lcd.setCursor(0,1);
    lcd.print("PUMP: ON");
    setPump(true);

    Serial.println("STATUS: DRY (0-50) - PUMP ACTIVATED");
    Serial.println("Pump State: ON - Watering...");
  }
  else if (moisture <= 75 && moisture >= 51) {
    // NORMAL
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("STATUS: NORMAL");
    lcd.setCursor(0,1);
    lcd.print("PUMP: OFF");
    setPump(false);

    Serial.println("STATUS: NORMAL (51-75) - PUMP OFF");
    Serial.println("Pump State: OFF - No watering");
  }
  else {
    // WET
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("STATUS: WET");
    lcd.setCursor(0,1);
    lcd.print("PUMP: OFF");
    setPump(false);

    Serial.println("STATUS: WET (76-100) - PUMP OFF");
    Serial.println("Pump State: OFF - No watering");
  }

  delay(1000); // read once per second
}

void setPump(bool on) {
 // Calculates the correct signal depending on whether the relay is active-low or active-high
  digitalWrite(
    relayPin,
    on ? (relayActiveLow ? LOW : HIGH)   // If ON: send LOW for active-low relay, HIGH for active-high
         : (relayActiveLow ? HIGH : LOW) // If OFF: reverse the logic
  );
}
