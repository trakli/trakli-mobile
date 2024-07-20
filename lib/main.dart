import 'package:trakli/bootstrap.dart';

import 'presentation/app_widget.dart';

/// Main entry point for the app
///
/// Calls the `bootstrap` function from `bootstrap.dart` to initialize the app.
///
/// The `bootstrap` function ensures that the app is initialized correctly by:
///
/// - Setting a global error handler that logs errors and their stack traces to the console.
/// - Initializing the Flutter app by calling [WidgetsFlutterBinding.ensureInitialized].
/// - Running the app in a zone guarded against errors.
/// - Running the app by calling the provided `builder` function.
void main() {
  bootstrap(() => const AppWidget());
}
