import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Car Registration Browser Screen
class CarBrowserPage {
  final WidgetTester tester;

  CarBrowserPage(this.tester);

  // Locators
  Finder get screenTitle => find.text('Browser');
  Finder get sayHelloDropdown => find.byType(DropdownButtonFormField<String>).first;
  Finder get carNameField => find.byType(TextField).first;
  Finder get carTypeDropdown => find.byType(DropdownButtonFormField<String>).last;
  Finder get sendButton => find.text('Send me your name');

  // Actions
  Future<void> verifyScreen() async {
    expect(screenTitle, findsOneWidget);
  }

  Future<void> selectSayHelloOption(String option) async {
    expect(sayHelloDropdown, findsOneWidget);
    await tester.tap(sayHelloDropdown);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(seconds: 1));
    
    final optionFinder = find.text(option).last;
    expect(optionFinder, findsOneWidget);
    await tester.tap(optionFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> enterCarName(String carName) async {
    await tester.enterText(carNameField, carName);
    await tester.pumpAndSettle();
  }

  Future<void> selectCarType(String carType) async {
    expect(carTypeDropdown, findsWidgets);
    await tester.tap(carTypeDropdown);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(seconds: 1));
    
    final typeOption = find.text(carType).last;
    await tester.tap(typeOption);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> tapSendButton() async {
    expect(sendButton, findsOneWidget);
    await tester.tap(sendButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> verifySearchResult(String carName, String carType) async {
    expect(find.text('Search Result'), findsOneWidget);
    expect(find.text('Name: $carName'), findsOneWidget);
    expect(find.text('Type: $carType'), findsOneWidget);
  }
}

