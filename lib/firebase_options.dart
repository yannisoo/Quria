// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] as String,
    appId: dotenv.env['FIREBASE_WEB_APP_ID'] as String,
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] as String,
    projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID'] as String,
    authDomain: dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] as String,
    storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] as String,
    measurementId: dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'] as String,
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY'] as String,
    appId: dotenv.env['FIREBASE_ANDROID_APP_ID'] as String,
    messagingSenderId:
        dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID'] as String,
    projectId: dotenv.env['FIREBASE_ANDROID_PROJECT_ID'] as String,
    storageBucket: dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET'] as String,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] as String,
    appId: dotenv.env['FIREBASE_IOS_APP_ID'] as String,
    messagingSenderId: dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID'] as String,
    projectId: dotenv.env['FIREBASE_IOS_PROJECT_ID'] as String,
    storageBucket: dotenv.env['FIREBASE_IOS_STORAGE_BUCKET'] as String,
    iosClientId: dotenv.env['FIREBASE_IOS_CLIENT_ID'] as String,
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] as String,
  );
}
