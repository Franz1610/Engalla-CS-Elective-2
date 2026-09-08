import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/widgets/cart_badge_button.dart';

void main() {
  testWidgets('renders RetroByte home screen with products in a grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    expect(find.text('RetroByte'), findsWidgets);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Zelda Ocarina of Time'), findsOneWidget);
    expect(find.text('PlayStation 1 Console'), findsOneWidget);
  });

  testWidgets('toggling theme switches between dark and light mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    // Starts in light mode -> button icon is nightlight
    final themeToggleFinder = find.byTooltip('Switch to Dark Mode');
    expect(themeToggleFinder, findsOneWidget);

    // Tap to toggle to dark mode
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();

    // Now in dark mode -> button icon should switch to sun / light mode
    expect(find.byTooltip('Switch to Light Mode'), findsOneWidget);

    // Tap to toggle back to light mode
    await tester.tap(find.byTooltip('Switch to Light Mode'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);
  });

  testWidgets('navigates to product details when tapping a product card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    // Tap the Zelda product card
    await tester.tap(find.text('Zelda Ocarina of Time'));
    await tester.pumpAndSettle();

    // Product Details should render
    expect(find.text('Product Overview'), findsOneWidget);
    expect(find.text('Platform: N64'), findsOneWidget);
    expect(find.text('Condition: Very Good'), findsOneWidget);
    expect(find.text('Add 1 to Cart'), findsOneWidget);
  });

  testWidgets('adding product from details updates cart badge count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    // Initially no badge count text
    expect(find.text('1'), findsNothing);

    // Navigate to details
    await tester.tap(find.text('Zelda Ocarina of Time'));
    await tester.pumpAndSettle();

    // Tap "Add 1 to Cart"
    final addToCartBtn = find.text('Add 1 to Cart');
    await tester.ensureVisible(addToCartBtn);
    await tester.pumpAndSettle();
    await tester.tap(addToCartBtn);
    await tester.pump();

    // Cart badge should now display '1'
    expect(
      find.descendant(of: find.byType(CartBadgeButton), matching: find.text('1')),
      findsOneWidget,
    );

    // Drain SnackBar
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('navigates to cart screen when tapping cart button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    final cartButton = find.byTooltip('View Cart');
    expect(cartButton, findsOneWidget);

    await tester.tap(cartButton);
    await tester.pumpAndSettle();

    expect(find.text('Shopping Cart'), findsOneWidget);
  });

  testWidgets('full flow: Home -> Product Detail -> Add to Cart -> Cart -> Checkout Confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    // 1. Home: Tap product to navigate to Product Detail
    await tester.tap(find.text('Zelda Ocarina of Time'));
    await tester.pumpAndSettle();

    // 2. Product Detail: Increase quantity to 2
    final increaseButton = find.byTooltip('Increase quantity');
    await tester.ensureVisible(increaseButton);
    await tester.pumpAndSettle();
    await tester.tap(increaseButton);
    await tester.pumpAndSettle();
    expect(find.text('Add 2 to Cart'), findsOneWidget);

    // 3. Add to Cart
    final addToCartBtn = find.text('Add 2 to Cart');
    await tester.ensureVisible(addToCartBtn);
    await tester.pumpAndSettle();
    await tester.tap(addToCartBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    // 4. Cart: Open Cart via Cart Badge Button
    await tester.tap(find.byTooltip('View Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Shopping Cart'), findsOneWidget);
    expect(find.text('Total Items:'), findsOneWidget);
    expect(find.text('2'), findsWidgets);

    // 5. Cart: Proceed to Checkout
    final checkoutBtn = find.text('Proceed to Checkout');
    expect(checkoutBtn, findsOneWidget);
    await tester.tap(checkoutBtn);
    await tester.pumpAndSettle();

    // 6. Checkout Confirmation: Verify Order Summary
    expect(find.text('ORDER CONFIRMED!'), findsOneWidget);
    expect(find.text('Total Paid:'), findsOneWidget);
    expect(find.text('Back to RetroByte Home'), findsOneWidget);

    // 7. Back to Home clears cart and returns to grid
    final backHomeBtn = find.text('Back to RetroByte Home');
    await tester.ensureVisible(backHomeBtn);
    await tester.pumpAndSettle();
    await tester.tap(backHomeBtn);
    await tester.pumpAndSettle();

    expect(find.text('RetroByte'), findsWidgets);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('responsive layout uses 2 columns on phone and 3+ on tablet', (
    WidgetTester tester,
  ) async {
    // Test on phone width (400px)
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    GridView grid = tester.widget(find.byType(GridView));
    SliverGridDelegateWithFixedCrossAxisCount delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);

    // Test on tablet width (800px)
    tester.view.physicalSize = const Size(800, 1000);
    await tester.pumpWidget(const RetroByteApp());
    await tester.pumpAndSettle();

    grid = tester.widget(find.byType(GridView));
    delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 3);
  });
}
