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
        return windows;
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
    apiKey: 'AIzaSyC12i7K7j2v0MIY08iWqvmqOuk__odRvVU',
    appId: '1:74797258967:web:0780d903160decbfbcb892',
    messagingSenderId: '74797258967',
    projectId: 'mycicle-e2369',
    authDomain: 'mycicle-e2369.firebaseapp.com',
    storageBucket: 'mycicle-e2369.firebasestorage.app',
    measurementId: 'G-D4455H649Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCn4aQ1_CAX2nVk2Z41XKGvOrCGJIC_WCk',
    appId: '1:74797258967:android:eb84e13ec42a1a7abcb892',
    messagingSenderId: '74797258967',
    projectId: 'mycicle-e2369',
    storageBucket: 'mycicle-e2369.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtWU6ntgWXhl-N7MiBy2q5DAR1o1ClHhM',
    appId: '1:74797258967:ios:19ac5d7093d28f88bcb892',
    messagingSenderId: '74797258967',
    projectId: 'mycicle-e2369',
    storageBucket: 'mycicle-e2369.firebasestorage.app',
    iosBundleId: 'com.example.myPeriodTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtWU6ntgWXhl-N7MiBy2q5DAR1o1ClHhM',
    appId: '1:74797258967:ios:19ac5d7093d28f88bcb892',
    messagingSenderId: '74797258967',
    projectId: 'mycicle-e2369',
    storageBucket: 'mycicle-e2369.firebasestorage.app',
    iosBundleId: 'com.example.myPeriodTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC12i7K7j2v0MIY08iWqvmqOuk__odRvVU',
    appId: '1:74797258967:web:27fab6e812dfecb0bcb892',
    messagingSenderId: '74797258967',
    projectId: 'mycicle-e2369',
    authDomain: 'mycicle-e2369.firebaseapp.com',
    storageBucket: 'mycicle-e2369.firebasestorage.app',
    measurementId: 'G-JD6VP0EGVP',
  );
}
