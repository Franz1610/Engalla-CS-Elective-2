import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('renders RetroByte home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RetroByteApp());

    expect(find.text('RetroByte'), findsWidgets);
    expect(find.text('Super Mario 64 Cartridge'), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
  });
}
