class User {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isRegistrationComplete;
  final bool hasDriverLicense;
  final String? driverLicenseFront;
  final String? driverLicenseBack;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.isRegistrationComplete,
    required this.hasDriverLicense,
    this.driverLicenseFront,
    this.driverLicenseBack,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      isRegistrationComplete: json['isRegistrationComplete'] ?? false,
      hasDriverLicense: json['hasDriverLicense'] ?? false,
      driverLicenseFront: json['driverLicenseFront'],
      driverLicenseBack: json['driverLicenseBack'],
    );
  }
}