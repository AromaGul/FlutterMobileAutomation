import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Car Registration Screen
class CarRegistrationPage {
  final WidgetTester tester;

  CarRegistrationPage(this.tester);

  // Locators
  Finder get registrationTitle => find.text('Registration Form');
  Finder get nameField => find.byType(TextFormField).first;
  Finder get emailField => find.byType(TextFormField).at(1);
  Finder get programmingLanguageField => find.text('Programming Language');
  Finder get acceptAddCheckbox => find.text('I accept add');
  Finder get registerButton => find.text('Register');
  
  // Helper to find programming language card
  Finder get programmingLanguageCard => find.byType(Card).first;

  // Actions
  Future<void> verifyRegistrationScreen() async {
    expect(registrationTitle, findsOneWidget);
  }

  Future<void> enterName(String name) async {
    await tester.enterText(nameField, name);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> enterEmail(String email) async {
    await tester.enterText(emailField, email);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> selectProgrammingLanguage(String language) async {
    // Tap on the programming language card/field to open dialog
    await tester.tap(programmingLanguageField);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(seconds: 1));
    
    // Wait for dialog to appear and find the language option
    // The dialog contains RadioListTile widgets
    final languageOption = find.text(language);
    expect(languageOption, findsOneWidget);
    await tester.tap(languageOption);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> checkAcceptAdd() async {
    // Find the checkbox by finding CheckboxListTile
    final checkbox = find.byType(CheckboxListTile);
    await tester.tap(checkbox);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> tapRegister() async {
    await tester.tap(registerButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> verifyLanguagePrefilled(String language) async {
    expect(find.text(language), findsWidgets);
  }

  Future<void> verifyCheckboxChecked() async {
    final checkbox = find.byType(CheckboxListTile);
    final checkboxWidget = tester.widget<CheckboxListTile>(checkbox);
    expect(checkboxWidget.value, true);
  }
}

