import 'dart:math';

class PasswordUtility {
  // Character sets
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';

  // FIX: single quotes used to avoid `$` interpolation error
  static const String _specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static const String _letters = _lowercase + _uppercase;

  // -------------------------------
  // PASSWORD VALIDATION
  // -------------------------------
  static bool validate(String password, String level) {
    if (password.isEmpty) return false;

    switch (level) {
      case 'low':
        return password.length >= 6;

      case 'intermediate':
        return password.length >= 8 &&
            _hasLetter(password) &&
            _hasDigit(password);

      case 'strong':
        return password.length >= 12 &&
            _hasLowercase(password) &&
            _hasUppercase(password) &&
            _hasDigit(password) &&
            _hasSpecialChar(password);

      default:
        throw ArgumentError('Invalid strength level');
    }
  }

  // -------------------------------
  // PASSWORD GENERATION
  // -------------------------------
  static String generate(String level) {
    final random = Random.secure();

    String chars;
    int length;

    switch (level) {
      case 'low':
        chars = _letters + _digits;
        length = 6;
        break;

      case 'intermediate':
        chars = _letters + _digits;
        length = 8;
        break;

      case 'strong':
        chars = _lowercase + _uppercase + _digits + _specialChars;
        length = 12;
        break;

      default:
        throw ArgumentError('Invalid strength level');
    }

    // Ensure generated password actually meets rules
    while (true) {
      final password = List.generate(
        length,
        (_) => chars[random.nextInt(chars.length)],
      ).join();

      if (validate(password, level)) {
        return password;
      }
    }
  }

  // -------------------------------
  // HELPER METHODS
  // -------------------------------
  static bool _hasLowercase(String s) => s.contains(RegExp(r'[a-z]'));
  static bool _hasUppercase(String s) => s.contains(RegExp(r'[A-Z]'));
  static bool _hasLetter(String s) => s.contains(RegExp(r'[A-Za-z]'));
  static bool _hasDigit(String s) => s.contains(RegExp(r'\d'));
  static bool _hasSpecialChar(String s) =>
      s.contains(RegExp(r'[!@#\$%^&*()_\+\-\=\[\]\{\}\|;:,.<>?]'));
}

// -------------------------------
// MAIN (TESTING)
// -------------------------------
void main() {
  final low = PasswordUtility.generate('low');
  final intermediate = PasswordUtility.generate('intermediate');
  final strong = PasswordUtility.generate('strong');

  print('Low Password         : $low');
  print('Valid Low            : ${PasswordUtility.validate(low, 'low')}');
  print('');

  print('Intermediate Password: $intermediate');
  print(
      'Valid Intermediate   : ${PasswordUtility.validate(intermediate, 'intermediate')}');
  print('');

  print('Strong Password      : $strong');
  print(
      'Valid Strong         : ${PasswordUtility.validate(strong, 'strong')}');
}
