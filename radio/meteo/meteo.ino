// Generic
//int D0 = 16;
//int D3 = 0; 						// For 1-wire 18B20
//int D4 = 2;						// For DHT sensor
// TTL
//int TX = 1;  
//int RX = 3;  
//I2C
//int D1 = 5;		// SCL                          // i2c for BMP085
//int D2 = 4;		// SDA				// ---
//SPI
//int D5 = 14;		// SCK
//int D6 = 12;		// MISO
//int D7 = 13;		// MOSI
//int D8 = 15;		// SS
			// ???CSN pin и CE pin 
//int ANALOG = A0;  

#include "ESP8266WiFi.h"                                // Attach library for WiFI ESP8266WiFi
#include "ESP8266WebServer.h"                           // Attach library for WebSrv ESP8266WiFi
#include "Adafruit_Sensor.h"                            // Adafruit_Sensor
#include <DNSServer.h>
#include "DHT.h"                                        // Attach library for working with humidity sensors DHT
#include "OneWire.h"                                    // Attach library for 1-wire protocol, for sensors 18B20
#include "DallasTemperature.h"                          // Attach library for working with temperature sensors 18B20
#include "Wire.h"                                       // Attach library for working with i2c protocol, for sensors BMP085
#include "Adafruit_BMP085.h"                            // Attach library for working with pressure sensors BMP085
#include <WiFiManager.h>          			//https://github.com/tzapu/WiFiManager

#define debug true
#define DHTPIN 2                                        // PIN for DHT sensor
#define DHTTYPE DHT11                                   // Type of DHT
#define ONE_WIRE_BUS 0                                  // PIN for 1-wire bus, for 18B20

//const char* ssid = "****";                     		// Name of your WiFi network
//const char* password = "******";          		// PSK for your WiFi network
String hostname = "";					// var for complex string for narodmon.ru
long previousMillis = 0;        			// will store last time was updated
long interval = 1000;					// interval (milliseconds)
long postInterval = 300000				// Post interval to narodmon.ru
long retryInterval = 15000				// Retry interval for narodmon.ru
unsigned long lastConnTime = 0;           		// Last connection time
int analogValue = 0;					// Get data from analog pin A0
int outputValue = 0;					// Output data from A0 after transformation
float dallas_temp = 0;
float dht_temp = 0;
float dht_hum = 0;
float bmp_press = 0;
float bmp_temp = 0;
float bmp_alt = 0;
float analog_light = 0;
 
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature ds18B20(&oneWire);			// Initialize sensor 18B20
DHT dht(DHTPIN, DHTTYPE);                               // Initialize DHT sensor
Adafruit_BMP085 bmp;
WiFiServer server(80);                                  // Set tcp port for WEB server

void setup() {
  Serial.begin(115200);                                 // Serial speed 115200 
  delay(10);                                            
  Wire.begin(4, 5);                                     // Initialise i2c to PINs
  ds18B20.begin();                                      // Start DS18B20
  dht.begin();                                          // Start DHT

  if (!bmp.begin()) {					// Start BMP085
    Serial.println("Could not find a valid BMP085 sensor, check wiring!");
    while (1) {}
  } 

// Initialize PINS   
  pinMode(D0, OUTPUT);					
  pinMode(A0,  INPUT);
// Print name of WiFi network
  Serial.print("\nConnecting to ");                       
  Serial.println(ssid);                                 
// WiFi
  hostname = "ESP" + WiFi.macAddress();			// Get MAC Address
  hostname.replace(":","");  				// Somthing changes
  WiFi.hostname(Hostname);				// Set hostname
  WiFi.begin(ssid, password);                           // Connect to WiFi network
  while (WiFi.status() != WL_CONNECTED) {               // Check conect to WiFi network
    delay(500);                                          
    Serial.print(".");                                   
  }
  Serial.println("\nWiFi connected");                    
  server.begin();                                       // Start Web server
  Serial.println("Web server running.");               
  delay(1000);                                        
  Serial.println(WiFi.localIP());                       // Print obtained IP adress
  lastConnTime = millis() - postInterval + retryInterval;	// First post data to narodmon
}

void loop() {
  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;   			// save the last time 

    analog_light = analogRead(A0);                  	// Read 10bit A/D converter 
    dht_temp = dht.readTemperature();                  	// Get temperature from DHT
    dht_hum = dht.readHumidity();                     	// Get humidity from DHT
    analogWrite(D0, analogValue);                      	// Set software PWM
    ds18B20.requestTemperatures();			// Prepare for get temperature from 18B20
    dallas_temp = DS18B20.getTempCByIndex(0);		// Get temperature from 18B20
    bmp_temp = bmp.readTemperature();		        // Get temperature from BMP085
    bmp_press = bmp.readPressure() / 133.3;		// Get Pressure from BMP085
    bmp_alt = bmp.readAltitude();			// Get Altitude from BMP085
  }  

  Serial.print("sensor = ");
  Serial.print(analog_light);
  Serial.print("; 18B20 temp = ");
  Serial.print(dallas_temp);
  Serial.print("; DHT temp = ");
  Serial.print(dht_temp);
  Serial.print("; DHT hum = ");
  Serial.println(dht_hum);
  Serial.print("BMP085 pressure = ");
  Serial.print(bmp_press);
  Serial.print("; BMP085 temp = ");
  Serial.println(bmp_temp);
  Serial.print("; BMP085 altitude = ");
  Serial.println(bmp_alt);

  if (currentMillis - lastConnTime > postInterval) {			// Post to narodmon.ru timer
    if (WiFi.status() == WL_CONNECTED && sendToNarodmon()) { 
        lastConnTime = currentMillis;					
    } else {  
        lastConnTime = currentMillis - postInterval + retryInterval; 	// Try after retryInterval to connect to WiFi or send data to narodmon.ru
        Serial.println("Not connected to WiFi or Not sent to narodmon."); 
    }
  } 
  yield(); 						// May be for safety working without latency
}


bool sendToNarodmon() { 				// Function for send data to narodmon.ru
  WiFiClient client;
  String buf;
  buf = "#" + hostname + "#ESP_******" + "\r\n"; 	// Header and visible name for narodmon.ru
  buf = buf + "#T1#" + String(dallas_temp) + "\r\n";    
  buf = buf + "#T2#" + String(dht_temp) + "\r\n"; 
  buf = buf + "#T3#" + String(bmp_temp) + "\r\n"; 
  buf = buf + "#H1#" + String(dht_hum) + "\r\n"; 
  buf = buf + "#P1#" + String(bmp_press) + "\r\n"; 
  buf = buf + "#L1#" + String() + "\r\n"; 
  buf = buf + "##\r\n"; 				// END of packet

  if (!client.connect("narodmon.ru", 8283)) { // попытка подключения
    Serial.println("Connection to narodmon.ru failed");
    return false; // не удалось;
  } else {
    client.print(buf); // и отправляем данные
    if (debug) Serial.println(buf);			// Buffer to Debug
    while (client.available()) {
      String line = client.readStringUntil('\r'); 	// Read potential recieved data 
      Serial.print(line);
    }
  }
  return true;
}

