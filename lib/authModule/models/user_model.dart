import 'package:jeeth_app/authModule/models/driver_model.dart';

class User {
  final int id;
  String phone;

  Driver driver;

  String accessToken;
  String fcmToken;

  User({
    required this.id,
    required this.phone,
    required this.driver,
    this.accessToken = '',
    this.fcmToken = '',
  });

  static User jsonToUser(
    Map user, {
    required String accessToken,
  }) =>
      User(
        id: user['id'],
        driver: Driver.jsonToDriver(user['driver']),
        phone: user['phone'],
        accessToken: accessToken,

        // fcmToken: user['fcmToken'] ?? '',
      );
}
