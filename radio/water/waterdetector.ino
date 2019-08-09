// Water Sensor


const int sensor01 = A0;  
const int sensor02 = A1;  
const int sensor03 = A2;
const int manualOpen = 3;  
const int servoClosed = 2;  
const int servoOpened = 4;  

const int analogOutPin = 9; // Analog output pin that the LED is attached to
const int Speaker = 10;
const int servoClosing = 5;
const int servoOpening = 6;


int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)

int manualOpenState = 0;
int flag = 0;
  
void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  pinMode(servoClosed, INPUT);
  pinMode(servoOpened, INPUT);
  pinMode(servoClosing, OUTPUT);
  pinMode(servoOpening, OUTPUT);
  pinMode(Speaker, OUTPUT);
}

void loop() {
  // read the analog in value:
  // map it to the range of the analog out:
  int sensor01Value = map(analogRead(sensor01), 0, 1023, 0, 255);
  int sensor02Value = map(analogRead(sensor02), 0, 1023, 0, 255);
  int servoStateClosed = digitalRead(servoClosed);
  int servoStateOpened = digitalRead(servoOpened);
  manualOpenState = digitalRead(manualOpen);
  
  // change the analog out value:
  analogWrite(analogOutPin, sensor01Value);

  if (sensor01Value > 80 || sensor02Value > 80) {
    flag = 1;
  } else {
    if (manualOpenState == 1) {
      flag = 0;
      noTone(Speaker);
    }
  }
  
  if(flag == 1 && servoStateClosed != 1){
    analogWrite(servoOpening, 0);
    analogWrite(servoClosing, 255);
  }
  else if(flag == 0 && servoStateOpened != 1){
    analogWrite(servoClosing, 0);
    analogWrite(servoOpening, 255);
  }
  else {
    analogWrite(servoClosing, 0);
    analogWrite(servoOpening, 0);
  }

if(flag == 1){
  tone (Speaker, 4000); //включаем на 500 Гц
  delay(280);
  tone(Speaker, 4400); //включаем на 1000 Гц
  delay(280); //ждем 100 Мс
}

   // print the results to the serial monitor:
  Serial.print("sensor = ");
  Serial.print(analogRead(sensor03));
  Serial.print("\t Closed = ");
  Serial.println(servoStateClosed);

  // wait 2 milliseconds before the next loop
  // for the analog-to-digital converter to settle
  // after the last reading:
  delay(200);
}


