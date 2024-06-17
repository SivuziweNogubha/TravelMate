// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../repository/wallet_repo.dart';
//
// class WalletPage extends StatefulWidget {
//   @override
//   _WalletPageState createState() => _WalletPageState();
// }
//
// class _WalletPageState extends State<WalletPage> {
//   final WalletRepository _walletRepository = WalletRepository();
//   double _balance = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchBalance();
//   }
//
//   Future<void> _fetchBalance() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     double balance = await _walletRepository.getWalletBalance(userId);
//     setState(() {
//       _balance = balance;
//     });
//   }
//
//   Future<void> _addFunds(double amount) async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     await _walletRepository.updateWalletBalance(userId, amount);
//     _fetchBalance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Wallet')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Balance: \R$_balance', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement fund addition logic
//                 _addFunds(50.0); // Example: add $50 to the wallet
//               },
//               child: Text('Add Funds'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import '../repository/wallet_repo.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final WalletRepository _walletRepository = WalletRepository();
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _initializeStripe();
  }

  Future<void> _fetchBalance() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    double balance = await _walletRepository.getWalletBalance(userId);
    setState(() {
      _balance = balance;
    });
  }

  Future<void> _addFunds(double amount) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Call your backend to create a payment intent and get the client secret
    String clientSecret = await _createPaymentIntent(amount);
    // Process the payment with Stripe
    await _processPayment(clientSecret);
    await _walletRepository.updateWalletBalance(userId, amount);
    _fetchBalance();
  }

  Future<String> _createPaymentIntent(double amount) async {
    // Replace with your backend URL
    final String backendUrl = 'https://your-backend.com/create-payment-intent';

    // Create the request payload
    Map<String, dynamic> requestPayload = {
      'amount': (amount * 100).toInt().toString(), // Stripe expects the amount in the smallest currency unit (e.g., cents)
    };

    // Make the HTTP POST request
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestPayload),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> responseBody = json.decode(response.body);

      // Return the client secret from the response
      return responseBody['client_secret'];
    } else {
      // Handle error
      throw Exception('Failed to create payment intent');
    }
  }



  Future<void> _processPayment(String clientSecret) async {
    try {
      PaymentMethod paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: clientSecret,
          paymentMethodId: paymentMethod.id,
        ),
      );
    } catch (e) {
      // Handle payment errors
      print('Payment failed: $e');
    }
  }

  void _initializeStripe() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'your_publishable_key',
        merchantId: 'your_merchant_id',
        androidPayMode: 'test', // or 'production'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance: \$$_balance', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addFunds(50.0); // Example: add $50 to the wallet
              },
              child: Text('Add Funds'),
            ),
          ],
        ),
      ),
    );
  }
}
