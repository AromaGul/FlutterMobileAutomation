import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_assignment_flutter/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CountryListApp Integration Tests', () {
    testWidgets('Scenario 1: CountryListApp automation - visible on emulator', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(CountryListApp());
      await tester.pumpAndSettle();
      
      // Wait to see the app launch
      await Future.delayed(const Duration(seconds: 2));

      // Verify initial state - Afghanistan should be first, Nigeria second
      expect(find.text('Afghanistan'), findsOneWidget);
      expect(find.text('Nigeria'), findsOneWidget);
      
      // Wait to observe initial state
      await Future.delayed(const Duration(seconds: 2));

      // Scroll to Nigeria (it should be visible, but scroll to ensure)
      final nigeriaFinder = find.text('Nigeria');
      await tester.scrollUntilVisible(
        nigeriaFinder,
        200.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();
      
      // Wait to see the scroll
      await Future.delayed(const Duration(seconds: 2));

      // Drag Nigeria to top
      // Get Nigeria's position and the first tile's position
      final nigeriaTile = find.text('Nigeria');
      expect(nigeriaTile, findsOneWidget);
      
      final nigeriaCenter = tester.getCenter(nigeriaTile);
      final firstTile = find.byType(ListTile).first;
      final targetY = tester.getTopLeft(firstTile).dy - 30;
      
      // Wait before starting drag
      await Future.delayed(const Duration(seconds: 1));
      
      // Long press and drag on Nigeria tile to reorder
      final gesture = await tester.startGesture(nigeriaCenter, kind: PointerDeviceKind.touch);
      await tester.pump(const Duration(milliseconds: 800)); // Longer long press duration
      
      // Drag upward to move Nigeria to top - do it slowly in steps
      final steps = 10;
      final deltaY = (targetY - nigeriaCenter.dy) / steps;
      for (int i = 0; i <= steps; i++) {
        await gesture.moveTo(Offset(nigeriaCenter.dx, nigeriaCenter.dy + (deltaY * i)));
        await tester.pump(const Duration(milliseconds: 100));
      }
      
      // Complete the gesture
      await gesture.up();
      await tester.pumpAndSettle();
      
      // Wait to see the reorder result
      await Future.delayed(const Duration(seconds: 2));

      // Verify Nigeria is now at the top
      final tiles = find.byType(ListTile);
      expect(tiles, findsWidgets);
      final firstTileText = tester.widget<ListTile>(tiles.first).title as Text;
      expect(firstTileText.data, 'Nigeria');

      // Swipe to delete Afghanistan (now should be second)
      final afghanistanFinder = find.text('Afghanistan');
      expect(afghanistanFinder, findsOneWidget);
      
      // Wait before swiping
      await Future.delayed(const Duration(seconds: 1));
      
      // Perform swipe gesture to dismiss - do it slowly
      final afghanistanCenter = tester.getCenter(afghanistanFinder);
      final swipeGesture = await tester.startGesture(afghanistanCenter, kind: PointerDeviceKind.touch);
      await tester.pump(const Duration(milliseconds: 200));
      
      // Swipe left slowly in steps
      final swipeSteps = 15;
      final swipeDeltaX = -500.0 / swipeSteps;
      for (int i = 0; i <= swipeSteps; i++) {
        await swipeGesture.moveTo(Offset(afghanistanCenter.dx + (swipeDeltaX * i), afghanistanCenter.dy));
        await tester.pump(const Duration(milliseconds: 50));
      }
      
      await swipeGesture.up();
      await tester.pumpAndSettle();
      
      // Wait to see the deletion
      await Future.delayed(const Duration(seconds: 2));

      // Assertions
      expect(find.text('Nigeria'), findsOneWidget);
      expect(find.text('Afghanistan'), findsNothing);
      
      // Final wait to see the result
      await Future.delayed(const Duration(seconds: 2));
    });

    testWidgets('Scenario 2: Multi choice questions and second app launch', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(CountryListApp());
      await tester.pumpAndSettle();
      
      // Wait to see the app launch
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to Multi choice questions section
      final multiChoiceButton = find.text('Multi choice questions');
      expect(multiChoiceButton, findsOneWidget);
      
      await tester.tap(multiChoiceButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Verify we're on the multi choice questions screen
      expect(find.text('Multi Choice Questions'), findsOneWidget);

      // Get all question items (CheckboxListTile)
      final questionItems = find.byType(CheckboxListTile);
      expect(questionItems, findsWidgets);
      
      // Select 5 radio buttons randomly
      final allQuestions = questionItems.evaluate();
      final random = Random();
      final selectedIndices = <int>{};
      
      // Select 5 random questions
      while (selectedIndices.length < 5 && selectedIndices.length < allQuestions.length) {
        final index = random.nextInt(allQuestions.length);
        if (!selectedIndices.contains(index)) {
          selectedIndices.add(index);
        }
      }
      
      // Tap to select the randomly chosen questions
      for (final index in selectedIndices) {
        final question = questionItems.at(index);
        await tester.tap(question);
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Wait to see selections
      await Future.delayed(const Duration(seconds: 2));

      // Verify 5 items are selected
      int selectedCount = 0;
      for (int i = 0; i < questionItems.evaluate().length; i++) {
        final widget = tester.widget<CheckboxListTile>(questionItems.at(i));
        if (widget.value == true) {
          selectedCount++;
        }
      }
      
      expect(selectedCount, equals(5));

      // Delete all selected items
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);
      
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Assertions: Deleted items should not be there in the list
      // The remaining items should be less than original (10 - 5 = 5)
      final remainingQuestions = find.byType(CheckboxListTile);
      expect(remainingQuestions, findsNWidgets(5));

      // Launch second app
      final launchButton = find.text('Launch 2nd App');
      expect(launchButton, findsOneWidget);
      
      await tester.tap(launchButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      // Handle the confirmation dialog if it appears
      final launchConfirmButton = find.text('Launch');
      
      // Wait for dialog to appear
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (launchConfirmButton.evaluate().isNotEmpty) {
        // If dialog appears, tap Launch
        await tester.tap(launchConfirmButton);
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 2));
      }
      
      // Wait for second app to launch
      await Future.delayed(const Duration(seconds: 2));

      // Assertions: Second application should be open successfully
      // Look for second app screen elements
      expect(find.text('Second Application'), findsWidgets); // Can appear in AppBar and body
      expect(find.text('Successfully Launched!'), findsOneWidget);
      
      // Wait to see the second app
      await Future.delayed(const Duration(seconds: 2));
    });
  });
}
