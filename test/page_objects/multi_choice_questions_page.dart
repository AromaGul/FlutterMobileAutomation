import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Multi Choice Questions Screen
class MultiChoiceQuestionsPage {
  final WidgetTester tester;

  MultiChoiceQuestionsPage(this.tester);

  // Locators
  Finder get screenTitle => find.text('Multi Choice Questions');
  Finder get deleteButton => find.byIcon(Icons.delete);
  Finder get launchButton => find.text('Launch 2nd App');

  // Actions
  Future<void> verifyScreen() async {
    expect(screenTitle, findsOneWidget);
  }

  Future<void> selectRandomQuestions(int count) async {
    final questionItems = find.byType(CheckboxListTile);
    expect(questionItems, findsWidgets);
    
    final allQuestions = questionItems.evaluate();
    final random = Random();
    final selectedIndices = <int>{};
    
    // Select random questions
    while (selectedIndices.length < count && selectedIndices.length < allQuestions.length) {
      final index = random.nextInt(allQuestions.length);
      if (!selectedIndices.contains(index)) {
        selectedIndices.add(index);
      }
    }
    
    // Tap to select
    for (final index in selectedIndices) {
      final question = questionItems.at(index);
      await tester.tap(question);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> verifySelectedCount(int expectedCount) async {
    final questionItems = find.byType(CheckboxListTile);
    int selectedCount = 0;
    for (int i = 0; i < questionItems.evaluate().length; i++) {
      final widget = tester.widget<CheckboxListTile>(questionItems.at(i));
      if (widget.value == true) {
        selectedCount++;
      }
    }
    expect(selectedCount, equals(expectedCount));
  }

  Future<void> deleteSelectedItems() async {
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyRemainingCount(int expectedCount) async {
    final remainingQuestions = find.byType(CheckboxListTile);
    expect(remainingQuestions, findsNWidgets(expectedCount));
  }

  Future<void> launchSecondApp() async {
    expect(launchButton, findsOneWidget);
    await tester.tap(launchButton);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
    
    // Handle confirmation dialog if it appears
    final launchConfirmButton = find.text('Launch');
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (launchConfirmButton.evaluate().isNotEmpty) {
      await tester.tap(launchConfirmButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}

