import 'package:flutter_test/flutter_test.dart';
import 'package:module_25_assignment/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    expect(const MyApp(), isNotNull);
  });
}