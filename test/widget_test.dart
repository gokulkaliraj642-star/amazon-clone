// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amazon/main.dart';

void main() {
  testWidgets('Login then see home', (WidgetTester tester) async {
    await tester.pumpWidget(const AmazonMiniApp());

    // Login page shows first.
    expect(find.text('Sign in'), findsOneWidget);

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), 'test@example.com');
    await tester.enterText(fields.at(1), '1234');

    await tester.tap(find.text('Login'));
    await tester.pump(); // start loading
    await tester.pump(const Duration(milliseconds: 700)); // wait fake login

    // Home app bar contains amazon text.
    expect(find.text('amazon'), findsOneWidget);
  });
}
