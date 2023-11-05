#define PIN_TRIG 26
#define PIN_ECHO 25
#define LOWLED   18
#define MIDLED   19
#define HIGHLED  21
#define MOTOR    27

unsigned int level = 0;

void setup() {

  pinMode(LOWLED,OUTPUT);
  pinMode(MIDLED,OUTPUT);
  pinMode(HIGHLED,OUTPUT);
  pinMode(MOTOR,OUTPUT);
  digitalWrite(LOWLED,HIGH);
  digitalWrite(MIDLED,HIGH);
  digitalWrite(HIGHLED,HIGH);
  digitalWrite(MOTOR,LOW);

  Serial.begin(115200);
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);
}

void loop() {
  // Start a new measurement:
  digitalWrite(PIN_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);

  // Read the result:
  int duration = pulseIn(PIN_ECHO, HIGH);
  Serial.print("Distance in CM: ");
  Serial.println(duration / 58);
  Serial.print("Distance in inches: ");
  Serial.println(duration / 148);
  
  level = duration / 58;

  if (level < 100)
  {

        digitalWrite(LOWLED,LOW);
        digitalWrite(MOTOR,HIGH);
        digitalWrite(HIGHLED,HIGH);
        digitalWrite(MIDLED,HIGH);

  }
  else if ((level > 200) && (level <400))
  {
        digitalWrite(LOWLED,HIGH);
        digitalWrite(HIGHLED,HIGH);
        digitalWrite(MIDLED,LOW);

  }
  else if (level >= 400 )
  {
        digitalWrite(HIGHLED,LOW);
        digitalWrite(MIDLED,HIGH);
        digitalWrite(LOWLED,HIGH);
        digitalWrite(MOTOR,LOW);

  }
  delay(1000);
}