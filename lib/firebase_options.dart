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
    apiKey: 'AIzaSyAFMRb1yyq12lMoUpk0b2Jd2xPUNepVnww',
    appId: '1:866788366088:web:a0a3c9c6b8fb5427d43ebd',
    messagingSenderId: '866788366088',
    projectId: 'walleatproject',
    authDomain: 'walleatproject.firebaseapp.com',
    storageBucket: 'walleatproject.firebasestorage.app',
    measurementId: 'G-7T5E4MM12B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz8DQn96HKK7cKwapRglPwur4M5_pSgb8',
    appId: '1:866788366088:android:399deda906a11496d43ebd',
    messagingSenderId: '866788366088',
    projectId: 'walleatproject',
    storageBucket: 'walleatproject.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNmpodHrcFnbFqDZzqB5lk7Fy8jFG46wI',
    appId: '1:866788366088:ios:2ddcf5cbcbef35dad43ebd',
    messagingSenderId: '866788366088',
    projectId: 'walleatproject',
    storageBucket: 'walleatproject.firebasestorage.app',
    iosBundleId: 'com.example.wallEatProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNmpodHrcFnbFqDZzqB5lk7Fy8jFG46wI',
    appId: '1:866788366088:ios:2ddcf5cbcbef35dad43ebd',
    messagingSenderId: '866788366088',
    projectId: 'walleatproject',
    storageBucket: 'walleatproject.firebasestorage.app',
    iosBundleId: 'com.example.wallEatProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAFMRb1yyq12lMoUpk0b2Jd2xPUNepVnww',
    appId: '1:866788366088:web:bf3974c2dd22fdc5d43ebd',
    messagingSenderId: '866788366088',
    projectId: 'walleatproject',
    authDomain: 'walleatproject.firebaseapp.com',
    storageBucket: 'walleatproject.firebasestorage.app',
    measurementId: 'G-31BQ28EHR7',
  );
}
