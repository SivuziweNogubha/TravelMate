
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';
import '../pages/home.dart';
import '../utils/important_constants.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance;
  }

  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        DocumentSnapshot doc = await _firestore.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "name": name,
            "email": email,
            "profilePhoto": user.photoURL,
            "cash": 0.0,
          });
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
        throw Exception('The email address is not valid.');
      } else if (e.code == 'invalid-password') {
        print('The password is not valid.');
        throw Exception('The password is not valid.');
      } else {
        print(e);
        throw Exception('An error occurred while signing up.');
      }
    }
  }





  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      print("im here>>>>>>>>>${userDoc.data()}");

      UserModel userModel = UserModel.fromDocument(userDoc);
      Fluttertoast.showToast(
        msg: "Login Successful!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      return userModel;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to sign in.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }





  Future<void> postDetailsToFirestore(String firstName,BuildContext context) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    UserModel userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      firstName: firstName,
      // lastName: lastName,
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created Successfully :)");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')), (route) => false);
  }

  Future<void> registerAsUser(String email, String password, String firstName,BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await postDetailsToFirestore(firstName,context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }



  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      print('here number 1>>>>>>>>>>>>>>>>>>>>');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        print('here number 2>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        String uid = userCredential.user!.uid;
        DocumentSnapshot doc = await _firestore.collection("users").doc(uid).get();
        print("im here>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        if (!doc.exists) {
          print("im inside>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
          // Register the user in Firestore if they don't exist
          await _firestore.collection("users").doc(uid).set({
            "uid": uid,
            "name": googleUser.displayName,
            "email": googleUser.email,
            "photoURL": googleUser.photoUrl ?? AppValues.defaultUserImg,
            "cash": 0.0,
          });
        }
      }

      return _auth.currentUser;
    } catch (e) {
      print('Error signing in with Google: $e');
      throw Exception('An error occurred while signing in with Google.');
    }
  }


  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('An error occurred while signing out.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('An error occurred while resetting password.');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).delete();
      await _auth.currentUser!.delete();
    } catch (e) {
      throw Exception('An error occurred while deleting user: $e');
    }
  }



}