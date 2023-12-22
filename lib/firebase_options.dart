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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCTBTKdzRlt0QwrsxdMQQfhnSjQAefZ3cI',
    appId: '1:143691649695:web:847f0af67c32f9428c88aa',
    messagingSenderId: '143691649695',
    projectId: 'smartcheckout-d61b9',
    authDomain: 'smartcheckout-d61b9.firebaseapp.com',
    storageBucket: 'smartcheckout-d61b9.appspot.com',
    measurementId: 'G-PBKQDXBJ6Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIPZOqrHfettNz6ZBbBVijGH6eZjq7xc0',
    appId: '1:143691649695:android:fc7dab4a6fb01b4f8c88aa',
    messagingSenderId: '143691649695',
    projectId: 'smartcheckout-d61b9',
    storageBucket: 'smartcheckout-d61b9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCBPkUhPAp9cJecaCvktUAM6XjalbAU5M',
    appId: '1:143691649695:ios:bf7de9aae8c1ee298c88aa',
    messagingSenderId: '143691649695',
    projectId: 'smartcheckout-d61b9',
    storageBucket: 'smartcheckout-d61b9.appspot.com',
    iosBundleId: 'com.qianyi.fypProject',
  );
}
