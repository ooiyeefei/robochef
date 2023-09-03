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
    apiKey: 'AIzaSyChpYQdpBAeNU3qcF5XKlmxx0kEilWn_Gc',
    appId: '1:713719967044:web:c39b24d5c2df1fb4083b11',
    messagingSenderId: '713719967044',
    projectId: 'reinvent-robochef',
    authDomain: 'reinvent-robochef.firebaseapp.com',
    storageBucket: 'reinvent-robochef.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDr7PSAQ29U2IBIbiYoFBhR-Icp5uHgOo4',
    appId: '1:713719967044:android:870c9eefaa3ad943083b11',
    messagingSenderId: '713719967044',
    projectId: 'reinvent-robochef',
    storageBucket: 'reinvent-robochef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqasO2ACrPFxylWRXagCgE-0EPxGG9OZE',
    appId: '1:713719967044:ios:63877053ff25c921083b11',
    messagingSenderId: '713719967044',
    projectId: 'reinvent-robochef',
    storageBucket: 'reinvent-robochef.appspot.com',
    iosClientId: '713719967044-f2gpuohfnhp3kgua9m3amvna6ctc2ac8.apps.googleusercontent.com',
    iosBundleId: 'com.example.robochef',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCqasO2ACrPFxylWRXagCgE-0EPxGG9OZE',
    appId: '1:713719967044:ios:3b92b7be53c6bc66083b11',
    messagingSenderId: '713719967044',
    projectId: 'reinvent-robochef',
    storageBucket: 'reinvent-robochef.appspot.com',
    iosClientId: '713719967044-dfcg4io8pjnkphrg9a0k5d921c1uj20g.apps.googleusercontent.com',
    iosBundleId: 'com.example.robochef.RunnerTests',
  );
}