import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Car Registration App Home Screen
class CarHomePage {
  final WidgetTester tester;

  CarHomePage(this.tester);

  // Locators
  Finder get homeTitle => find.text('Home');
  Finder get showProgressBarButton => find.text('Show progress bar');
  Finder get displayToastButton => find.text('Display a Toast');
  Finder get showAlertButton => find.text('Show Window Alert');
  Finder get displayFocusButton => find.text('Display focus');
  Finder get directoryButton => find.text('Directory');
  Finder get browserButton => find.text('Browser');
  Finder get topTextField => find.byType(TextField).first;

  // Actions
  Future<void> verifyHomeScreen() async {
    expect(homeTitle, findsOneWidget);
  }

  Future<void> tapShowProgressBar() async {
    expect(showProgressBarButton, findsOneWidget);
    await tester.tap(showProgressBarButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> verifyProgressBarAppeared() async {
    // Progress bar is always in the tree but with opacity 0 when hidden
    // When shown, opacity becomes 1.0
    final progressBar = find.byKey(ValueKey('progress_bar'));
    expect(progressBar, findsOneWidget);
    // Also verify LinearProgressIndicator exists
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  }

  Future<void> tapDisplayToast() async {
    expect(displayToastButton, findsOneWidget);
    await tester.tap(displayToastButton);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> verifyToastAppeared() async {
    final toast = find.text('This is a Toast message');
    expect(toast, findsOneWidget);
  }

  Future<void> tapShowAlert() async {
    expect(showAlertButton, findsOneWidget);
    await tester.tap(showAlertButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> verifyAlertAppeared() async {
    expect(find.text('Window Alert'), findsOneWidget);
    expect(find.text('This is a window alert/popup message.'), findsOneWidget);
  }

  Future<void> closeAlert() async {
    final okButton = find.text('OK');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> tapDisplayFocus() async {
    expect(displayFocusButton, findsOneWidget);
    await tester.tap(displayFocusButton);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> enterTextInTopField(String text) async {
    expect(topTextField, findsOneWidget);
    await tester.enterText(topTextField, text);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> verifyTextEntered(String text) async {
    expect(find.text(text), findsOneWidget);
  }

  Future<void> navigateToDirectory() async {
    expect(directoryButton, findsOneWidget);
    await tester.tap(directoryButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> navigateToBrowser() async {
    expect(browserButton, findsOneWidget);
    await tester.tap(browserButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

