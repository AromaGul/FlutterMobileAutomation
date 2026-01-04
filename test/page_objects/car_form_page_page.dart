import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Car Registration Form Page Screen
class CarFormPagePage {
  final WidgetTester tester;

  CarFormPagePage(this.tester);

  // Locators
  Finder get screenTitle => find.text('Form Page');
  Finder get submitButton => find.text('Submit Form');

  // Actions
  Future<void> verifyScreen() async {
    expect(screenTitle, findsOneWidget);
  }

  Future<void> fillName(String name) async {
    final nameField = find.byType(TextFormField).at(0);
    await tester.enterText(nameField, name);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> fillEmail(String email) async {
    final emailField = find.byType(TextFormField).at(1);
    await tester.enterText(emailField, email);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> fillPhone(String phone) async {
    final phoneField = find.byType(TextFormField).at(2);
    await tester.enterText(phoneField, phone);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> fillAddress(String address) async {
    final addressField = find.byType(TextFormField).at(3);
    await tester.enterText(addressField, address);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> selectRadioOption(String option) async {
    final radioOption = find.text(option);
    
    // Scroll to make radio option visible if it's off-screen
    await tester.scrollUntilVisible(
      radioOption,
      1000.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Now tap the radio option
    expect(radioOption, findsOneWidget);
    await tester.tap(radioOption, warnIfMissed: false);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> checkCheckboxes(int count) async {
    // First, find all checkboxes
    final allCheckboxListTiles = find.byType(CheckboxListTile);
    
    // Wait a bit for widgets to be available
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if checkboxes exist (they might be in a dialog or off-screen)
    final checkboxCount = allCheckboxListTiles.evaluate().length;
    
    if (checkboxCount == 0) {
      // Scroll down to find checkboxes
      final scrollable = find.byType(Scrollable).first;
      await tester.drag(scrollable, const Offset(0, -500));
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    // Now check again
    final finalCheckboxes = find.byType(CheckboxListTile);
    final finalCount = finalCheckboxes.evaluate().length;
    
    if (finalCount < count) {
      // Scroll more if needed
      final scrollable = find.byType(Scrollable).first;
      for (int i = 0; i < 3; i++) {
        await tester.drag(scrollable, const Offset(0, -300));
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 300));
        final currentCount = find.byType(CheckboxListTile).evaluate().length;
        if (currentCount >= count) break;
      }
    }
    
    // Verify we have enough checkboxes
    final verifyCheckboxes = find.byType(CheckboxListTile);
    expect(verifyCheckboxes, findsAtLeastNWidgets(count));
    
    // Check all checkboxes one by one
    for (int i = 0; i < count; i++) {
      final checkbox = verifyCheckboxes.at(i);
      
      // Scroll to make this checkbox visible
      await tester.scrollUntilVisible(
        checkbox,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Tap the checkbox
      await tester.tap(checkbox, warnIfMissed: false);
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> selectMultiSelectOptions(List<String> options) async {
    // Find multi select ListTile - scroll to it first
    final multiSelectLabel = find.text('Multi Select:');
    
    // Scroll to make it visible
    await tester.scrollUntilVisible(
      multiSelectLabel,
      1000.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Find and tap the ListTile
    final allListTiles = find.byType(ListTile);
    bool foundMultiSelect = false;
    for (int i = 0; i < allListTiles.evaluate().length; i++) {
      try {
        final tile = tester.widget<ListTile>(allListTiles.at(i));
        if (tile.title is Text && (tile.title as Text).data == 'Multi Select:') {
          await tester.tap(allListTiles.at(i), warnIfMissed: false);
          await tester.pump();
          await Future.delayed(const Duration(milliseconds: 500));
          foundMultiSelect = true;
          break;
        }
      } catch (e) {
        // Continue searching
      }
    }
    
    if (!foundMultiSelect) {
      // Try alternative: find by text directly
      final multiSelectTile = find.text('Multi Select:');
      if (multiSelectTile.evaluate().isNotEmpty) {
        await tester.tap(multiSelectTile, warnIfMissed: false);
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    // Wait for dialog to appear
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Select options in dialog - wait for checkboxes to appear
    var attempts = 0;
    while (attempts < 10) {
      final multiSelectCheckboxes = find.byType(CheckboxListTile);
      if (multiSelectCheckboxes.evaluate().length >= 2) {
        await tester.tap(multiSelectCheckboxes.at(0), warnIfMissed: false);
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 300));
        
        await tester.tap(multiSelectCheckboxes.at(1), warnIfMissed: false);
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 300));
        break;
      }
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 200));
      attempts++;
    }

    // Tap Done button (the dialog uses "Done", not "OK")
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));
    
    final doneButtonFinder = find.text('Done');
    if (doneButtonFinder.evaluate().isNotEmpty) {
      await tester.tap(doneButtonFinder, warnIfMissed: false);
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
    } else {
      // If "Done" button not found, try to close dialog by tapping outside or using back
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> selectSingleSelectOption(String option) async {
    final singleSelectDropdown = find.byType(DropdownButtonFormField<String>);
    
    // Scroll to make dropdown visible
    await tester.scrollUntilVisible(
      singleSelectDropdown,
      1000.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
    
    expect(singleSelectDropdown, findsOneWidget);
    await tester.tap(singleSelectDropdown, warnIfMissed: false);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));
    
    final choiceFinder = find.text(option).last;
    await tester.tap(choiceFinder, warnIfMissed: false);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> submitForm() async {
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

