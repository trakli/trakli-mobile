import 'package:injectable/injectable.dart';
import 'package:trakli/bootstrap.dart';
import 'package:trakli/firebase_options_staging.dart';

import 'presentation/app_widget.dart';

void main() async {
  await bootstrap(
    () => const AppWidget(),
    environment: Environment.dev,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
