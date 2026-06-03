# 🌱 Smart Irrigation System — IoT + AI
---

## 📸 Screenshots & Demo

### IoT Prototype — Pump States

| Pump **Not Activated** | Pump **Activated** |
|:---:|:---:|
| ![System pump off](https://raw.githubusercontent.com/wassimhamdi2/Iraggation-App/main/screenDemo/Screenshot_1.jpg) | ![System pump on](https://raw.githubusercontent.com/wassimhamdi2/Iraggation-App/main/screenDemo/Screenshot_2.jpg) |
| AI model predicted: **no irrigation needed** | AI model predicted: **irrigation required** |

### Flutter Mobile App — Smart Irrigation UI

| App — Pump Activated | App — Pump Not Activated |
|:---:|:---:|
| ![App activated](https://raw.githubusercontent.com/wassimhamdi2/Iraggation-App/main/screenDemo/Screenshot_3.jpg) | ![App not activated](https://raw.githubusercontent.com/wassimhamdi2/Iraggation-App/main/screenDemo/Screenshot_4.jpg) |
| Temp: 32.80°C · Humidity: 36% · Soil: 652 | Temp: 32.80°C · Humidity: 37% · Soil: 314 |

> 📁 All screenshots are in the [`screenDemo/`](./screenDemo) folder.

---

## 📖 About the Project

This project is an **IoT-based smart irrigation system** that combines physical sensors with a Deep Learning model to automate irrigation decisions in real time.

The system monitors meteorological conditions (temperature, air humidity, and soil humidity) via sensors connected to a **NodeMCU ESP8266** microcontroller. A trained **MLP (Multi-Layer Perceptron)** model then decides whether to activate the water pump. All data is streamed to the cloud and displayed live in the **"Smart Irrigation"** Flutter mobile app.

---

## ✨ Features

- 💧 **Automatic pump control** — AI decides ON/OFF based on sensor readings
- 🌡️ **Real-time monitoring** — temperature, air humidity, soil humidity
- 📱 **Flutter mobile app** — live dashboard accessible from any Android phone
- ☁️ **Cloud sync** — sensor data stored and visualized on ThingSpeak
- 🔔 **Push notifications** — user alerted when irrigation state changes
- 🧠 **AI-powered** — MLP model with ~97% accuracy on the IIS dataset

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    IoT Hardware Layer                   │
│                                                         │
│  DHT11 ──┐                                              │
│           ├──► NodeMCU ESP8266 ──► ThingSpeak Cloud    │
│  Soil  ──┘         │                      │             │
│  Sensor            │                      ▼             │
│                 Relay ──► Pump    Flutter Mobile App    │
│                              Smart Irrigation UI        │
│                                      │                  │
│                              MLP Model Decision         │
│                           (activated / not activated)   │
└─────────────────────────────────────────────────────────┘
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

- **Dataset:** Intelligent Irrigation System (IIS) — 3 features: temperature, humidity, soil humidity
- **Optimizer:** Adam &nbsp;·&nbsp; **Loss:** Binary Cross-Entropy &nbsp;·&nbsp; **Epochs:** 100
- **Total parameters:** 151 (all trainable)
- **Accuracy:** ~97% &nbsp;·&nbsp; **False negatives on pump class:** 0

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
- Arduino IDE with ESP8266 board support installed
- ThingSpeak account (free at thingspeak.com)

### 1 — Mobile App

```bash
# Clone the repo
git clone https://github.com/wassimhamdi2/Iraggation-App.git
cd Iraggation-App

# Install dependencies
flutter pub get

# Run on a device or emulator
flutter run
```

### 2 — ESP8266 Firmware

1. Open `arduino/smart_irrigation.ino` in Arduino IDE
2. Set your Wi-Fi credentials and ThingSpeak API key
3. Wire the components (see diagram below)
4. Upload to the NodeMCU ESP8266 via USB

### Wiring

```
NodeMCU ESP8266
│
├── D4  ──── DHT11 (data pin)
├── A0  ──── Capacitive Soil Moisture Sensor (analog out)
├── D3  ──── Relay IN  ──── Water Pump
├── 3V3 ──── DHT11 VCC + Sensor VCC
└── GND ──── DHT11 GND + Sensor GND + Relay GND
```

---

## 📂 Project Structure

```
Iraggation-App/
├── screenDemo/               # App & prototype screenshots
├── lib/
│   ├── main.dart             # Flutter entry point
│   └── screens/              # App UI screens
├── arduino/
│   └── smart_irrigation.ino  # ESP8266 firmware (C++)
├── model/
│   └── mlp_model.ipynb       # MLP training notebook (Colab)
└── pubspec.yaml
```

---

## 📊 Results

| Metric | Value |
|--------|-------|
| Model accuracy | ~97% |
| False negatives (pump class) | 0 |
| Training epochs | 100 |
| Dataset | IIS (Intelligent Irrigation System) |
| Sensor read interval | 1 Hz (DHT11 max) |

---

## 🌍 Impact

Smart irrigation tackles key agricultural challenges in Tunisia and the MENA region:

- 💦 Reduces water waste by up to **50%**
- ⚡ Lowers energy costs from over-pumping
- 🌿 Prevents soil degradation from over-saturation
- 📲 Allows remote monitoring — no need to physically visit the field

---

## 🤝 Contributing

1. Fork the repository
2. Create your branch: `git checkout -b feature/your-feature`
3. Commit: `git commit -m 'Add your feature'`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

---


## 👤 Author

**Wassim Hamdi**  

---

> ⚠️ **Image note:** The screenshot filenames above (`Screenshot_1.jpg` … `Screenshot_4.jpg`) are estimates since GitHub blocks automated directory listing. If your images have different names, update the raw URLs in the Screenshots section to match your actual filenames in `screenDemo/`.
