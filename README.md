# TravelMate

## Project Description

TravelMate is a ride-sharing application designed to make it easy for users to organize or join lifts to various destinations. The app is built using Flutter and Firebase, providing a seamless experience for users to find rides, book seats, and manage their wallet balance.
Features

## Technologies Used

- **Flutter**: The app is built using the Flutter framework for cross-platform mobile development.
- **Firebase**: Used for backend services, including authentication and real-time database functionality.
- **Google Maps API**: Utilized to enhance location-based features.
- **MVVM Architecture**: The app follows the Model-View-ViewModel architectural pattern for a scalable and maintainable codebase.

Explanation:

- `data`: Manages data-related concerns such as models and repositories.
    - `models`: Data models representing entities like User, Lift, and Notification.
    - `repositories`: Classes responsible for handling data operations for each entity.
- `providers`: Contains provider classes for managing state.
- `services`: Handles external services like Firebase, Google Maps, SendGrid.
- `ui`: Contains UI-related components, organized by screens and functionality.
    - `pages`: Divided into sub-folders based on the user journey or feature.
    - `widgets`: Reusable widgets used across multiple screens.
- `utils`: Contains utility classes and constants used throughout the app
- `viewmodels`: Manages the application's logic, following the MVVM pattern.
- `firebase_options.dart`: Contains Firebase configuration options.


## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase Project](https://console.firebase.google.com/): Set up a project on Firebase and configure the necessary services.
- [Google Maps API Key](https://cloud.google.com/maps-platform/): Get an API key for using Google Maps services.

### Environment Variables

Create a `.env` file in the root directory of the project and add the following:

```env
# Firebase & Google Cloud Configuration
ANDROID_FIREBASE_API_KEY=your_firebase_api_key
GOOGLE_CLOUD_MAP_ID=your_google_cloud_map_id

```

Replace the placeholder values with your actual API keys and Firebase configuration.

## Running TravelMate
1. Clone the repository: `git@github.com:SivuziweNogubha/Travel.git`
2. Navigate to the project directory: `cd TravelMate`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`
