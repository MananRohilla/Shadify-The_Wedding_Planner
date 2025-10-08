import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
// import 'services/offline_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const WeddingPlannerApp());
}



class WeddingPlannerApp extends StatelessWidget {
  const WeddingPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFE91E63),
          secondary: const Color(0xFFF8BBD0),
          tertiary: const Color(0xFFFFD700),
        ),
        // Using system fonts instead of Google Fonts to avoid network dependency
        fontFamily: 'Roboto', // Use system font
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFE91E63),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE91E63),
            fontFamily: 'Roboto',
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
