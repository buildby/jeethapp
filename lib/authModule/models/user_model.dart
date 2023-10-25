import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeeth_app/common_functions.dart';

class User {
  final int id;
  String fullName;
  String phone;
  String countryCode;
  String avatar;
  String email;
  DateTime? dob;
  String gender;
  String role;

  String accessToken;
  String fcmToken;
  bool isActive;

  LatLng? coordinates;

  User({
    required this.id,
    this.fullName = '',
    this.email = '',
    this.dob,
    required this.phone,
    required this.role,
    this.countryCode = '91',
    this.avatar = '',
    this.gender = '',
    this.accessToken = '',
    this.fcmToken = '',
    this.isActive = false,
    this.coordinates,
  });

  static User jsonToUser(
    Map user, {
    required String accessToken,
  }) =>
      User(
        id: user['id'],
        fullName: user['fullName'] ?? '',
        phone: user['phone'],
        role: user['role'],

        countryCode: user['countryCode'] ?? '91',
        gender: user['gender'] ?? '',
        email: user['email'] ?? '',
        dob: getParseDate(user['dob']),
        avatar: user['avatar'] ?? '',

        accessToken: accessToken,
        isActive: user['isActive'] ?? true,

        // fcmToken: user['fcmToken'] ?? '',
      );
}
