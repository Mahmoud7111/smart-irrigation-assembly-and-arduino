# 🌱 Smart Irrigation System - Assembly & Arduino

<div align="center">

![Assembly](https://img.shields.io/badge/Assembly-73.5%25-blue)
![C++](https://img.shields.io/badge/C++-26.5%25-green)
![Arduino](https://img.shields.io/badge/Platform-Arduino-00979D?logo=arduino)

*An intelligent automated irrigation system with dual implementation: Arduino and Assembly language*

</div>

---

## 📖 Overview

This project presents a **Smart Irrigation System** that automatically monitors soil moisture levels and controls a water pump to maintain optimal soil conditions. The system features:

- 🎯 **Real-time soil moisture monitoring** (0-100% scale)
- 💧 **Automatic pump control** based on moisture thresholds
- 📺 **LCD display** for status visualization
- 🔄 **Dual implementation** - Arduino (C++) and Assembly language
- ⚡ **Low-power design** suitable for field deployment

---

## ⚙️ Features

### Moisture Level Detection
The system categorizes soil moisture into three levels:

| Status | Moisture Range | Pump Action | Display |
|--------|---------------|-------------|---------|
| 🔴 **DRY** | 0% - 50% | ✅ Pump ON | "STATUS: DRY<br>PUMP: ON" |
| 🟡 **NORMAL** | 51% - 75% | ❌ Pump OFF | "STATUS: NORMAL<br>PUMP: OFF" |
| 🟢 **WET** | 76% - 100% | ❌ Pump OFF | "STATUS: WET<br>PUMP: OFF" |

### Intelligent Control Logic
- Automatic calibration support for different soil types
- Hysteresis prevention to avoid rapid on/off cycling
- Serial monitor output for debugging and data logging

---

## 🛠️ Hardware Requirements

### Core Components
- **Arduino Board** (Uno/Nano/Mega)
- **Soil Moisture Sensor** (Analog output)
- **Relay Module** (5V, supports active-low/active-high)
- **Water Pump** (12V DC recommended)
- **16x2 LCD Display** (I2C interface, address 0x27)

### Connections

```
Arduino          Component
-------          ---------
Pin A0    →      Soil Moisture Sensor (Analog Out)
Pin 4     →      Relay Module (Signal)
SDA       →      LCD I2C (SDA)
SCL       →      LCD I2C (SCL)
5V        →      Sensors & LCD Power
GND       →      Common Ground
```

### Power Supply
- Arduino: 5V via USB or 7-12V barrel jack
- Pump: Separate 12V power supply (connected through relay)

---

## 💻 Software Versions

### 1️⃣ Arduino Version (C++)

Located in `/Arduino-version/`

**Key Features:**
- Uses Arduino IDE libraries
- Easy to modify and calibrate
- Serial debugging support
- I2C LCD library integration

**Dependencies:**
```cpp
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
```

**Calibration:**
```cpp
const int dryAnalog = 600;  // Adjust based on your sensor
const int wetAnalog = 100;  // Adjust based on your sensor
```

### 2️⃣ Assembly Version

Located in `/Aseembly-version/`

**Key Features:**
- Low-level hardware control
- Optimized for performance
- Direct register manipulation
- Educational value for understanding microcontroller architecture

---

## 🚀 Getting Started

### Arduino Version

1. **Install Required Libraries:**
   - Open Arduino IDE
   - Go to `Sketch` → `Include Library` → `Manage Libraries`
   - Install: `LiquidCrystal I2C` by Frank de Brabander

2. **Open the Project:**
   ```bash
   cd Arduino-version/CO_New_copy_20251217214409/
   ```
   Open `CO_New_copy_20251217214409.ino` in Arduino IDE

3. **Configure:**
   - Adjust `dryAnalog` and `wetAnalog` values based on your sensor
   - Set `relayActiveLow` to match your relay module type

4. **Upload:**
   - Select your Arduino board type
   - Choose the correct COM port
   - Click "Upload"

5. **Monitor:**
   - Open Serial Monitor (9600 baud)
   - Observe moisture readings and pump status

### Assembly Version

1. Navigate to the Assembly version directory:
   ```bash
   cd Aseembly-version/
   ```

2. Follow the specific assembly toolchain instructions for your setup

---

## 📊 System Logic Flow

```
┌─────────────────┐
│  Read Sensor    │
│  (Analog A0)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Map to 0-100%  │
│  Moisture Scale │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Check Ranges   │
├─────────────────┤
│ ≤50%   → DRY    │
│ 51-75% → NORMAL │
│ ≥76%   → WET    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Control Pump   │
│  Update LCD     │
└─────────────────┘
```

---

## 🔧 Customization

### Adjusting Moisture Thresholds

Modify these values in the code:

```cpp
if (moisture <= 50) {
    // DRY condition - change threshold here
}
else if (moisture <= 75 && moisture >= 51) {
    // NORMAL condition - change thresholds here
}
```

### Changing LCD Address

If your LCD uses a different I2C address:
```cpp
LiquidCrystal_I2C lcd(0x27, 16, 2);  // Change 0x27 to your address
```

Find your address using an I2C scanner sketch.

---

## 📝 Serial Monitor Output Example

```
Moisture: 45%
STATUS: DRY (0-50) - PUMP ACTIVATED
Pump State: ON - Watering...

Moisture: 63%
STATUS: NORMAL (51-75) - PUMP OFF
Pump State: OFF - No watering

Moisture: 82%
STATUS: WET (76-100) - PUMP OFF
Pump State: OFF - No watering
```

---

## 🎓 Learning Outcomes

This project demonstrates:
- ✅ Analog sensor interfacing
- ✅ Relay control for high-power devices
- ✅ I2C communication protocol
- ✅ Threshold-based decision making
- ✅ Real-time system design
- ✅ Low-level programming (Assembly version)

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🔀 Open a Pull Request

---

## 📜 License

This project is open source and available 

---

## 👨‍💻 Author

**Mahmoud7111**

- GitHub: [@Mahmoud7111](https://github.com/Mahmoud7111)
- Repository: [smart-irrigation-assembly-and-arduino](https://github.com/Mahmoud7111/smart-irrigation-assembly-and-arduino)

---

## 🙏 Acknowledgments

- Arduino Community for excellent libraries
- Contributors to open-source sensor libraries
- Everyone who has provided feedback and suggestions

---

## 📞 Support

If you encounter any issues or have questions:

1. Check the existing [Issues](https://github.com/Mahmoud7111/smart-irrigation-assembly-and-arduino/issues)
2. Create a new issue with detailed information
3. Provide your hardware setup and serial monitor output

---

<div align="center">

**⭐ Star this repository if you found it helpful!**


</div>
