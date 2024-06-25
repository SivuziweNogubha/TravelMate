import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifts_app/pages/widgets/offering_ride_button.dart';


void main() {
  testWidgets('OfferRideButtonWidget test', (WidgetTester tester) async {
    bool buttonPressed = false;

    // BUILDING THE WIDGET HERE
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              OfferRideButtonWidget(
                onPressed: () {
                  buttonPressed = true;
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byKey(Key('offer_ride_button')), findsOneWidget);
    await tester.tap(find.byKey(Key('offer_ride_button')));
    await tester.pump();
    expect(buttonPressed, isTrue);
  });
}