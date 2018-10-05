import 'package:crux/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // The Flutter Driver extension adds just enough instrumentation
  // for the test script to interact with the app.
  enableFlutterDriverExtension();
  app.main();
}
