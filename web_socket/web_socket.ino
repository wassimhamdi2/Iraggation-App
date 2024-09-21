#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>
#include <DHT.h>
#include <ArduinoJson.h>

#define DHTTYPE DHT11
#define DLED1 D0 
#define DLED2 D3
#define waterPump 9
const int SensorPin = A0;

const char *ssid = "imen";
const char *pass = "3Y368358";

String json;

char tstr[10];
char hstr[10];
char fstr[10];
IPAddress subnet(255, 255, 255, 0);
IPAddress gateway(192, 168, 137, 1);
IPAddress local_IP(192, 168, 137, 184);
DHT dht(D1, DHTTYPE);

WebSocketsServer webSocket = WebSocketsServer(8080);

unsigned long lastConnectionTime = 0;
const unsigned long connectionTimeout = 30000;
bool pumpState = false;

void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t length) {
  String cmd = "";
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.println("WebSocket is disconnected");
      pumpState = false;
      digitalWrite(waterPump, HIGH); // Turn off the pump
      break;
    case WStype_CONNECTED:
      {
        Serial.println("WebSocket is connected");
        Serial.println(webSocket.remoteIP(num).toString());
        webSocket.sendTXT(num, "connected");
        lastConnectionTime = millis(); // Reset connection time
      }
      break;
    case WStype_TEXT:
      {
        cmd = "";
        for (int i = 0; i < length; i++) {
          cmd += (char)payload[i];
        }
        Serial.println(cmd);

        DynamicJsonDocument doc(1024);
        DeserializationError error = deserializeJson(doc, cmd);
        if (!error) {
          if (doc.containsKey("pumpState")) {
            pumpState = doc["pumpState"];
            digitalWrite(waterPump, pumpState ? LOW : HIGH); // Activate/deactivate pump
            lastConnectionTime = millis(); // Reset connection time
          }
        } else {
          Serial.println("Failed to parse JSON");
        }
      }
      break;
    default:
      break;
  }
}

String chr2str(char *chr) {
  String rval;
  for (int x = 0; x < strlen(chr); x++) {
    rval += chr[x];
  }
  return rval;
}

void setup() {
  Serial.begin(9600);

  Serial.println("Connecting to WiFi");
  WiFi.config(local_IP, gateway, subnet);
  WiFi.begin(ssid, pass);
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
  Serial.println("WebSocket is started");

  dht.begin();
  pinMode(DLED1, OUTPUT);
  digitalWrite(DLED1, LOW);
  pinMode(DLED2, OUTPUT);
  digitalWrite(DLED2, LOW);
  pinMode(waterPump, OUTPUT);
  digitalWrite(waterPump, HIGH);
}

void loop() {
  delay(2000);
  webSocket.loop();

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    digitalWrite(DLED2, LOW);
  }
  digitalWrite(DLED2, HIGH);

  float soil = analogRead(SensorPin);
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float f = dht.readTemperature(true);

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    digitalWrite(DLED1, HIGH);
    digitalWrite(waterPump, HIGH);
    return;
  } else {
    digitalWrite(DLED1, LOW);
    sprintf(tstr, "%.2f", t);
    sprintf(hstr, "%.2f", h);
    sprintf(fstr, "%.2f", soil);
    Serial.print("soil hum: ");
    Serial.print(soil);
    Serial.print("  Temp: ");
    Serial.print(t);
    Serial.print(" C, ");
    Serial.print(f);
    Serial.print(" F, Hum: ");
    Serial.print(h);
    Serial.println("%");

    json = "{\"temp\":\"" + chr2str(tstr) + "\",\"humidity\":\"" + chr2str(hstr) + "\",\"heat\":\"" + chr2str(fstr) + "\"}";
    Serial.println("DHT data read successful: " + json);
    webSocket.broadcastTXT(json);
  }

  if (millis() - lastConnectionTime > connectionTimeout) {
    pumpState = false;
    digitalWrite(waterPump, HIGH); // Turn off the pump
  }
}
