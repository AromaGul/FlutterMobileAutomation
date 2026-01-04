import 'dart:async';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_registration_app/main.dart' as car_app;
import '../test/page_objects/car_home_page.dart';
import '../test/page_objects/car_registration_page.dart';
import '../test/page_objects/car_browser_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Scenario 1: Registration and Car Search', (WidgetTester tester) async {
    // Launch app
    await tester.pumpWidget(car_app.CarRegistrationApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 2));

    // Initialize Page Objects
    final homePage = CarHomePage(tester);
    final registrationPage = CarRegistrationPage(tester);
    final browserPage = CarBrowserPage(tester);

    // Step 1: Navigate to registration
    await homePage.navigateToDirectory();
    await Future.delayed(const Duration(seconds: 2));

    // Step 2: Fill the form
    await registrationPage.verifyRegistrationScreen();
    await registrationPage.enterName('John Doe');
    await registrationPage.enterEmail('john.doe@example.com');

    // Step 3: Select programming language
    await registrationPage.selectProgrammingLanguage('Dart');
    await Future.delayed(const Duration(seconds: 2));
    await registrationPage.verifyLanguagePrefilled('Dart');

    // Step 4: Check accept add checkbox
    await registrationPage.checkAcceptAdd();
    await Future.delayed(const Duration(seconds: 1));
    await registrationPage.verifyCheckboxChecked();

    // Step 5: Register the user
    await registrationPage.tapRegister();
    await Future.delayed(const Duration(seconds: 2));
    await homePage.verifyHomeScreen();

    // Step 6: Navigate to Browser
    await homePage.navigateToBrowser();
    await Future.delayed(const Duration(seconds: 2));

    // Step 7: Enter car name
    await browserPage.verifyScreen();
    await browserPage.enterCarName('Toyota Camry');

    // Step 8: Select car type
    await browserPage.selectCarType('Sedan');
    await Future.delayed(const Duration(seconds: 1));

    // Step 9: Press send button
    await browserPage.tapSendButton();
    await Future.delayed(const Duration(seconds: 2));

    // Assertions
    await browserPage.verifySearchResult('Toyota Camry', 'Sedan');
    await Future.delayed(const Duration(seconds: 2));
  });
}

