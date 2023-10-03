import 'package:flutter/material.dart';
import 'package:marg_rakshak/components/static/assets_list.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MaterialApp(
        home: Column(
          children: <Widget>[
            Text("data", style: TextStyle(fontFamily: "Lexend", fontWeight: FontWeight.w400),),
          ],
        ),
      ),
    );
  }
}
