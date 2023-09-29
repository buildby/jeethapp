class User {
  final String id;
  String fullName;
  String phone;
  String countryCode;
  String avatar;
  String email;
  DateTime? dob;
  String gender;
  String accessToken;
  String fcmToken;
  bool isActive;

  User({
    required this.id,
    this.fullName = '',
    this.email = '',
    this.dob,
    this.phone = '',
    this.countryCode = '',
    this.avatar = '',
    this.gender = '',
    this.accessToken = '',
    this.fcmToken = '',
    this.isActive = false,
    // required this.fcmToken,
  });

  static User jsonToUser(
    Map user, {
    required String accessToken,
  }) =>
      User(
        id: user['_id'],
        fullName: user['fullName'],
        phone: user['phone'],
        countryCode: user['countryCode'],
        gender: user['gender'],
        email: user['email'],
        // dob: DateTime.parse(user['dob']).toLocal(),
        avatar: user['avatar'] ?? '',
        accessToken: accessToken,
        isActive: user['isActive'] ?? true,
        // fcmToken: user['fcmToken'] ?? '',
      );
}
