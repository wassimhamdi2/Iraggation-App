# 🌱 Smart Irrigation System — IoT + AI


## 📸 Screenshots & Demo

### 🔧 Hardware Components

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/Capteur%20DHT11.PNG?raw=true" width="200"/><br/>
      <b>Capteur DHT11</b><br/>Temperature & Humidity Sensor
    </td>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/Capteur%20d%E2%80%99humidit%C3%A9%20capacitif%20v1.2.PNG?raw=true" width="200"/><br/>
      <b>Capacitive Soil Moisture Sensor</b><br/>Soil Humidity Sensor v1.2
    </td>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/NodeMCU%20Esp8266.PNG?raw=true" width="200"/><br/>
      <b>NodeMCU ESP8266</b><br/>Wi-Fi Microcontroller
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/relais%203V.PNG?raw=true" width="200"/><br/>
      <b>Relay 5V</b><br/>Pump Switch
    </td>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/Mini%20pompe%20immergeable.PNG?raw=true" width="200"/><br/>
      <b>Mini Submersible Pump</b><br/>3–5V Water Pump
    </td>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/fils%20de%20connexion.PNG?raw=true" width="200"/><br/>
      <b>Jumper Wires</b><br/>Connection Cables
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/plaque%20d%E2%80%99essai%20400points.PNG?raw=true" width="200"/><br/>
      <b>Breadboard 400pts</b><br/>Prototyping Board
    </td>
    <td></td>
    <td></td>
  </tr>
</table>

---

### 🌿 IoT Prototype — real life test 

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/realTest.PNG?raw=true" width="500"/><br/>
      <b>real life test</b>
    </td>
</table>

---

### 📱 Flutter Mobile App — "Smart Irrigation"

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/wassimhamdi2/Iraggation-App/blob/main/screenDemo/homeScreen.PNG?raw=true" width="250"/><br/>
      <b>App — Pump Activated</b><br/>Temp: 32.80°C · Humidity: 36% · Soil: 652
    </td>
</table>

---


## 📖 About the Project

This project is an **IoT-based smart irrigation system** that combines physical sensors with a Deep Learning model to automate irrigation decisions in real time.

The system monitors meteorological conditions (temperature, air humidity, soil humidity) via sensors connected to a **NodeMCU ESP8266** microcontroller. A trained **MLP (Multi-Layer Perceptron)** model then decides whether to activate the water pump. All data is streamed to the cloud (ThingSpeak) and displayed live in the **"Smart Irrigation"** Flutter mobile app.

---

## ✨ Features

- 💧 **Automatic pump control** — AI decides ON/OFF based on sensor readings
- 🌡️ **Real-time monitoring** — temperature, air humidity, and soil humidity
- 📱 **Flutter mobile app** — live dashboard accessible from any Android phone
- ☁️ **Cloud sync** — sensor data stored and visualized on ThingSpeak
- 🔔 **Push notifications** — user alerted when irrigation state changes
- 🧠 **AI decision-making** — MLP model with ~97% accuracy on the IIS dataset

---

## 🏗️ System Architecture

```
DHT11 ──────────────┐
                    ├──► NodeMCU ESP8266 ──► socket io (wifi) ──► Flutter App
Soil Moisture ──────┘         │                                    (Smart Irrigation UI)
                              │                                          │
                           Relay ──► Water Pump              MLP Model Decision
                                                         (activated / not activated)
```

---

## 🧠 AI Model — MLP Architecture

| Layer    | Neurons | Activation |
|----------|---------|------------|
| Input    | 3       | —          |
| Hidden 1 | 6       | ReLU       |
| Hidden 2 | 6       | ReLU       |
| Hidden 3 | 6       | ReLU       |
| Output   | 1       | Sigmoid    |

- **Dataset:** Intelligent Irrigation System (IIS) — temperature, humidity, soil humidity
- **Optimizer:** Adam · **Loss:** Binary Cross-Entropy · **Epochs:** 100
- **Total parameters:** 151 (all trainable)
- **Accuracy:** ~97% · **False negatives on pump class:** 0

---

## 🛠️ Tech Stack

### Hardware

| Component | Role |
|-----------|------|
| NodeMCU ESP8266 | Wi-Fi microcontroller — brain of the system |
| DHT11 | Measures air temperature & humidity |
| Capacitive Soil Moisture Sensor v1.2 | Measures soil water content |
| 5V Relay | Switches the water pump ON/OFF |
| Mini Submersible Pump (3–5V) | Waters the plants |
| Breadboard + Jumper Wires | Circuit prototyping |

### Software

| Tool | Purpose |
|------|---------|
| Flutter / Dart | Cross-platform mobile app |
| Arduino IDE + C++ | ESP8266 firmware |
| Google Colab + Python | MLP model training |
| ThingSpeak | IoT cloud data platform |
| Android Studio | Android emulator & testing |
| Visual Studio Code | Flutter development |
| StarUML | UML design diagrams |
| Google Drive | Dataset & model storage |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.x
- Android Studio or VS Code with Flutter plugin
- Arduino IDE with ESP8266 board support
- ThingSpeak account (free)

### Mobile App

```bash
git clone https://github.com/wassimhamdi2/Iraggation-App/tree/main/tfm3.git
cd Iraggation-App
flutter pub get
flutter run
```

### ESP8266 Firmware

1. Open `arduino/smart_irrigation.ino` in Arduino IDE
2. Set your Wi-Fi credentials and ThingSpeak API key
3. Connect components per the wiring below and upload via USB

```
NodeMCU ESP8266
├── D4  ──── DHT11 (data pin)
├── A0  ──── Capacitive Soil Moisture Sensor
├── D3  ──── Relay IN ──► Water Pump
├── 3V3 ──── Sensor VCC
└── GND ──── Common Ground
```



---

## 👤 Author

**Wassim Hamdi**  
GitHub: [@wassimhamdi2](https://github.com/wassimhamdi2)
