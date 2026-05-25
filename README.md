# Bubbl

Bubbl is an iOS messaging application built with SwiftUI, following the MVVM + Repository architecture. It uses Firebase for authentication and real-time database (Firestore).

## Tech Stack
- **Language:** Swift 5.9
- **UI:** SwiftUI (iOS 15 baseline)
- **Architecture:** MVVM + Repository
- **Backend:** Firebase (FirebaseAuth, FirebaseFirestore)
- **Deployment Target:** iOS 15.0

## Features
- User Authentication (Email/Password)
- Real-time messaging
- Conversation list with latest message and unread counts
- Start new conversations by searching users
- Profile management

## Setup Instructions

### Cloning and Running on macOS
1. Open Terminal and clone the repository:
   ```bash
   git clone https://github.com/yourusername/bubbl.git
   ```
2. Open the project in Xcode 15:
   - Double-click `Bubbl.xcodeproj` to open it.
   - Wait for Xcode to resolve the Swift Package Manager (SPM) dependencies.
3. Build and run the app (⌘R) on an iOS 15+ simulator or device.

### Firebase Configuration
1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an iOS app with the project's bundle ID.
3. Download `GoogleService-Info.plist` and drag it into the Xcode project root.
4. Enable **Email/Password** authentication in Firebase Auth.
5. Create a Firestore database and update the security rules as defined in the architecture.

## System Requirements
- Xcode 15.0
- macOS Ventura 13.6.1 or later
- Minimum iOS Target: 15.0
