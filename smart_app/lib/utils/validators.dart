class Validators {
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    // Accepter les numéros avec indicatif, espaces, tirets, etc.
    final cleanedValue = value.trim().replaceAll(RegExp(r'[\s\-\(\)+]'), '');
    final phoneRegExp = RegExp(r'^\d{9,15}$');
    if (!phoneRegExp.hasMatch(cleanedValue)) {
      return 'Please enter a valid phone number (9-15 digits)';
    }
    return null;
  }
}