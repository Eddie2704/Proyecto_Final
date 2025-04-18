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
    apiKey: 'AIzaSyAmp1pPsg_H2uvqCzfkxu7JUJxDOWLzQ4E',
    appId: '1:641430838021:web:22f4b718ccc67c3241b56c',
    messagingSenderId: '641430838021',
    projectId: 'fir-prueba-unah',
    authDomain: 'fir-prueba-unah.firebaseapp.com',
    storageBucket: 'fir-prueba-unah.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAHCgF4N_WAzWugYlJzpqgA1jxCKRlFCY',
    appId: '1:641430838021:android:95d90c5a51c818b941b56c',
    messagingSenderId: '641430838021',
    projectId: 'fir-prueba-unah',
    storageBucket: 'fir-prueba-unah.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAD71X1PcxQ50hJXVh3M2hl-vVjLL3NEgc',
    appId: '1:641430838021:ios:b56d5ec6f0f553f141b56c',
    messagingSenderId: '641430838021',
    projectId: 'fir-prueba-unah',
    storageBucket: 'fir-prueba-unah.firebasestorage.app',
    iosBundleId: 'com.example.trainathomeapp',
  );
}
