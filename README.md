# 🌱 Green Yuva (ग्रीन युवा)
### *Youth-Led Climate Action & Campus Decarbonization Ecosystem*

<p align="center">
  <img src="screenshots/showcase/01_home_dashboard.png" alt="Green Yuva Banner" width="280" />
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" /></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-Storage%20%7C%20DB-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase" /></a>
  <a href="https://ai.google.dev"><img src="https://img.shields.io/badge/Google%20Gemini-1.5%20Pro-8E75B2?style=for-the-badge&logo=google-gemini&logoColor=white" alt="Gemini AI" /></a>
  <a href="https://cpcb.nic.in"><img src="https://img.shields.io/badge/CPCB%20India-Live%20AQI-1B5E20?style=for-the-badge&logo=airplay&logoColor=white" alt="CPCB AQI" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" /></a>
</p>

---

## 📌 Table of Contents
- [🌍 Vision & The Problem](#-vision--the-problem)
- [✨ Core Innovation Pillars](#-core-innovation-pillars)
- [🏛️ System Architecture](#️-system-architecture)
- [🔄 User Journey & Action Workflow](#-user-journey--action-workflow)
- [📱 Mobile App Showcase (15 Live Screens)](#-mobile-app-showcase)
- [🛠️ Technology Stack & Ecosystem](#️-technology-stack--ecosystem)
- [🔐 Multi-Cloud & Security Architecture](#-multi-cloud--security-architecture)
- [🚀 Installation & Getting Started](#-installation--getting-started)
- [🗺️ Campus Decarbonization Roadmap](#️-campus-decarbonization-roadmap)

---

## 🌍 Vision & The Problem

Across India's **40,000+ higher education institutions**, millions of students inhabit micro-cities that consume massive amounts of energy, generate metric tons of single-use waste, and face severe urban air quality hazards ($PM_{2.5}$ and $PM_{10}$).

While youth desire to participate in ecological stewardship, traditional climate initiatives suffer from three fatal friction points:
1. **The Intangibility Deficit**: Students cannot observe the localized, verifiable carbon impact of their daily choices.
2. **Missing Hyperlocal Incentives**: Eco-actions are treated as volunteer chores without gamified feedback, peer competition, or tangible campus utility.
3. **Linear Campus Consumption**: Textbooks, drafters, calculators, and lab gear are discarded at the end of each academic semester instead of circulating within the campus economy.

### 💡 The Green Yuva Solution
**Green Yuva** is a high-octane, gamified campus climate ecosystem engineered with a **Neo-Brutalist design language**. It bridges real-world physical eco-actions with digital verification, tokenized **Karma Coins**, live **Central Pollution Control Board (CPCB)** air monitoring, an **offline-first tactical campus radar (GreenRush)**, a circular student marketplace (**YuvaSwap**), and an on-device AI climate tutor (**YuvaSathi AI**).

```
   [ Real-World Student Eco Action ] 
                 ↓
  [ Geo-Fenced Proximity & Photo Proof ] 
                 ↓
  [ Dual-Engine Cloud Verification (Firebase + Supabase) ]
                 ↓
  [ Karma Coins & Campus Streak Accrual ] 
                 ↓
  [ Campus Canteen Perks & YuvaSwap Circular Commerce ]
```

---

## ✨ Core Innovation Pillars

### 1. ⚡ GreenRush — Tactical Campus Eco-Radar
* **Hyperlocal GPS Geo-Fencing**: Interactive radar view pinpointing active campus decarbonization hubs (e.g., PCCOE, COEP, VIT, solar microgrids, compost facilities, Miyawaki forests).
* **Live Distance & Proximity Locking**: Missions unlock only when students are physically within the verified campus perimeter (<50 meters).
* **Camera Proof Verification**: Real-time snapshot submission with auto-queued offline upload resilience.

### 2. 🔄 YuvaSwap — Circular Campus Marketplace
* **Zero-Waste Student Economy**: Buy, sell, or donate pre-owned engineering drawing drafters, scientific calculators, lab aprons, and semester textbooks.
* **CO₂ & Landfill Diverted Metrics**: Every completed transaction computes kilograms of paper and carbon emissions diverted from urban landfills.
* **Direct In-App Chat & Safety**: Verified student-to-student exchange with designated campus meeting zones.

### 3. 📊 YuvaSense — Real-Time Indian Environmental Intelligence
* **Live CPCB India & OpenAQ Integration**: Real-time monitoring of $PM_{2.5}$, $PM_{10}$, $NO_2$, $SO_2$, and composite AQI for Indian metropolitan and tier-2 college hubs.
* **IMD Disaster Weather Warning Bulletins**: Early-warning alerts for Western Disturbances, flash floods, heatwaves, and seasonal smog spikes.
* **India Action Case Studies**: Curated deep-dives on national benchmarks—Rewa Ultra Mega Solar (MP), Indore Asia's Largest Bio-CNG Plant, and Sikkim's 100% Organic Farming Revolution.
* **Gamified Climate Quizzes**: Rapid-fire trivia modules covering Renewable Energy, SDG 13, Carbon Offsets, and Waste Segregation.

### 4. 🤖 YuvaSathi AI — Personalized Campus Eco-Tutor
* **Powered by Google Gemini 1.5 Pro**: Multimodal intelligence fine-tuned for college zero-waste living, recycling categorization, and carbon calculations.
* **Context-Aware Suggestions**: Recommends personalized campus missions based on the student's branch, hostel location, and daily commute pattern.

### 5. 🪙 Karma Canteen & Dual-Token Economy
* **Tangible Utility for Climate Action**: Students redeem earned Karma Coins for campus canteen meals, library fine waivers, cafeteria beverages, and student giveaways.
* **Daily Streak Multipliers**: Promotes sustained habit formation with milestone badges and university leaderboard rankings.

---

## 🏛️ System Architecture

```mermaid
flowchart TD
    %% CLIENT LAYER
    subgraph ClientPresentation["📱 CLIENT PRESENTATION & UI LAYER (Flutter 3.x / Dart)"]
        direction TB
        UIFramework["Neo-Brutalist UI Framework<br/>• Bold 3px High-Contrast Borders<br/>• Flat Saturated Color Blocking<br/>• Tactile Depth & Micro-Interactions"]
        RadarEngine["GreenRush Tactical Radar Engine<br/>• CustomPainter Dynamic Canvas<br/>• Compass Bearing & Gyro Orientation<br/>• Smooth Polar Grid & Target Blips"]
        CampusHubsUI["Interactive Campus Modules<br/>• YuvaSwap Circular Marketplace<br/>• YuvaSense Real-Time Sensor Hub<br/>• YuvaVibe College Community Feeds"]
        KarmaCanteenUI["Karma Canteen & Rewards Portal<br/>• Dynamic Vector QR Code Voucher Engine<br/>• Daily Streak Counter & Milestone Badges"]
    end

    %% CLIENT LOGIC & STATE
    subgraph ClientLogic["⚙️ CORE APPLICATION SERVICES & LOGIC LAYER"]
        direction TB
        StateMgr["Reactive State Orchestrator<br/>• StreamBuilders & ValueNotifiers<br/>• Optimistic UI Updates"]
        LocSvc["LocationService<br/>• Geolocator GPS Subsystem<br/>• Haversine Distance & Geo-Fence Proximity (<50m)"]
        AqiSvc["AqiService<br/>• CPCB & OpenAQ Telemetry Aggregator<br/>• India Standard AQI Calculator"]
        SwapSvc["YuvaSwapService<br/>• P2P Item Catalog & Negotiation<br/>• CO₂ & Landfill Diversion Formulas"]
        AiSvc["YuvaSathi AIService<br/>• Google Gemini 1.5 Pro Context Pipeline<br/>• Multi-turn Zero-Waste Campus Tutor"]
        RewardSvc["RewardService<br/>• Karma Ledger & Anti-Tamper Balance<br/>• Canteen Voucher Validation"]
        OfflineSync["OfflineCacheService<br/>• SharedPreferences & Memory FIFO Queue<br/>• Network Connectivity Auto-Retry Sync"]
    end

    %% DUAL CLOUD INFRASTRUCTURE
    subgraph CloudInfra["☁️ DUAL-ENGINE CLOUD INFRASTRUCTURE"]
        direction TB
        subgraph FirebaseStack["🔥 Google Firebase Cluster"]
            FAuth["Firebase Auth<br/>• Email / Password Verification<br/>• Secure JWT & User Sessions"]
            Firestore["Cloud Firestore (Real-Time NoSQL)<br/>• /users (Karma Balance & Streaks)<br/>• /missions (Active Campus Hubs)<br/>• /verifications (Proof Ledger)<br/>• /swap_items (Marketplace Catalog)<br/>• /notifications (Push Broadcasts)"]
        end
        subgraph SupabaseStack["⚡ Supabase Cloud Infrastructure"]
            SupaStorage["Supabase S3 Object Storage<br/>• avatars/ (User Profiles)<br/>• proofs/ (Mission Verification Photos)<br/>• swap_images/ (Marketplace Items)"]
            SupaDB["Supabase Postgres DB<br/>• Structured Relational Fallback<br/>• Storage Security & CDN Edge"]
        end
    end

    %% VERIFICATION & ADMIN PIPELINE
    subgraph VerificationPipeline["🛡️ MISSION VERIFICATION & MODERATION PIPELINE"]
        direction TB
        SubmissionIngest["Proof Ingestion Engine<br/>• EXIF Metadata Stripping<br/>• Geo-Stamp & Timestamp Tagging"]
        AdminModeration["Admin Moderation Console<br/>• Side-by-Side Photo & GPS Audit<br/>• One-Click Approve / Reject"]
        TokenDispatcher["Karma Mint & Streak Dispatcher<br/>• Real-Time Firestore Transaction<br/>• Push Notification Trigger"]
    end

    %% EXTERNAL INTELLIGENCE & TELEMETRY
    subgraph ExternalFeeds["🌐 EXTERNAL INTELLIGENCE & TELEMETRY FEEDS"]
        direction TB
        GeminiAPI["Google Gemini 1.5 Pro API<br/>• High-Speed Multimodal Eco-Reasoning"]
        CPCBSensors["CPCB India & OpenAQ Sensors<br/>• Live PM2.5, PM10, NO₂, SO₂ Feeds"]
        IMDBulletin["IMD Disaster Warning Service<br/>• Western Disturbances & Extreme Weather Alerts"]
        UPIEngine["Unified Payments Interface (UPI)<br/>• Direct UPI Deep-Link Protocol (upi://pay)"]
    end

    %% CONNECTIONS & FLOWS
    ClientPresentation ==> ClientLogic
    
    LocSvc -->|"Proximity Stamp"| SubmissionIngest
    ClientLogic -->|"Auth & Realtime Sync"| FirebaseStack
    ClientLogic -->|"Media Ingestion (HTTP Multi-Part)"| SupaStorage
    OfflineSync -.->|"Cache Fallback & Re-Sync"| ClientPresentation

    SubmissionIngest --> AdminModeration
    AdminModeration --> TokenDispatcher
    TokenDispatcher -->|"Credit Coins & Streaks"| Firestore
    TokenDispatcher -->|"Real-Time Push Alert"| ClientPresentation

    AiSvc <-->|"REST / HTTPS TLS"| GeminiAPI
    AqiSvc <-->|"Sensor Telemetry JSON"| CPCBSensors
    AqiSvc <-->|"Weather Bulletins"| IMDBulletin
    KarmaCanteenUI -->|"Deep Link UPI QR"| UPIEngine
```

---

## 🔄 User Journey & Action Workflow

```mermaid
sequenceDiagram
    autonumber
    actor Student as 🎓 College Student
    participant App as 📱 Green Yuva Client
    participant Radar as 🎯 GreenRush Radar
    participant Cloud as ☁️ Firebase & Supabase
    participant Admin as 🛡️ Campus Admin Panel
    participant Canteen as ☕ Karma Canteen

    Student->>App: Launch App & Auto-Detect Campus (GPS)
    App->>Cloud: Fetch Live AQI & Active Missions
    Cloud-->>App: Return Hyperlocal Missions & CPCB AQI
    Student->>Radar: Navigate to Active Mission Hub (e.g. Miyawaki Drive)
    Radar-->>Student: Proximity Unlocked (<50m to Geo-Fence)
    Student->>App: Complete Action & Capture Photo Proof
    App->>Cloud: Upload Image to Supabase S3 & Log in Firestore
    Cloud->>Admin: Push to Moderation Queue
    Admin->>Cloud: Approve Proof & Verify Geo-Stamp
    Cloud-->>App: Real-Time Notification: +50 Karma Coins Awarded!
    App->>Student: Update Daily Streak & Karma Balance
    Student->>Canteen: Open Karma Canteen & Select Chai / Snack Voucher
    Canteen-->>Student: Generate Dynamic Redeem QR Code
```

---

## 📱 Mobile App Showcase

Every screen in Green Yuva has been crafted with a distinctive **Neo-Brutalist UI**—featuring bold high-contrast strokes, vivid primary cards, tactile depth, and instant responsiveness.

### 🌟 Part 1: Home Dashboard, Live Notifications & Module Hubs
| 01. Home Dashboard & AQI | 02. Real-time Notifications | 03. Green Yuva Hubs |
| :---: | :---: | :---: |
| <img src="screenshots/showcase/01_home_dashboard.png" width="100%" alt="Home Dashboard" /> | <img src="screenshots/showcase/02_notifications.png" width="100%" alt="Notifications" /> | <img src="screenshots/showcase/03_green_yuva_hubs.png" width="100%" alt="Module Hubs" /> |
| *Live CPCB AQI, active streak counter, Karma Coins display, and instant Canteen shortcuts.* | *Push alerts for verification approvals, university giveaways, and streak reminders.* | *Full navigation hub: YuvaSwap, GreenRush Radar, YuvaSense, and YuvaVibe.* |

---

### 🌟 Part 2: Campus Community, College Hubs & YuvaSwap
| 04. Community Actions | 05. YuvaVibe College Hubs | 06. YuvaSwap Marketplace |
| :---: | :---: | :---: |
| <img src="screenshots/showcase/04_community_actions.png" width="100%" alt="Community Actions" /> | <img src="screenshots/showcase/05_yuvavibe_campus_hubs.png" width="100%" alt="College Hubs" /> | <img src="screenshots/showcase/06_yuvaswap_marketplace.png" width="100%" alt="YuvaSwap Marketplace" /> |
| *Miyawaki afforestation, hostel compost drives, and solar audit community initiatives.* | *Pune regional engineering hubs: PCCOE, COEP Tech, and VIT Pune leaderboards.* | *Circular student exchange: Pre-owned gear, calculated CO₂ and landfill diversion.* |

---

### 🌟 Part 3: Swap Listings, GreenRush Radar & Live CPCB AQI
| 07. Post Swap Item | 08. GreenRush Tactical Radar | 09. YuvaSense CPCB AQI |
| :---: | :---: | :---: |
| <img src="screenshots/showcase/07_create_swap_item.png" width="100%" alt="Create Swap Item" /> | <img src="screenshots/showcase/08_greenrush_radar_map.png" width="100%" alt="GreenRush Radar" /> | <img src="screenshots/showcase/09_yuvasense_cpcb_aqi.png" width="100%" alt="YuvaSense CPCB AQI" /> |
| *Publish textbooks, lab coats, and drafters with instant condition badges and pricing.* | *Neo-Brutalist GPS radar scanning campus missions with dynamic compass orientation.* | *Live Central Pollution Control Board telemetry: PM2.5, PM10, and health warnings.* |

---

### 🌟 Part 4: Interactive Quizzes, Disaster Bulletins & Indian Case Studies
| 10. Climate Quizzes | 11. IMD Disaster Tracker | 12. Indian Benchmark Cases |
| :---: | :---: | :---: |
| <img src="screenshots/showcase/10_yuvasense_quizzes.png" width="100%" alt="Climate Quizzes" /> | <img src="screenshots/showcase/11_disaster_tracker.png" width="100%" alt="Disaster Tracker" /> | <img src="screenshots/showcase/12_indian_case_studies.png" width="100%" alt="Indian Case Studies" /> |
| *Engaging climate challenges on carbon footprints, SDG 13, and solar photovoltaics.* | *Real-time IMD alert bulletins for Western Disturbances and smog flash-points.* | *National benchmarks: Rewa Solar Park, Indore Bio-CNG, and Sikkim 100% Organic.* |

---

### 🌟 Part 5: AI Climate Tutor, Campus Sprint & User Profile
| 13. YuvaSathi AI Tutor | 14. Campus Activities Sprint | 15. User Profile & Karma History |
| :---: | :---: | :---: |
| <img src="screenshots/showcase/13_yuvasathi_ai_tutor.png" width="100%" alt="YuvaSathi AI" /> | <img src="screenshots/showcase/14_campus_activities.png" width="100%" alt="Campus Activities" /> | <img src="screenshots/showcase/15_user_profile.png" width="100%" alt="User Profile" /> |
| *Intelligent conversational assistant for campus zero-waste tips and project guidance.* | *PCCOE Pawana River Desilting Drive and Campus Solar Microgrid Audit tracks.* | *Eco Campus Champion rank, 100 Karma Coins, badges, and complete action ledger.* |

---

## 🛠️ Technology Stack & Ecosystem

<p align="center">
  <img src="https://skillicons.dev/icons?i=flutter,dart,firebase,supabase,postgres,android,apple,gcp,git,github" alt="Green Yuva Ecosystem Stack" />
</p>

| Logo | Technology | Domain | Role & Implementation in Green Yuva |
| :---: | :--- | :--- | :--- |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="48" height="48" alt="Flutter" /> | **Flutter 3.x** | Client Framework | Cross-platform multi-threaded native rendering for Android & iOS |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="48" height="48" alt="Dart" /> | **Dart 3.x** | Core Language | Sound null-safety, strong typing, asynchronous event loop & isolates |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg" width="48" height="48" alt="Firebase" /> | **Google Firebase** | Cloud Backend | Reactive Cloud Firestore NoSQL, Firebase Auth session lifecycle & push feeds |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/supabase/supabase-original.svg" width="48" height="48" alt="Supabase" /> | **Supabase Cloud** | Distributed Storage | S3-compatible cloud storage for `avatars`, `proofs`, and `swap_images` |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" width="48" height="48" alt="PostgreSQL" /> | **PostgreSQL** | Relational Store | Resilient relational fallback and high-throughput diagnostic telemetry store |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/googlecloud/googlecloud-original.svg" width="48" height="48" alt="Google Gemini AI" /> | **Google Gemini AI** | Artificial Intelligence | Multimodal reasoning engine for YuvaSathi AI campus conversational tutoring |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/google/google-original.svg" width="48" height="48" alt="Google Maps Platform" /> | **Google Maps & CPCB** | Geospatial & Telemetry | Live CPCB India & OpenAQ air quality telemetry + Google Maps SDK integration |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg" width="48" height="48" alt="Android" /> | **Android SDK** | Native OS Target | Material Neo-Brutalism system widgets, camera hardware & GPS sensor integration |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/apple/apple-original.svg" width="48" height="48" alt="Apple iOS" /> | **Apple iOS** | Native OS Target | Cupertino compatibility layer, location permissions & smooth 60fps animations |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" width="48" height="48" alt="Git" /> | **Git & GitHub** | Source Control | Distributed version control, continuous verification & modular architecture |

---

## 🔐 Multi-Cloud & Security Architecture

### 1. Hybrid Dual-Engine Cloud Pipeline
Green Yuva implements an enterprise-grade **multi-cloud hybrid architecture**:
* **Sub-Second Real-Time Synchronization**: Firebase Cloud Firestore manages reactive state changes (leaderboard rankings, Karma Coin balances, instant notifications, and moderation queues) with continuous WebSocket listeners.
* **Distributed Binary Storage**: Supabase S3 handles large multi-part media uploads across isolated buckets:
  * `avatars`: User profile pictures with automatic public CDN edge caching.
  * `proofs`: Geo-tagged mission verification images submitted by students.
  * `swap_images`: Multi-photo student marketplace item listings.

### 2. High-Availability Offline Resilience
Campus life frequently involves subterranean classrooms, workshops, and basements with poor cellular reception. Green Yuva's `OfflineCacheService` guarantees seamless operation:
* **Optimistic Local Storage**: Mission lists, CPCB AQI snapshots, and quiz questions are cached locally via `SharedPreferences` and in-memory caches.
* **Pending Submission Queue**: When actions or proofs are submitted offline, they are automatically held in a local FIFO queue and pushed to the cloud backend as soon as connectivity is restored.

---

## 🚀 Installation & Getting Started

### Prerequisites
* **Flutter SDK**: `>=3.19.0`
* **Dart SDK**: `>=3.3.0`
* **Android Studio / VS Code** with Flutter and Dart extensions
* An active **Firebase Project** (`google-services.json` in `android/app/`)
* An active **Supabase Project** with buckets: `avatars`, `proofs`, `swap_images`

### 1. Clone the Repository
```bash
git clone https://github.com/madhavzanwar/green-yuva.git
cd green-yuva
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment Credentials
Create a `.env` file in the root directory (or inject via `--dart-define`):
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
GEMINI_API_KEY=your-google-gemini-api-key
```

### 4. Run Static Analysis & Code Verification
```bash
dart analyze lib
```

### 5. Launch Application
```bash
# Debug run on connected Android device or emulator
flutter run

# Build production release APK
flutter build apk --release
```

---

## 🗺️ Campus Decarbonization Roadmap

- [x] **Phase 1: Foundation & Identity** — Complete Neo-Brutalist design overhaul, Green Yuva brand identity, and multi-cloud sync.
- [x] **Phase 2: Hyperlocal GreenRush Radar** — GPS-enabled tactical radar with geo-fenced campus mission hubs.
- [x] **Phase 3: YuvaSwap Circular Marketplace** — Student-to-student exchange with automated CO2 savings algorithms.
- [x] **Phase 4: YuvaSense & Real-Time CPCB AQI** — Central Pollution Control Board live telemetry and IMD disaster warnings.
- [x] **Phase 5: Karma Canteen & UPI Tokenomics** — Real-world perks redeemable at college cafeterias.
- [ ] **Phase 6: Multi-University Inter-Campus League** — State-level leaderboards comparing carbon offsets between institutions.
- [ ] **Phase 7: IoT Smart Bin Integration** — NFC/QR-enabled smart waste bins that instantly dispense Karma Coins upon e-waste disposal.

---

<p align="center">
  <b>Built with 💚 for India's Youth & A Sustainable Tomorrow.</b><br/>
  <sub>Released under the MIT License.</sub>
</p>
