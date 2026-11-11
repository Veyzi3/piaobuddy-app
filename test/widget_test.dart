import 'package:flutter_test/flutter_test.dart';

import 'package:piaobuddy/main.dart';

void main() {
  testWidgets('App loads home tab', (WidgetTester tester) async {
    await tester.pumpWidget(const PiaobuddyApp());
    expect(find.text('我的座驾'), findsOneWidget);
    expect(find.text('充电'), findsWidgets);
  });

  testWidgets('Bottom nav switches to charge tab', (WidgetTester tester) async {
    await tester.pumpWidget(const PiaobuddyApp());
    await tester.tap(find.text('充电').last);
    await tester.pumpAndSettle();
    expect(find.text('附近充电站'), findsOneWidget);
  });
}
