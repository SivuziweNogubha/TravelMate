import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/src/firebase_authentication.dart';
import 'package:lifts_app/utils/important_constants.dart';

import '../../main.dart';
import '../widgets/loading_animation.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService service = FirebaseAuthService();



  Future<void> _resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomLoadingAnimation(animationPath: 'assets/animations/loading.json');
          },
    );

    await Future.delayed(Duration(seconds: 2));

    try {
      await service.resetPassword(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset email: $e')),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              color: Colors.white,
              'assets/icons/reset_bar.png',
              width: 44,
              height: 74,
            ),
          ],
        ),
        // backgroundColor: Colors.indigo,
        centerTitle: true,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage('assets/back.png'), // Replace with your icon path
            size: 50,
            color: Colors.white,
          ),
          color: primary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your email to reset your password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  // key: _formKey,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(30),
                  color: primary,
                  child: MaterialButton(
                    onPressed: _resetPassword,
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Reset",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),

    );
  }
}
