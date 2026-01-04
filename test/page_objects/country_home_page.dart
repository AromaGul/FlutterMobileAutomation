import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model for Country Home Screen
class CountryHomePage {
  final WidgetTester tester;

  CountryHomePage(this.tester);

  // Locators
  Finder get appTitle => find.text('Country List App');
  Finder get multiChoiceButton => find.text('Multi choice questions');
  Finder get wrapViewButton => find.byIcon(Icons.wrap_text);

  // Actions
  Future<void> verifyHomeScreen() async {
    expect(appTitle, findsOneWidget);
  }

  Future<void> verifyCountryExists(String country) async {
    expect(find.text(country), findsOneWidget);
  }

  Future<void> verifyCountryNotExists(String country) async {
    expect(find.text(country), findsNothing);
  }

  Future<void> scrollToCountry(String country) async {
    final countryFinder = find.text(country);
    await tester.scrollUntilVisible(
      countryFinder,
      200.0,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
  }

  Future<void> dragCountryToTop(String country) async {
    final countryTile = find.text(country);
    expect(countryTile, findsOneWidget);
    
    final countryCenter = tester.getCenter(countryTile);
    final firstTile = find.byType(ListTile).first;
    final targetY = tester.getTopLeft(firstTile).dy - 30;
    
    await Future.delayed(const Duration(seconds: 1));
    
    // Long press and drag
    final gesture = await tester.startGesture(countryCenter, kind: PointerDeviceKind.touch);
    await tester.pump(const Duration(milliseconds: 800));
    
    // Drag upward in steps
    final steps = 10;
    final deltaY = (targetY - countryCenter.dy) / steps;
    for (int i = 0; i <= steps; i++) {
      await gesture.moveTo(Offset(countryCenter.dx, countryCenter.dy + (deltaY * i)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    
    await gesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> swipeToDeleteCountry(String country) async {
    final countryFinder = find.text(country);
    expect(countryFinder, findsOneWidget);
    
    await Future.delayed(const Duration(seconds: 1));
    
    final countryCenter = tester.getCenter(countryFinder);
    final swipeGesture = await tester.startGesture(countryCenter, kind: PointerDeviceKind.touch);
    await tester.pump(const Duration(milliseconds: 200));
    
    // Swipe left slowly in steps
    final swipeSteps = 15;
    final swipeDeltaX = -500.0 / swipeSteps;
    for (int i = 0; i <= swipeSteps; i++) {
      await swipeGesture.moveTo(Offset(countryCenter.dx + (swipeDeltaX * i), countryCenter.dy));
      await tester.pump(const Duration(milliseconds: 50));
    }
    
    await swipeGesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> verifyFirstCountry(String country) async {
    final tiles = find.byType(ListTile);
    expect(tiles, findsWidgets);
    final firstTileText = tester.widget<ListTile>(tiles.first).title as Text;
    expect(firstTileText.data, country);
  }

  Future<void> navigateToMultiChoice() async {
    expect(multiChoiceButton, findsOneWidget);
    await tester.tap(multiChoiceButton);
    await tester.pumpAndSettle();
  }
}

