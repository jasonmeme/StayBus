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
    apiKey: 'AIzaSyAv6hCUh3xQSjE-KupBcKLfPd8qKjY0hoA',
    appId: '1:316860238361:web:211167d4476e44bff13888',
    messagingSenderId: '316860238361',
    projectId: 'staybus-7d97c',
    authDomain: 'staybus-7d97c.firebaseapp.com',
    storageBucket: 'staybus-7d97c.appspot.com',
    measurementId: 'G-NH04D92KFF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBivW73RIw9c3JfIlRStJSx-aT1CNKOTWM',
    appId: '1:316860238361:android:ac728565afa976d2f13888',
    messagingSenderId: '316860238361',
    projectId: 'staybus-7d97c',
    storageBucket: 'staybus-7d97c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhFoqSpRPUQhpOfwtQ60Vo9-X7_JgTf3I',
    appId: '1:316860238361:ios:ad3eec132e5f570df13888',
    messagingSenderId: '316860238361',
    projectId: 'staybus-7d97c',
    storageBucket: 'staybus-7d97c.appspot.com',
    iosClientId: '316860238361-8hotr3u5k85ogp3ama81j6mm6sjts548.apps.googleusercontent.com',
    iosBundleId: 'com.example.stayBus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhFoqSpRPUQhpOfwtQ60Vo9-X7_JgTf3I',
    appId: '1:316860238361:ios:ad3eec132e5f570df13888',
    messagingSenderId: '316860238361',
    projectId: 'staybus-7d97c',
    storageBucket: 'staybus-7d97c.appspot.com',
    iosClientId: '316860238361-8hotr3u5k85ogp3ama81j6mm6sjts548.apps.googleusercontent.com',
    iosBundleId: 'com.example.stayBus',
  );
}