import 'package:flutter_test/flutter_test.dart';
import 'package:resqnet_app/main.dart';

void main() {
  testWidgets('ResQNetApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ResQNetApp());

    expect(find.text('Welcome to ResQNet'), findsOneWidget);
  });
}
