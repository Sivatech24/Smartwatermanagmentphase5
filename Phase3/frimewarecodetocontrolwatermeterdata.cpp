const int flowSensorPin = 2; // Connect the flow sensor to a digital pin

volatile int pulseCount = 0;
float flowRate = 0.0; // Flow rate in liters per minute
unsigned int flowMilliLitres = 0;
unsigned long totalMilliLitres = 0;

unsigned long previousMillis = 0;
const long interval = 1000; // Update interval in milliseconds

void setup() {
  pinMode(flowSensorPin, INPUT);
  attachInterrupt(digitalPinToInterrupt(flowSensorPin), pulseCounter, FALLING);
  Serial.begin(9600);
}

void loop() {
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    detachInterrupt(digitalPinToInterrupt(flowSensorPin));

    flowRate = (1000.0 / (float(interval) / 1000.0)) / pulseCount;
    flowMilliLitres = (flowRate / 60) * 1000;

    totalMilliLitres += flowMilliLitres;

    Serial.print("Flow rate: ");
    Serial.print(flowRate);
    Serial.print(" L/min\tTotal Millilitres: ");
    Serial.println(totalMilliLitres);

    pulseCount = 0;
    previousMillis = currentMillis;
    attachInterrupt(digitalPinToInterrupt(flowSensorPin), pulseCounter, FALLING);
  }
}

void pulseCounter() {
  pulseCount++;
}
