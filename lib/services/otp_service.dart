import 'dart:math';

class OTPService {
  // Generate 6-digit OTP
  static String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Validate OTP
  static bool validateOTP(String input, String generatedOTP) {
    return input == generatedOTP;
  }
}
