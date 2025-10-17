import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

class OTPService {
  Timer? _timer;

  /// Generate a random 6-digit OTP
  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Start OTP timer (60 seconds)
  void startOTPTimer(VoidCallback onExpire) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 60), onExpire);
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}
