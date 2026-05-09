# Travel Buddy 🗺

A Flutter Android app to discover, save and share travel destinations with gamification features.

## Setup

### 1. Add your Google Maps API key
Open `android/app/src/main/AndroidManifest.xml` and replace:
```
android:value="YOUR_GOOGLE_MAPS_API_KEY"
```
with your actual key from Google Cloud Console.

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run
```bash
flutter run
```
Requires an Android device or emulator (API 26+).

---

## What's built

- Google Maps with real-time location and color-coded markers
- Search bar with live filtering
- Category filter chips (Food, Drinks, Attractions, Nightlife, Shopping, Nature, Activities)
- Three view modes: Map, Grid, List
- Place detail bottom sheet (Save, Share, Directions, Mark as Visited)
- SQLite database via sqflite — full CRUD operations
- Student discount badges on qualifying places
- Mark as Visited with +10 XP reward
- XP leveling system (saves = +5 XP, visits = +10 XP)
- Achievement badges (First Visit, 5 Saved, Foodie, etc.)
- Streak tracking
- Travel tips with tag filtering
- Student Mode toggle, settings persisted via SharedPreferences

## Project structure

```
lib/
├── main.dart
├── app_state.dart          ← Provider (global state)
├── data/
│   ├── db/app_database.dart  ← SQLite CRUD
│   └── model/place.dart      ← Place model + demo data
├── screens/
│   ├── main_screen.dart      ← Bottom nav shell
│   ├── explore_screen.dart   ← Map + search + filters
│   ├── saved_screen.dart     ← Favorites list
│   ├── tips_screen.dart      ← Travel tips
│   └── profile_screen.dart   ← Stats + achievements + settings
└── widgets/
    ├── place_card.dart       ← Grid and list card variants
    └── place_detail_sheet.dart ← Bottom sheet
```

## Packages used

| Package | Purpose |
|---|---|
| google_maps_flutter | Map display and markers |
| geolocator | GPS location |
| permission_handler | Location permission flow |
| sqflite | SQLite database |
| provider | State management |
| share_plus | Android share sheet |
| url_launcher | Google Maps directions |
| shared_preferences | Persist settings |
| http | Future Places API calls |
