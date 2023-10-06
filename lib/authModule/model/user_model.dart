import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeeth_app/common_functions.dart';

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
  bool isGuest;
  LatLng? coordinates;

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
    this.isGuest = false,
    this.coordinates,
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
        dob: getParseDate(user['dob'])!,
        avatar: user['avatar'] ?? '',

        accessToken: accessToken,
        isActive: user['isActive'] ?? true,

        // fcmToken: user['fcmToken'] ?? '',
      );
}
