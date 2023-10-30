import 'package:jeeth_app/common_functions.dart';

class Driver {
  final int id;
  String name;
  String phone;
  String countryCode;
  String avatar;
  String email;
  DateTime? dob;
  String gender;
  String bankName;
  String accNumber;
  String ifscCode;
  String address;

  String accessToken;
  String fcmToken;
  bool isActive;

  Driver({
    required this.id,
    this.name = '',
    this.email = '',
    this.dob,
    this.address = '',
    required this.phone,
    this.countryCode = '91',
    this.bankName = '',
    this.accNumber = '',
    this.ifscCode = '',
    this.avatar = '',
    this.gender = '',
    this.accessToken = '',
    this.fcmToken = '',
    this.isActive = false,
  });

  static Driver jsonToDriver(Map driver) => Driver(
        id: driver['id'],
        name: driver['name'] ?? '',
        address: driver['address'] ?? '',

        phone: driver['phone'],
        bankName: driver['bankName'] ?? '',
        accNumber: driver['accNumber'] ?? '',
        ifscCode: driver['ifscCode'] ?? '',

        countryCode: driver['countryCode'] ?? '91',
        gender: driver['gender'] ?? '',
        email: driver['email'] ?? '',
        dob: getParseDate(driver['dob']),
        avatar: driver['avatar'] ?? '',

        isActive: driver['isActive'] ?? true,

        // fcmToken: user['fcmToken'] ?? '',
      );
}
