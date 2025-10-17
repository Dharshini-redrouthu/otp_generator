import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/otp_service.dart';
import 'success_screen.dart';
import 'dart:async';

class OTPHomeScreen extends StatefulWidget {
  const OTPHomeScreen({super.key});

  @override
  State<OTPHomeScreen> createState() => _OTPHomeScreenState();
}

class _OTPHomeScreenState extends State<OTPHomeScreen> {
  String _generatedOTP = "";
  int _timeLeft = 0;
  Timer? _timer;
  final TextEditingController _otpController = TextEditingController();

  void _generateOTP() {
    setState(() {
      _generatedOTP = OTPService.generateOTP();
      _timeLeft = 30; // OTP visible for 30 seconds
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _generatedOTP = "";
          timer.cancel();
        }
      });
    });
  }

  void _copyOTP() {
    if (_generatedOTP.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedOTP));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP copied to clipboard!")),
      );
    }
  }

  void _validateOTP() {
    if (OTPService.validateOTP(_otpController.text, _generatedOTP)) {
      _timer?.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "OTP Generator | Validator",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _generateOTP,
                    child: const Text("Generate OTP"),
                  ),
                  const SizedBox(height: 16),

                  // OTP Display Section
                  if (_generatedOTP.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "OTP: $_generatedOTP",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: _copyOTP,
                                icon: const Icon(Icons.copy, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Expires in $_timeLeft sec",
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),

                  const SizedBox(height: 25),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _validateOTP,
                    child: const Text("Validate OTP"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
