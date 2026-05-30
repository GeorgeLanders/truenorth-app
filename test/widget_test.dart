import 'package:flutter_test/flutter_test.dart';
import 'package:truenorth_app/app.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TrueNorthApp());
    expect(find.byType(TrueNorthApp), findsOneWidget);
  });
}
