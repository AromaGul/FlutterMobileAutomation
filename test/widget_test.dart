import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_assignment_flutter/main.dart';

void main() {
  testWidgets('CountryListApp automation', (WidgetTester tester) async {
    await tester.pumpWidget(CountryListApp());
    await tester.pumpAndSettle();

    // Verify initial state - Afghanistan should be first, Nigeria second
    expect(find.text('Afghanistan'), findsOneWidget);
    expect(find.text('Nigeria'), findsOneWidget);

    // Scroll to Nigeria (it should be visible, but scroll to ensure)
    final nigeriaFinder = find.text('Nigeria');
    await tester.scrollUntilVisible(
      nigeriaFinder,
      200.0,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    // Drag Nigeria to top
    // Get Nigeria's position and the first tile's position
    final nigeriaTile = find.text('Nigeria');
    expect(nigeriaTile, findsOneWidget);
    
    final nigeriaCenter = tester.getCenter(nigeriaTile);
    final firstTile = find.byType(ListTile).first;
    final targetY = tester.getTopLeft(firstTile).dy - 30;
    
    // Long press and drag on Nigeria tile to reorder
    final gesture = await tester.startGesture(nigeriaCenter, kind: PointerDeviceKind.touch);
    await tester.pump(const Duration(milliseconds: 600)); // Long press duration for reorder
    
    // Drag upward to move Nigeria to top
    await gesture.moveTo(Offset(nigeriaCenter.dx, targetY));
    await tester.pump(const Duration(milliseconds: 100));
    
    // Complete the gesture
    await gesture.up();
    await tester.pumpAndSettle();

    // Verify Nigeria is now at the top
    final tiles = find.byType(ListTile);
    expect(tiles, findsWidgets);
    final firstTileText = tester.widget<ListTile>(tiles.first).title as Text;
    expect(firstTileText.data, 'Nigeria');

    // Swipe to delete Afghanistan (now should be second)
    final afghanistanFinder = find.text('Afghanistan');
    expect(afghanistanFinder, findsOneWidget);
    
    // Perform swipe gesture to dismiss
    await tester.drag(afghanistanFinder, Offset(-500.0, 0));
    await tester.pumpAndSettle();

    // Assertions
    expect(find.text('Nigeria'), findsOneWidget);
    expect(find.text('Afghanistan'), findsNothing);
  });
}
