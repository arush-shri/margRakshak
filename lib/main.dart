import 'package:flutter/material.dart';
import 'package:marg_rakshak/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(
      const MaterialApp(home: LoginView())
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


