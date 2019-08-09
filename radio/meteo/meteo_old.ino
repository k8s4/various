// Generic
//int D0 = 16;
//int D3 = 0; 
//int D4 = 2;
// TTL
//int TX = 1;  
//int RX = 3;  
//I2C
//int D1 = 5;  // SCL
//int D2 = 4;  // SDA
//SPI
//int D5 = 14;  // SCK
//int D6 = 12;  // MISO
//int D7 = 13;  // MOSI
//int D8 = 15;  // SS

#include "ESP8266WiFi.h"                                // Подключаем библиотеку ESP8266WiFi
#include "Adafruit_Sensor.h"                            // Adafruit_Sensor
#include "DHT.h"                                        // Подключаем библиотеку DHT
#include "OneWire.h"                                    // Библиотека для протокола 1-wire 18B20
#include "DallasTemperature.h"                          // Библиотека для работы с датчиком 18B20
#include "Wire.h"                                       // Библиотека для протокола i2c для BMP085
#include "Adafruit_BMP085.h"                            // Библиотека для работы с цифровым барометром BMP085

const char* ssid = "******";                     // Название Вашей WiFi сети
const char* password = "******";          // Пароль от Вашей WiFi сети

//Analog
int ANALOG = A0;  

int analogValue = 0;
int outputValue = 0;
float dht_temp = 0;
float dallas_temp = 0;
float dht_hum = 0;
float bmp_press = 0;
float bmp_temp = 0;
float bmp_alt = 0;
 
#define DHTPIN 2                                        // Пин к которому подключен датчик
#define DHTTYPE DHT11                                   // Используемый датчик DHT 11
DHT dht(DHTPIN, DHTTYPE);                               // Инициализируем датчик

#define ONE_WIRE_BUS 0                                  // Указываем, к какому выводу подключен датчик 18B20
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature DS18B20(&oneWire);
Adafruit_BMP085 bmp;
WiFiServer server(80);                                  // Указываем порт Web-сервера

void setup() {
  Serial.begin(115200);                                 // Скорость передачи 115200 
  delay(10);                                            // Пауза 10 мкс
  Wire.begin(4, 5);                                     // Привязать на стандартные порты i2c протокол 
  dht.begin();                                          // Инициализация DHT
  DS18B20.begin();                                      // Инициализация DS18B20
  if (!bmp.begin()) {
    Serial.println("Could not find a valid BMP085 sensor, check wiring!");
    while (1) {}
  } 
   
  // инициализируем D2 со встроенным светодиодом как дискретный выход
  pinMode(D0, OUTPUT);
  pinMode(ANALOG,  INPUT);

  Serial.println("");                                   // Печать пустой строки 
  Serial.print("Connecting to ");                       // Печать "Подключение к:"
  Serial.println(ssid);                                 // Печать "Название Вашей WiFi сети"
  
//  WiFi.begin(ssid, password);                           // Подключение к WiFi Сети
  
//  while (WiFi.status() != WL_CONNECTED) (                // Проверка подключения к WiFi сети
//   delay(500);                                          // Пауза 500 мкс
//   Serial.print(".");                                   // Печать "."
//  }
//   Serial.println("");                                  // Печать пустой строки                                          
//   Serial.println("WiFi connected");                    // Печать "Подключение к WiFi сети осуществлено"
//   server.begin();                                      // Запуск Web сервера
//   Serial.println("Web server running.");               // Печать "Веб-сервер запущен"
//   delay(10000);                                        // Пауза 10 000 мкс
//   Serial.println(WiFi.localIP());                      // Печатаем полученный IP-адрес ESP
}

void loop() {
  analogValue = analogRead(ANALOG);                  // Считывание аналога 10 бит
  dht_temp = dht.readTemperature();                  // Запрос на считывание температуры DHT
  dht_hum = dht.readHumidity();                      // и влажности DHT
  analogWrite(D0, analogValue);
  DS18B20.requestTemperatures();                   // Запрос на считывание температуры
  dallas_temp = DS18B20.getTempCByIndex(0);

  bmp_temp = bmp.readTemperature();
  bmp_press = bmp.readPressure() / 133.3;
  bmp_alt = bmp.readAltitude();
  
  Serial.print("sensor = ");
  Serial.print(analogValue);
  Serial.print("\t 18B20 temp = ");
  Serial.print(dallas_temp);
  Serial.print("\t DHT temp = ");
  Serial.print(dht_temp);
  Serial.print("\t DHT hum = ");
  Serial.println(dht_hum);
  Serial.print("BMP085 pressure = ");
  Serial.print(bmp_press);
  Serial.print("\t BMP085 temp = ");
  Serial.println(bmp_temp);
  Serial.print("\t BMP085 altitude = ");
  Serial.println(bmp_alt);

  delay(1000);  
}