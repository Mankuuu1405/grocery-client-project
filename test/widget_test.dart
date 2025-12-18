import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:grocery/main.dart';

void main() {
  testWidgets('App launches without crashing',
          (WidgetTester tester) async {

        // Build the app
        await tester.pumpWidget(const BhejduApp());

        // Let initial frames render
        await tester.pumpAndSettle();

        // Verify app started
        expect(find.byType(MaterialApp), findsOneWidget);
      });
}
