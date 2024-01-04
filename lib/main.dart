import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/pages/home_page.dart';
import 'package:whatsapp/pages/landing_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xff6c63ff);
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        primaryColor: color,
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? const HomePage()
          : const LandingScreen(),
    );
  }
}
