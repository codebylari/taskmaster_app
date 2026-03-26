import 'package:flutter_test/flutter_test.dart';
import 'package:meu_app/main.dart';

void main() {
  testWidgets('App abre', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('TaskMaster'), findsOneWidget);
  });
}