# Contributing to Trakli

Thank you for considering contributing to Trakli! We welcome all kinds of contributions including bug reports, feature requests, documentation improvements, and code.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
    - [Reporting Bugs](#reporting-bugs)
    - [Suggesting Features](#suggesting-features)
    - [Improving Documentation](#improving-documentation)
    - [Submitting Code Changes](#submitting-code-changes)
3. [Setting Up the Development Environment](#setting-up-the-development-environment)
4. [Style Guide](#style-guide)
5. [Commit Messages](#commit-messages)
6. [License](#license)

## Code of Conduct

This project and everyone participating in it are governed by the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

If you find a bug in the source code, you can help us by submitting an issue to our [GitHub Issue Tracker](https://github.com/whilesmart/trakli/issues). When filing an issue, please provide the following information:

- A descriptive title and summary.
- Steps to reproduce the issue.
- The expected behavior.
- The actual behavior.
- Screenshots or code snippets (if applicable).
- Your environment details (Flutter version, device/emulator, etc.).

### Suggesting Features

We welcome suggestions for new features. Please submit your ideas to our [GitHub Issue Tracker](https://github.com/whilesmart/trakli/issues). When suggesting a feature, please provide:

- A clear and descriptive title.
- A detailed description of the feature and its benefits.
- Any potential use cases or examples.

### Improving Documentation

Improving documentation is a great way to start contributing. You can help by:

- Updating or expanding the project's README.
- Creating or improving guides and tutorials.
- Ensuring code comments are clear and helpful.

### Submitting Code Changes

We follow the [GitHub Flow](https://guides.github.com/introduction/flow/) for our development process. To contribute code:

- Fork the repository.
- Create a new branch (`git checkout -b feature/your-feature`).
- Make your changes.
- Ensure your changes adhere to our [Style Guide](#style-guide).
- Commit your changes (`git commit -m 'Add some feature'`).
- Push to the branch (`git push origin feature/your-feature`).
- Open a pull request.

Please ensure your code passes all tests and does not introduce any new issues.

## Setting Up the Development Environment

To contribute to this project, you need to set up the development environment with the following minimum requirements:

- **Flutter 3.22.2 or higher**: Ensure you have Flutter installed. Follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install) to install Flutter.

To check your Flutter version, run:
```bash
flutter --version
```

To set up the project:

1. Clone the repository:
    ```bash
    git clone git@github.com:whilesmart/trakli-mobile.git # or use gh repo clone whilesmart/trakli-mobile
    cd trakli-mobile
    ```

2. Fetch the dependencies:
    ```bash
    flutter pub get
    ```

3. Run the project:
    ```bash
    flutter run
    ```

## Style Guide

Please ensure your code follows our style guidelines:

- Use Dart's formatting standards (`flutter format .`).
- Write clear, concise comments where necessary.
- Follow best practices for Flutter and Dart.

## Commit Messages

Write clear and meaningful commit messages. Use the following structure:

- **feat**: A new feature.
- **fix**: A bug fix.
- **docs**: Documentation only changes.
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc.).
- **refactor**: A code change that neither fixes a bug nor adds a feature.
- **test**: Adding missing or correcting existing tests.
- **chore**: Changes to the build process or auxiliary tools and libraries.

## License

By contributing to Trakli, you agree that your contributions will be licensed under the [MIT License](../trakli/LICENSE).
