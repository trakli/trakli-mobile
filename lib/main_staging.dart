import 'package:trakli/bootstrap.dart';

import 'presentation/app_widget.dart';

void main() async {
  await bootstrap(
    () => const AppWidget(),
  );
}
