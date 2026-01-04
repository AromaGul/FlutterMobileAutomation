import 'dart:async';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_assignment_flutter/main.dart';
import 'package:car_registration_app/main.dart' as car_app;
import '../test/page_objects/country_home_page.dart' as country_pom;
import '../test/page_objects/multi_choice_questions_page.dart';
import '../test/page_objects/second_app_page.dart';
import '../test/page_objects/car_home_page.dart';
import '../test/page_objects/car_registration_page.dart';
import '../test/page_objects/car_browser_page.dart';
import '../test/page_objects/car_long_page_page.dart';
import '../test/page_objects/car_form_page_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('All Scenarios - Mobile Assignment Flutter App', () {
    testWidgets('Scenario 1: CountryListApp automation', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(CountryListApp());
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Initialize Page Objects
      final homePage = country_pom.CountryHomePage(tester);

      // Verify initial state
      await homePage.verifyHomeScreen();
      await homePage.verifyCountryExists('Afghanistan');
      await homePage.verifyCountryExists('Nigeria');
      await Future.delayed(const Duration(seconds: 2));

      // Scroll to Nigeria
      await homePage.scrollToCountry('Nigeria');
      await Future.delayed(const Duration(seconds: 2));

      // Drag Nigeria to top
      await homePage.dragCountryToTop('Nigeria');
      await Future.delayed(const Duration(seconds: 2));

      // Verify Nigeria is now at the top
      await homePage.verifyFirstCountry('Nigeria');

      // Swipe to delete Afghanistan
      await homePage.swipeToDeleteCountry('Afghanistan');
      await Future.delayed(const Duration(seconds: 2));

      // Assertions
      await homePage.verifyCountryExists('Nigeria');
      await homePage.verifyCountryNotExists('Afghanistan');
      await Future.delayed(const Duration(seconds: 2));
    });

    testWidgets('Scenario 2: Multi choice questions and second app launch', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(CountryListApp());
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Initialize Page Objects
      final homePage = country_pom.CountryHomePage(tester);
      final multiChoicePage = MultiChoiceQuestionsPage(tester);
      final secondAppPage = SecondAppPage(tester);

      // Navigate to Multi choice questions section
      await homePage.navigateToMultiChoice();
      await Future.delayed(const Duration(seconds: 2));

      // Verify we're on the multi choice questions screen
      await multiChoicePage.verifyScreen();

      // Select 5 radio buttons randomly
      await multiChoicePage.selectRandomQuestions(5);
      await Future.delayed(const Duration(seconds: 2));

      // Verify 5 items are selected
      await multiChoicePage.verifySelectedCount(5);

      // Delete all selected items
      await multiChoicePage.deleteSelectedItems();
      await Future.delayed(const Duration(seconds: 2));

      // Assertions: Deleted items should not be there in the list
      await multiChoicePage.verifyRemainingCount(5);

      // Launch second app
      await multiChoicePage.launchSecondApp();
      await Future.delayed(const Duration(seconds: 2));

      // Assertions: Second application should be open successfully
      await secondAppPage.verifySecondAppLaunched();
      await Future.delayed(const Duration(seconds: 2));
    });
  });

  group('All Scenarios - Car Registration App', () {
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

    testWidgets('Scenario 2: Browser dropdown and form page', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(car_app.CarRegistrationApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await Future.delayed(const Duration(seconds: 2));

      // Initialize Page Objects
      final homePage = CarHomePage(tester);
      final browserPage = CarBrowserPage(tester);
      final longPagePage = CarLongPagePage(tester);
      final formPagePage = CarFormPagePage(tester);

      // Step 1: Navigate to Browser
      await homePage.navigateToBrowser();
      await Future.delayed(const Duration(seconds: 2));
      await browserPage.verifyScreen();

      // Step 2: Select "Long page content" from dropdown
      await browserPage.selectSayHelloOption('Long page content');
      await Future.delayed(const Duration(seconds: 2));

      // Step 3: Scroll to middle text
      await longPagePage.verifyScreen();
      await longPagePage.scrollToMiddleText();
      await Future.delayed(const Duration(seconds: 2));
      await longPagePage.verifyMiddleTextVisible();

      // Step 4: Go back and select "Form page"
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await browserPage.selectSayHelloOption('Form page');
      await Future.delayed(const Duration(seconds: 2));

      // Step 5: Fill the form
      await formPagePage.verifyScreen();
      await formPagePage.fillName('Jane Smith');
      await formPagePage.fillEmail('jane.smith@example.com');
      await formPagePage.fillPhone('1234567890');
      await formPagePage.fillAddress('123 Main Street, City, Country');

      // Step 6: Select radio button
      await formPagePage.selectRadioOption('Option B');
      await Future.delayed(const Duration(seconds: 1));

      // Step 7: Check checkboxes
      await formPagePage.checkCheckboxes(3);
      await Future.delayed(const Duration(seconds: 1));

      // Step 8: Multi select (skip image upload)
      await formPagePage.selectMultiSelectOptions(['Option 1', 'Option 3']);

      // Step 9: Single select
      await formPagePage.selectSingleSelectOption('Choice B');
      await Future.delayed(const Duration(seconds: 1));

      // Step 10: Submit form
      await formPagePage.submitForm();
      await Future.delayed(const Duration(seconds: 2));

      // Assertions
      await homePage.verifyHomeScreen();
      await Future.delayed(const Duration(seconds: 2));
    });

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

      // Test 1: Toast
      await homePage.tapDisplayToast();
      await Future.delayed(const Duration(milliseconds: 500));
      await homePage.verifyToastAppeared();
      await Future.delayed(const Duration(seconds: 2));

      // Test 2: Window Alert
      await homePage.tapShowAlert();
      await Future.delayed(const Duration(milliseconds: 500));
      await homePage.verifyAlertAppeared();
      await homePage.closeAlert();
      await Future.delayed(const Duration(seconds: 1));

      // Test 3: Focus function
      await homePage.tapDisplayFocus();
      await Future.delayed(const Duration(milliseconds: 500));
      await homePage.enterTextInTopField('Test Focus');
      await homePage.verifyTextEntered('Test Focus');
      await Future.delayed(const Duration(seconds: 1));
    });
  });
}

