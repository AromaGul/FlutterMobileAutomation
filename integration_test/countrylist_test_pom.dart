import 'dart:async';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_assignment_flutter/main.dart';
import '../test/page_objects/country_home_page.dart' as pom;
import '../test/page_objects/multi_choice_questions_page.dart';
import '../test/page_objects/second_app_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CountryListApp Integration Tests - POM', () {
    testWidgets('Scenario 1: CountryListApp automation - visible on emulator', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(CountryListApp());
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Initialize Page Objects
      final homePage = pom.CountryHomePage(tester);

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
      final homePage = pom.CountryHomePage(tester);
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
}

