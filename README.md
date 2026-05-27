<div align="center">

<h1>🧠 ParkinsonBuddy 📱</h1>
<h3>Parkinson's Disease Monitoring and Active Assessment App</h3>

![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-1575F9?style=for-the-badge&logo=xcode&logoColor=white)
![CareKit](https://img.shields.io/badge/CareKit-FF2D55?style=for-the-badge&logo=apple&logoColor=white)

*Empowering individuals with Parkinson's disease through daily care routines, symptom tracking, and interactive cognitive/motor assessments.*

[📌 Features](#-features) • [🎓 Background](#-background--context) • [📁 Structure](#-project-structure) • [🚀 Usage](#-installation--usage)

</div>

---

## 🏛️ Project Overview
This repository contains the complete source code for **ParkinsonBuddy**, a comprehensive iOS healthcare application. Designed with empathy and clinical inspiration, the app assists patients, caregivers, and medical professionals in monitoring the daily progression of Parkinson's disease. By leveraging Apple's native frameworks, the app provides a seamless user experience tailored to accessibility and specific medical needs.

---

## 🎓 Background & Context
This project was proudly designed and developed during the **Apple Foundation Program** at the **University of Salerno (UNISA)**. 
Built with a strong focus on Apple's *Human Interface Guidelines (HIG)*, the app represents a collaborative effort to bridge the gap between intuitive technology and daily healthcare management.

---

## 📌 Features
Instead of just passively tracking data, ParkinsonBuddy actively engages the user through clinically inspired assessments:

- ✅ **Daily Care Feed**: A centralized, easy-to-read dashboard (`CareFeedViewController`) to manage daily routines, medications, and check-ins.
- ✅ **Motor & Cognitive Assessments**: Interactive tasks inspired by ResearchKit to evaluate disease progression:
  - **Tap Test**: Evaluates finger dexterity and tapping speed to monitor bradykinesia.
  - **Connect the Dots**: Analyzes hand-eye coordination and resting/action tremors.
  - **Memory Test**: A short-term memory assessment to track cognitive health.
- ✅ **Symptom Tracking & Surveys**: Custom surveys to regularly log physical and emotional well-being.
- ✅ **Deep Insights & Charts**: Visualizes symptoms and task performance over time, making it easier to spot long-term trends and share data with doctors.
- ✅ **Push Notifications**: A dedicated Notification Service Extension to reliably remind users of pending tasks and daily check-ins.

---

## 📁 Project Structure
```text
├── 📁 ParkinsonBuddy/                 # Main App Target
│   ├── 📁 Controller/                 # UI Logic (CareFeed, Insights, Overview)
│   ├── 📁 Supporting Files/           # App logic, Survey definitions, Charts, Tasks
│   ├── 📁 Base.lproj/                 # Storyboards (Main, LaunchScreen)
│   ├── 📁 Assets.xcassets/            # App icons, colors, and task images (tap, memory, etc.)
│   ├── AppDelegate.swift              # App lifecycle
│   └── SceneDelegate.swift            # UI lifecycle
├── 📁 NotificationService/            # Push Notification Extension
│   ├── NotificationService.swift      # Notification handling logic
│   └── Info.plist
├── 📁 ParkinsonBuddyTests/            # Unit testing suite
├── 📁 ParkinsonBuddyUITests/          # UI interaction testing suite
└── 📁 ParkinsonBuddy.xcodeproj/       # Xcode Project configurations
```

---

## 🧠 System Architecture & Tech Stack

The app is built entirely natively for the Apple ecosystem to ensure maximum performance and accessibility:

* **Language**: Swift 5+
* **UI Framework**: UIKit (Storyboards & Programmatic UI)
* **Core Frameworks**: 
  * `CareKit` / `ResearchKit` concepts for task and medical data handling.
  * `UserNotifications` for local and push reminders.
  * Native Charting logic for the Insights dashboard.

---

## 🔧 Installation & Usage

### Prerequisites
- **macOS** (latest recommended version)
- **Xcode 14.0+** - An iOS Simulator or physical device running iOS 15.0+

### Build and Run
1. Clone the repository to your local machine:
   ```bash
   git clone [https://github.com/your-username/ParkinsonBuddy.git](https://github.com/your-username/ParkinsonBuddy.git)
   ```
2. Open the project in Xcode:
   ```bash
   cd ParkinsonBuddy
   open ParkinsonBuddy.xcodeproj
   ```
3. Allow Xcode a moment to resolve any dependencies (like Swift Packages) if present.
4. Select your preferred iPhone Simulator (e.g., iPhone 14 Pro) from the top device menu.
5. Hit `Cmd + R` or click the **▶ Play** button to compile and launch the application.

---

## 👥 Credits

Developed during the **Apple Foundation Program @ UNISA**.

* **Francesco Ferraù** - iOS Developer / Designer
* **Chiara Ferraioli** - iOS Developer / Researcher
