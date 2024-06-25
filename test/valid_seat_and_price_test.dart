import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifts_app/pages/widgets/Seats_and_price_widgets.dart';

void main() {
  group('SeatsAndPriceRowWidget', () {
    late TextEditingController priceController;

    setUp(() {
      priceController = TextEditingController();
    });

    tearDown(() {
      priceController.dispose();
    });

    testWidgets('renders correctly with initial values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeatsAndPriceRowWidget(
              priceController: priceController,
              availableSeats: 2,
            ),
          ),
        ),
      );

      // expect(find.byType(Image), findsOneWidget);
      expect(find.byType(DropdownButton<int>), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      expect(find.text('2'), findsOneWidget);  // Initial seats value
      expect(find.text('Price'), findsOneWidget);
    });

    testWidgets('can change number of seats', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeatsAndPriceRowWidget(
              priceController: priceController,
              availableSeats: 1,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('3').last);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('can enter price', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeatsAndPriceRowWidget(
              priceController: priceController,
              availableSeats: 1,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '100');
      expect(priceController.text, '100');
    });



    testWidgets('shows error for invalid price', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              autovalidateMode: AutovalidateMode.always,
              child: SeatsAndPriceRowWidget(
                priceController: priceController,
                availableSeats: 1,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pump();

      expect(find.text('Please enter a valid number'), findsOneWidget);
    });
  });
}