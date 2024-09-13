# Todo with Alarm

## Introduction
**Todo with Alarm** is a productivity-focused mobile app that helps users set and manage their tasks and goals with custom reminders. Whether it's setting daily tasks, tracking long-term goals, or getting timely reminders, this app aims to enhance productivity and keep users on track with their personal or professional objectives. The app leverages AI-based prioritization methods, goal tracking, and push notifications to help users stay organized and consistent.

## Who Should Use This App?
This app is perfect for:
- **Students** who need to manage their study schedules, assignments, and exams effectively.
- **Professionals** who wish to track work-related tasks, deadlines, and meetings.
- **Individuals** seeking to build habits and track their progress in areas such as fitness, reading, or personal growth.
- **Productivity enthusiasts** who want to stay disciplined and organized with customized daily reminders and routines.

## Key Features
- **Goal Creation & Management**: Set up to three key goals when starting the app, each with detailed parameters like name, priority, start date, and end date.
- **Task Management**: Easily create and manage daily tasks, with the ability to mark tasks as complete and view their progress.
- **Eisenhower Matrix Integration**: Use the Eisenhower Matrix for task prioritization to focus on the most urgent and important tasks.
- **Customizable Reminders**: Set reminders for tasks or goals at specific times to ensure you stay on track.
- **Daily Push Notifications**: Receive timely notifications for upcoming tasks and goal reviews.
- **Progress Tracking**: Track the percentage of goal completion and receive insights on daily task performance.
- **Recurring Tasks & Routines**: Set routines for tasks that repeat on a daily, weekly, or monthly basis.

## How to Run the App

### Requirements
- **Flutter SDK**: Version 3.x or higher
- **Dart**: Version 2.x or higher
- An emulator or real device for Android/iOS testing

### Steps to Run the App
1. **Clone the Repository**:  
   Run the following command to clone the project repository:
   ```bash
   git clone https://github.com/username/todo_with_alarm.git
   cd todo_with_alarm

2. **Install Dependencies**:
    Use the Flutter package manager to install the necessary dependencies:
    flutter pub get

3. **Run the App**:
    To launch the app, use the following command:
    flutter run

4. **Build APK for Android**:
    To build the Android APK:
    flutter build apk

5. **Build for iOS**:
    For iOS development, open the ios directory in Xcode, configure the signing settings, and build the app.

## Development Information

**Technologies Used**

	•	Flutter: The primary framework for building the user interface and handling state management.
	•	Dart: The programming language used with Flutter.
	•	Flutter Local Notifications: A package to handle scheduling and sending push notifications for task reminders.
	•	SharedPreferences: Used for local storage of user goals and task progress.
	•	Timezone Package: For managing notification scheduling based on the user’s timezone.

**Project Structure**

lib/
│
├── app/                # Contains the main app setup files
├── models/             # Data models for goals, todos, and notifications
├── screens/            # UI screens for goal input, home, progress, etc.
├── services/           # Contains services like GoalService and NotificationService
├── utils/              # Utility functions
└── widgets/            # Custom widgets used across screens

**Flutter SDK Version**

	•	Flutter SDK Version: 3.x.x
	•	Dart Version: 2.x.x

**Platforms Supported**

	•	Android
	•	iOS
    •	MacOS
    •	Chrome

**Running Tests**

Unit and widget tests are included in the test/ directory:
	•	Run the following command to execute tests:
    flutter test