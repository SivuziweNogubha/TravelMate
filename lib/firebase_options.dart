// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB67jsX3bbT5-RX1Y78328xJE2d0P0jCo8',
    appId: '1:461545935936:web:33b34d034ec27c22733ba5',
    messagingSenderId: '461545935936',
    projectId: 'e-hailing-94d2c',
    authDomain: 'e-hailing-94d2c.firebaseapp.com',
    storageBucket: 'e-hailing-94d2c.appspot.com',
    measurementId: 'G-1QWCYEXVWV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsx0rKMwr7EIIjcLOd5BrTZYHG1jzhLQo',
    appId: '1:461545935936:android:9c1bb32412a7ab02733ba5',
    messagingSenderId: '461545935936',
    projectId: 'e-hailing-94d2c',
    storageBucket: 'e-hailing-94d2c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQ0OiIujhZ3Wh3bKSLHQOoZLaRZZUAKec',
    appId: '1:461545935936:ios:461832cea1f962e4733ba5',
    messagingSenderId: '461545935936',
    projectId: 'e-hailing-94d2c',
    storageBucket: 'e-hailing-94d2c.appspot.com',
    iosClientId: '461545935936-8s16cclbtr7898qqs2gej80apmr2ujgp.apps.googleusercontent.com',
    iosBundleId: 'za.co.wethinkcode.widgetsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQ0OiIujhZ3Wh3bKSLHQOoZLaRZZUAKec',
    appId: '1:461545935936:ios:461832cea1f962e4733ba5',
    messagingSenderId: '461545935936',
    projectId: 'e-hailing-94d2c',
    storageBucket: 'e-hailing-94d2c.appspot.com',
    iosClientId: '461545935936-8s16cclbtr7898qqs2gej80apmr2ujgp.apps.googleusercontent.com',
    iosBundleId: 'za.co.wethinkcode.widgetsApp',
  );
}
