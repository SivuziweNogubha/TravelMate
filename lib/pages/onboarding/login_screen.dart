
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifts_app/pages/home.dart';
import 'package:lifts_app/pages/onboarding/registration_screen.dart';
import 'package:lifts_app/pages/onboarding/reset_password.dart';
import 'package:lifts_app/src/firebase_authentication.dart';
import 'package:lifts_app/utils/important_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../model/user_model.dart';
import '../widgets/social_button.dart';

Color primary = Color(0xff072227);
Color secondary = Color(0xff35858B);
Color primaryLight = Color(0xff4FBDBA);
Color secondaryLight = Color(0xffAEFEFF);

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  //I'M INITIALIZING MY FIREBASE AUTH SERVICE, TO GAIN ACCESS TO ALL MY AUTHENTICATION RELATED CODE.
  final FirebaseAuthService service = FirebaseAuthService();

  bool _isLoading = false;
  late AnimationController _loadingController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      UserModel? userModel = await service.signIn(email, password);
      if (userModel != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home', userModel: userModel)),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your email id.");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
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

    final passwordFields = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _obscureText,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for Login");
        }
        if (!regex.hasMatch(value)) {
          return ("Password is Invalid!!!");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: _obscureText
              ? Image.asset('assets/icons/hide.png', width: 15, height: 15)
              : Image.asset('assets/icons/see.png', width: 15, height: 15),
        ),
      ),
    );


    final loginButton = Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
        onPressed: () {
          signIn(emailController.text, passwordController.text);
          // signIn(emailController.text, passwordController.text);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Login",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        textColor: Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/logo.png",
                        width: 400,
                        height: 500,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(height: 35),
                    emailField,
                    SizedBox(height: 30),
                    passwordFields,
                    SizedBox(height: 30),
                    _isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : loginButton,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an Account? ",
                          style: TextStyle(fontSize: 14, color: primary),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => registration_screen()),
                            );
                          },
                          child: Text(
                            "Sign up.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primary),
                          ),


                        ),

                ],
                    ),
                    Text(
                      '',
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResetPasswordPage())
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Aeonik',
                        ),
                      ),
                    ),
                    Text(
                      '',
                    ),
                    Text(
                        'Or continue with',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primary
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 28),
                        _socialsSignInButtons(_signInWithGoogle),
                        // SocialWidget(onPressed: () {_signInWithGoogle;  },),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    try {
      User? user = await service.signInWithGoogle();

      if (user == null) {
        Fluttertoast.showToast(
          msg: 'Failed to sign in.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MyHomePage(title: 'Home' ))
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

  }

//TO BE MOVED!!
  Widget _socialsSignInButtons(signInWithGoogle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        GestureDetector(
          onTap: () {
            signInWithGoogle();
          },
          child: Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/google.svg',
              height: 5,
              width: 5,
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

}
