import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Second App Screen
class SecondAppPage {
  final WidgetTester tester;

  SecondAppPage(this.tester);

  // Locators
  Finder get appTitle => find.text('Second Application');
  Finder get successMessage => find.text('Successfully Launched!');

  // Actions
  Future<void> verifySecondAppLaunched() async {
    expect(appTitle, findsWidgets);
    expect(successMessage, findsOneWidget);
  }
}

