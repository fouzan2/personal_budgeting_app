import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'mainScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC_W82J_FKLe1sbhlm-MGPpjgyiYcsXVjU',
      appId: '1:470703008344:android:9241499d79ecaa4272782d',
      messagingSenderId: '470703008344',
      projectId: 'personal-budgeting-app-4540f',
      storageBucket: 'personal-budgeting-app-4540f.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Budgeting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const mainScreen(),
    );
  }
}