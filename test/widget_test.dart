import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('BMI Calculator test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BMICalculatorApp());

    // Find the text fields and the button.
    final heightField = find.widgetWithText(TextField, 'Height (m)');
    final weightField = find.widgetWithText(TextField, 'Weight (kg)');
    final calculateButton = find.widgetWithText(ElevatedButton, 'Calculate');

    // Enter height and weight.
    await tester.enterText(heightField, '1.75');
    await tester.enterText(weightField, '70');

    // Tap the calculate button.
    await tester.tap(calculateButton);
    await tester.pump();

    // Verify the result.
    expect(find.text('Your BMI is 22.86'), findsOneWidget);
    expect(find.text('You have a normal weight'), findsOneWidget);
  });
}