import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Car Registration Long Page Screen
class CarLongPagePage {
  final WidgetTester tester;

  CarLongPagePage(this.tester);

  // Locators
  Finder get screenTitle => find.text('Long Page Content');
  Finder get middleText => find.text('middle of the screen');

  // Actions
  Future<void> verifyScreen() async {
    expect(screenTitle, findsOneWidget);
  }

  Future<void> scrollToMiddleText() async {
    // Scroll until the text becomes visible (it's in the middle, so we need to scroll)
    await tester.scrollUntilVisible(
      middleText,
      2000.0, // Increased scroll distance to reach middle
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Verify the text is now visible
    expect(middleText, findsOneWidget);
  }

  Future<void> verifyMiddleTextVisible() async {
    expect(middleText, findsOneWidget);
  }
}

