import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/sign_in.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.epilogueTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SignInPage(),
    );
  }
}