import 'package:flutter/material.dart';
import 'screens/otp_home_screen.dart';

void main() {
  runApp(const OTPGeneratorApp());
}

class OTPGeneratorApp extends StatelessWidget {
  const OTPGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Generator & Validator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const OTPHomeScreen(),
    );
  }
}
