import 'package:trakli/bootstrap.dart';
import 'package:trakli/firebase_options_development.dart';

import 'presentation/app_widget.dart';

void main() async {
  await bootstrap(
    () => const AppWidget(),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
