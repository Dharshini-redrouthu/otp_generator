import 'package:flutter/material.dart';
import '../services/otp_service.dart';
import 'package:flutter/services.dart';

class OTPHomeScreen extends StatefulWidget {
  const OTPHomeScreen({super.key});

  @override
  State<OTPHomeScreen> createState() => _OTPHomeScreenState();
}

class _OTPHomeScreenState extends State<OTPHomeScreen>
    with TickerProviderStateMixin {
  String? _generatedOTP;
  final TextEditingController _otpController = TextEditingController();
  final OTPService _otpService = OTPService();
  bool _isCopied = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  void _generateOTP() {
    setState(() {
      _generatedOTP = _otpService.generateOTP();
      _isCopied = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your OTP: $_generatedOTP (valid for 60 seconds)'),
        duration: const Duration(seconds: 3),
      ),
    );

    _otpService.startOTPTimer(() {
      setState(() {
        _generatedOTP = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP expired! Please generate again.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _validateOTP() {
    final userInput = _otpController.text.trim();
    if (_generatedOTP == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate OTP first')),
      );
      return;
    }

    if (userInput == _generatedOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Validated Successfully!')),
      );

      // Clear OTP after success
      setState(() {
        _generatedOTP = null;
        _otpController.clear();
      });

      Navigator.pushNamed(context, '/success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP! Try again.')),
      );
    }
  }

  void _copyOTP() {
    if (_generatedOTP != null) {
      Clipboard.setData(ClipboardData(text: _generatedOTP!));
      setState(() => _isCopied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP copied to clipboard!')),
      );
    }
  }

  @override
  void dispose() {
    _otpService.cancelTimer();
    _otpController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'OTP Generator | Validator',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Generate Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _generateOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Generate OTP',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // OTP Display
                if (_generatedOTP != null)
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OTP: $_generatedOTP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isCopied ? Icons.check_circle : Icons.copy,
                            color: _isCopied ? Colors.green : Colors.blue,
                          ),
                          onPressed: _copyOTP,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Input field
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Validate Button
                ElevatedButton(
                  onPressed: _validateOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Validate OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
