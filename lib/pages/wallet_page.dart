import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/pages/widgets/loading_animation.dart';
import 'package:lifts_app/repository/wallet_repo.dart';
import 'package:lifts_app/utils/important_constants.dart';

import '../main.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final WalletRepository _walletRepository = WalletRepository();
  double _balance = 0.0;
  TextEditingController _amountController = TextEditingController();
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    bool walletsCollectionExists = await _walletRepository.userHasWallet(userId);

    if (!walletsCollectionExists) {
      await _walletRepository.createWallet(userId);
    }

    double balance = await _walletRepository.getWalletBalance(userId);
    setState(() {
      _balance = balance;
    });
  }

  Future<void> _addFunds() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      return;
    }

    setState(() {
      _balance += amount;
      _isLoading = true;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    await _walletRepository.updateWalletBalance(userId, amount);
    _fetchBalance();
    _amountController.clear();

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    // Show a pop-up message indicating successful recharge
    Fluttertoast.showToast(
      msg: "Wallet successfully recharged!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: ImageIcon(
            AssetImage('assets/back.png'),
            size: 50,
            color: Colors.white,
          ),
          color: primary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'My Wallet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/wallet.png',
              width: 44,
              height: 74,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Balance: \R$_balance', style: TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _addFunds, // Disable button while loading
                child: _isLoading
                    ? CustomLoadingAnimation(animationPath: 'assets/animations/loading.json')// Show loading indicator on button
                    : Text('Add Funds'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }
}
