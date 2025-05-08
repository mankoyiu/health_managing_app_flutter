# Health Management App

A cross-platform Flutter app for managing personal health information, medication profiles, shopping for health products, and accessing telehealth services.

---

 Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Pages Overview](#pages-overview)
- [Technologies Used](#technologies-used)

---

 Introduction
 
This app is a comprehensive health management app that allows users to:
- Store and manage personal and medical information
- Track medications and health activities
- Consult medical experts
- Shop for health-related products
- Access telehealth services

The app is designed for ease of use and can be run on Android, iOS, web, macOS, Windows, and Linux platforms.

---

 Features
- Personal Information Management: Input and save personal, medical, and family history.
- Medication Profile: View and manage a list of medications, with details loaded from local data.
- Activity Tracking: Map-based activity view for health and fitness tracking.
- Drug Information: Quick access to drug information via WebMD.
- Ask Experts: Submit enquiries to medical experts with optional file attachments.
- Telehealth Consultation: One-tap access to Zoom for online consultations.
- Product List & Shopping Cart: Browse health products, add to cart, and checkout.
- Persistent Storage: Uses shared preferences for saving user data locally.
- Responsive UI: Optimized for both mobile and desktop screens.

---

 Installation
# Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.2.1 <4.0.0)
- Git

# Steps

git clone <repository-url>
cd xmed
flutter pub get
flutter run


For web:

flutter run -d chrome


---

 Usage
- Launch the app on your preferred device or emulator.
- Use the navigation drawer or bottom navigation to switch between pages.
- Enter and save your personal and medical information.
- Browse and add products to your shopping cart, then checkout.
- Click on 'Drug Information' to open WebMD in your browser.
- Use 'Ask Experts' to send questions to medical professionals.
- Start a telehealth consultation via Zoom.

---

 Pages Overview
- Personal Information Page (`/`):
  - Manage personal, medical, and family history. Data is saved locally.
- Medication Profile Page:
  - Shows a list of medications and details (data loaded from local JSON).
- Activity Page:
  - Displays a map-based activity tracker for health/fitness.
- Drug Information Page:
  - Opens WebMD for drug research.
- Ask Experts Page:
  - Form to submit questions to experts, with optional file upload.
- Telehealth Consultation Page:
  - Opens Zoom for online medical consultations.
- Product List Page:
  - Browse and add health products to cart.
- Shopping Cart Page (`/cart`):
  - View, modify, and checkout products in your cart.

---

 Technologies Used
- Flutter (Dart)
- Provider (State management)
- Shared Preferences (Local storage)
- URL Launcher (Open external links)
- Image Picker (File attachments)
- Fluttertoast (User notifications)
- Badges (Cart UI)
- Material Design (UI/UX)
