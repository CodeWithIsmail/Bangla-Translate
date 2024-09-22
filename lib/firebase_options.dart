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
    apiKey: 'AIzaSyBgkTxs9LIa3Fxb10D4Am5DKjiWKCll9VI',
    appId: '1:873304356745:web:2c3f6a79c8863822bdd358',
    messagingSenderId: '873304356745',
    projectId: 'banglalens-14c21',
    authDomain: 'banglalens-14c21.firebaseapp.com',
    storageBucket: 'banglalens-14c21.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtlgvDA4uCOcPpRVBZKA1j0tbiZgVB-OA',
    appId: '1:873304356745:android:407a0246cb05a280bdd358',
    messagingSenderId: '873304356745',
    projectId: 'banglalens-14c21',
    storageBucket: 'banglalens-14c21.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRcA4-ya8eELhnbdm7ufw6jC5BpQuX3Ng',
    appId: '1:873304356745:ios:8830453e4e798a8bbdd358',
    messagingSenderId: '873304356745',
    projectId: 'banglalens-14c21',
    storageBucket: 'banglalens-14c21.appspot.com',
    iosBundleId: 'com.example.banglaTranslate',
  );
}
