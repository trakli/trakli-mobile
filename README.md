<p align="center"><a href="#" target="_blank"><img src="https://raw.githubusercontent.com/whilesmart/trakli/main/logo.svg" width="400" alt="Trakli Logo"></a></p>

# Trakli

## Overview

Trakli is a personal income tracking application. The application allows users to manage and categorize their income and expenses under various groups.

## Features

- Register and log in to the application
- Manage user profile information
- Create, view, update, and delete groups (e.g., Home, Office, Personal)
- Manage income categories (e.g., Sales, Salary, Gift, Bonus, Interest)
- Manage expense categories (e.g., Utilities, Transport, Electricity, Rent, Tax, Health)
- Manage parties (e.g., individuals or entities from which money comes or goes)
- Manage wallets and bank accounts (e.g., cash, bank accounts)
- Record income and expense entries with details such as date, party, description, source/target wallet, and optional attachments

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## CI / GitHub Actions

Fastlane is used for iOS and Android builds and releases (TestFlight, Play Store, Firebase). Required **secrets and variables** are documented in [.github/ENV_AND_SECRETS.md](.github/ENV_AND_SECRETS.md). Configure them under **Settings → Secrets and variables → Actions**.

<!-- 
flutterfire configure \
  --project=trakli \
  --out=lib/firebase_options_dev.dart \
  --android-app-id=com.whilesmart.trakli.dev
  --ios-bundle-id=com.whilesmart.trakli.dev
  --yes   -->
