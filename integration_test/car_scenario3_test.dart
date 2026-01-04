import 'dart:async';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_registration_app/main.dart' as car_app;
import '../test/page_objects/car_home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Scenario 3: Main Screen Features Automation', (WidgetTester tester) async {
    // Launch app
    await tester.pumpWidget(car_app.CarRegistrationApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 2));

    // Initialize Page Objects
    final homePage = CarHomePage(tester);

    // Verify home screen
    await homePage.verifyHomeScreen();

    // Test 1: Progress bar
    await homePage.tapShowProgressBar();
    await Future.delayed(const Duration(milliseconds: 500));
    await homePage.verifyProgressBarAppeared();
    await Future.delayed(const Duration(seconds: 1));

    // Test 2: Toast
    await homePage.tapDisplayToast();
    await Future.delayed(const Duration(milliseconds: 500));
    await homePage.verifyToastAppeared();
    await Future.delayed(const Duration(seconds: 2));

    // Test 3: Window Alert
    await homePage.tapShowAlert();
    await Future.delayed(const Duration(milliseconds: 500));
    await homePage.verifyAlertAppeared();
    await homePage.closeAlert();
    await Future.delayed(const Duration(seconds: 1));

    // Test 4: Focus function
    await homePage.tapDisplayFocus();
    await Future.delayed(const Duration(milliseconds: 500));
    await homePage.enterTextInTopField('Test Focus');
    await homePage.verifyTextEntered('Test Focus');
    await Future.delayed(const Duration(seconds: 1));
  });
}

