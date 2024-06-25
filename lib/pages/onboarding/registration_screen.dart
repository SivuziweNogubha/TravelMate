import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifts_app/pages/home.dart';
import 'package:lifts_app/src/firebase_authentication.dart';

import '../../main.dart';
import '../../model/user_model.dart';
import '../../utils/important_constants.dart';
import '../widgets/loading_animation.dart';

// Defining Colors
Color primary = Color(0xff072227);
Color secondary = Color(0xff35858B);
Color primaryLight = Color(0xff4FBDBA);
Color secondaryLight = Color(0xffAEFEFF);

enum RegistrationType { user, driver }
class registration_screen extends StatefulWidget {
  const registration_screen({Key? key}) : super(key: key);
  @override
  State<registration_screen> createState() => _registration_screenState();
}

class _registration_screenState extends State<registration_screen> {

  final _formKey = GlobalKey<FormState>();
  RegistrationType _selectedType = RegistrationType.user;

  //I'M INITIALIZING MY FIREBASE AUTH SERVICE, TO GAIN ACCESS TO ALL MY AUTHENTICATION RELATED CODE.
  FirebaseAuthService service = FirebaseAuthService();

  final TextEditingController firstNameEditingController =
  new TextEditingController();
  final TextEditingController lastNameEditingController =
  new TextEditingController();
  final TextEditingController emailEditingController =
  new TextEditingController();
  final TextEditingController passwordEditingController =
  new TextEditingController();
  final TextEditingController confirmPasswordEditingController =
  new TextEditingController();

  bool _isLoading = false;
  late AnimationController _loadingController;


  @override
  Widget build(BuildContext context) {
    // Creating Form Fields
    // First Name Field

    final registrationTypeDropdown = DropdownButtonFormField<RegistrationType>(
      value: _selectedType,
      onChanged: (value) {
        setState(() {
          _selectedType = value!;
        });
      },
      items: [
        DropdownMenuItem(
          value: RegistrationType.user,
          child: Text('Register as User'),
        ),
        DropdownMenuItem(
          value: RegistrationType.driver,
          child: Text('Register as Driver'),
        ),
      ],
      decoration: InputDecoration(
        labelText: 'Registration Type',
      ),
    );


    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name is required!");
        }
        if (!regex.hasMatch(value)) {
          return ("Name must be min. 3 characters long");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    registrationTypeDropdown;
    // Last name Text Field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Last Name is required!");
        }
        if (!regex.hasMatch(value)) {
          return ("Name must be min. 3 characters long");
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    registrationTypeDropdown;

    // Email Text field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your email id.");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid Email");
        }
        ;
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    registrationTypeDropdown;

    // Password Text Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Create a password to signup.");
        }
        if (!regex.hasMatch(value)) {
          return ("Password is Invalid!!!");
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    registrationTypeDropdown;
    // Confirm password Text Field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return ("Password doesn't match!");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    registrationTypeDropdown;



    // Register Button
    final register_button = new Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text,context);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Sign up",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        textColor: Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Register',
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
              'assets/icons/register.png',
              width: 44,
              height: 74,
            ),
          ],
        ),
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Image(
                        image: AssetImage("assets/logo.png"),
                        width: 230,
                        height: 230,
                        fit: BoxFit.cover,
                      ),
                    ),
                    firstNameField,
                    SizedBox(height: 15),
                    lastNameField,
                    SizedBox(height: 15),
                    emailField,
                    SizedBox(height: 15),
                    passwordField,
                    SizedBox(height: 15),
                    confirmPasswordField,
                    SizedBox(height: 15),
                    register_button,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password,BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomLoadingAnimation(animationPath: 'assets/animations/loading.json');
        },
      );

      // Simulate a delay for loading animation
      await Future.delayed(Duration(seconds: 3));


      switch (_selectedType){
        case RegistrationType.user:
          await service.registerAsUser(email, password, firstNameEditingController.text,context);
          break;
        case RegistrationType.driver:
          await service.registerAsUser(email, password, firstNameEditingController.text,context);
          break;
      }
    }
  }

}

