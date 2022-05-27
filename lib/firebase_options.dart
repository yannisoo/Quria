// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAHPZS_6edfw4AVLW4VM1_hhkxrVUk9Mr0',
    appId: '1:653536181122:web:c81569f39c669fc18eed9b',
    messagingSenderId: '653536181122',
    projectId: 'quriacompanion-13944',
    authDomain: 'quriacompanion-13944.firebaseapp.com',
    storageBucket: 'quriacompanion-13944.appspot.com',
    measurementId: 'G-RW0ENQMR23',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDX67qhm1B6JeRhZ1zcLKfuU_wx6FBriFM',
    appId: '1:653536181122:android:651521385f728d098eed9b',
    messagingSenderId: '653536181122',
    projectId: 'quriacompanion-13944',
    storageBucket: 'quriacompanion-13944.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkDPScW8QD1NXA34WgFwJvnZ9pt5P8jfs',
    appId: '1:653536181122:ios:6341e6a82f0095f18eed9b',
    messagingSenderId: '653536181122',
    projectId: 'quriacompanion-13944',
    storageBucket: 'quriacompanion-13944.appspot.com',
    iosClientId: '653536181122-jqc4vj7f6a5l38jjtg6a2clrvjgilqmp.apps.googleusercontent.com',
    iosBundleId: 'com.example.quria',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkDPScW8QD1NXA34WgFwJvnZ9pt5P8jfs',
    appId: '1:653536181122:ios:9463967f24b5a19e8eed9b',
    messagingSenderId: '653536181122',
    projectId: 'quriacompanion-13944',
    storageBucket: 'quriacompanion-13944.appspot.com',
    iosClientId: '653536181122-gdh2j5i08lmu22cji0ur79k0dipr3h1n.apps.googleusercontent.com',
    iosBundleId: 'com.quria.quriaCompanion',
  );
}
