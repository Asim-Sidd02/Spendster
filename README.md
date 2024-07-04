# Spendster An Expense Tracking App

## _A comprehensive expense tracking app built with Flutter to manage personal and business finances._

<img src="https://github.com/Asim-Sidd02/Spendster/blob/main/preview.gif" alt="App Preview" width="400" height="800">



## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [File Structure](#file-structure)
- [Dependencies](#dependencies)
- [Author](#author)
- [License](#license)

## Introduction

Flutter Expense Tracker is a powerful tool designed to simplify expense management. Whether you're tracking personal finances or business expenses, this app provides intuitive features to help you stay organized and in control.

## Features

- Log expenses with details like title, amount, category, and date.
- Categorize expenses into customizable categories for better organization.
- View detailed insights with interactive charts and graphs to analyze spending patterns.
- Secure authentication with Firebase ensures data protection.
- Real-time synchronization across devices for up-to-date information.
- Personalize profiles with photos and user details.
- Responsive UI design that works seamlessly on both mobile and tablet devices.

## Prerequisites

Before running the application, ensure you have the following installed:

- Flutter SDK
- Dart SDK
- Android SDK / Xcode (depending on your target platform)
- IDE (e.g., VS Code, Android Studio) with Flutter and Dart plugins

## Installation

Clone the repository:

```sh
git clone https://github.com/Asim-Sidd02/Spendster.git
cd Spendster
```
Install the dependencies using flutter:

```sh
flutter pub get
```
Run the project:

```sh
flutter run
```
## File Structure

The project directory structure is organized as follows:

- **lib/**: Main application code
  - **models/**: Data models used in the application
  - **screens/**: UI screens of the application
  - **services/**: Backend services handling data retrieval and storage

  
- **pubspec.yaml**: Flutter project configuration file with dependencies and other settings.

## Dependencies

This project relies on the following Flutter packages:

- **provider**: State management solution for managing app state.
- **firebase_auth**: Firebase Authentication for user authentication.
- **firebase_storage**: Firebase Storage for storing user data.
- **firebase_core**: Firebase Core for initializing Firebase services.
- **intl**: Internationalization support for formatting dates.

These dependencies are specified in the **pubspec.yaml** file.
## Author

- **Asim Siddiqui**
- **Contact Information**
  - Email: asimsiddiqui8181@gmail.com
  - LinkedIn: [Asim Siddiqui](https://www.linkedin.com/in/asim-siddiqui-a71731229/)
  - Portfolio: [Asim Sidd](https://asimsidd.vercel.app/)


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

