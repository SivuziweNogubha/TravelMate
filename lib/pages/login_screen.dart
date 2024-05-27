// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:lifts_app/home_page.dart';
// import 'package:lifts_app/pages/home.dart';
// import 'package:lifts_app/main.dart';
// import 'package:lifts_app/pages/registration_screen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
//
// // Defining Custom colors
// Color primary = Color(0xff072227);
// Color secondary = Color(0xff35858B);
// Color primaryLight = Color(0xff4FBDBA);
// Color secondaryLight = Color(0xffAEFEFF);
//
// class login_screen extends StatefulWidget {
//   const login_screen({Key? key}) : super(key: key);
//
//   @override
//   State<login_screen> createState() => _login_screenState();
// }
//
// class _login_screenState extends State<login_screen> {
//   // Defining form Key
//   final _formKey = GlobalKey<FormState>();
//
//   // Defining Editing Controller
//   final TextEditingController emailController = new TextEditingController();
//   final TextEditingController passwordController = new TextEditingController();
//
//   // Firebase Auth
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     // Creating Fields to enter the Email and Password
//     // Form Email Fields
//     final emailField = TextFormField(
//       autofocus: false,
//       controller: emailController,
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return ("Please Enter your email id.");
//         }
//         // reg expression for email validation
//         if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
//           return ("Please Enter a valid Email");
//         }
//         ;
//         return null;
//       },
//       onSaved: (value) {
//         emailController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.mail),
//         contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: "Email",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     // Form Password Fields
//     final passwordFields = TextFormField(
//       autofocus: false,
//       controller: passwordController,
//       obscureText: true,
//       validator: (value) {
//         RegExp regex = RegExp(r'^.{6,}$');
//         if (value!.isEmpty) {
//           return ("Password is required for Login");
//         }
//         if (!regex.hasMatch(value)) {
//           return ("Password is Invalid!!!");
//         }
//       },
//       onSaved: (value) {
//         passwordController.text = value!;
//       },
//       textInputAction: TextInputAction.done,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.key),
//         contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: "Password",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     // Login Button
//     final login_button = Material(
//       elevation: 4,
//       borderRadius: BorderRadius.circular(30),
//       color: primary,
//       child: MaterialButton(
//         onPressed: () {
//           signIn(emailController.text, passwordController.text);
//         },
//         padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//         minWidth: MediaQuery.of(context).size.width,
//         child: Text(
//           "Login",
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         textColor: Colors.white,
//       ),
//     );
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 200,
//                       child: Image(
//                         image: AssetImage("assets/logo.png"),
//                         width: 90,
//                         height: 90,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     SizedBox(height: 35),
//                     emailField,
//                     SizedBox(height: 30),
//                     passwordFields,
//                     SizedBox(height: 30),
//                     login_button,
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Don't have an Account? ",
//                           style: TextStyle(fontSize: 14, color: primary),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         registration_screen()));
//                           },
//                           child: Text(
//                             "Sign up.",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: primary),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // This where i implement the login logic
//   void signIn(String email, String password) async {
//     if (_formKey.currentState!.validate()) {
//       await _auth
//           .signInWithEmailAndPassword(email: email, password: password)
//           .then((uid) => {
//         Fluttertoast.showToast(msg: "Login Successful!!"),
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MyHomePage(title: 'Home'),
//           ),
//         ),
//       })
//           .catchError((e) {
//         Fluttertoast.showToast(msg: e!.message);
//       });
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifts_app/home_page.dart';
import 'package:lifts_app/pages/home.dart';
import 'package:lifts_app/pages/registration_screen.dart';
import 'package:lifts_app/pages/reset_password.dart';
import 'package:lifts_app/utils/important_constants.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  late AnimationController _loadingController;

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
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        Fluttertoast.showToast(
            msg: "Login Successful!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home')),
        );
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Failed to sign in.',
             toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut(); // Signing out any existing user before signing in

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        String uid = userCredential.user!.uid;
        DocumentSnapshot doc = await _firestore.collection("users").doc(uid).get();

        if (!doc.exists) {
          await _firestore.collection("users").doc(uid).set({
            "uid": uid,
            "name": googleUser.displayName,
            "email": googleUser.email,
            "profilePhoto": googleUser.photoUrl ?? AppValues.defaultUserImg,
            "cash": 0.0
          });
        }
      }

      return _auth.currentUser;
    } catch (e) {
      throw Exception('An error occurred while signing in with Google.');
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
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for Login");
        }
        if (!regex.hasMatch(value)) {
          return ("Password is Invalid!!!");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[200],
                        //     borderRadius: BorderRadius.circular(10.0),
                        //   ),
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: const FaIcon(
                        //     FontAwesomeIcons.google,
                        //     color: Color.fromARGB(255, 12, 12, 12),
                        //     size: 18,
                        //   ),
                        // ),


                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () async {
                              User? user = await signInWithGoogle();
                              if (user != null) {
                                // Handle successful sign-in
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Sign in successful: ${user.displayName}')),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage())
                                );
                              } else {
                                // Handle sign-in failure
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Sign in failed')),
                                );
                              }
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Color.fromARGB(255, 12, 12, 12),
                              size: 18,
                            ),
                          ),
                        ),


                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Color.fromARGB(255, 12, 12, 12),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const FaIcon(
                            FontAwesomeIcons.apple,
                            color: Color.fromARGB(255, 12, 12, 12),
                            size: 18,
                          ),
                        ),
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
}
