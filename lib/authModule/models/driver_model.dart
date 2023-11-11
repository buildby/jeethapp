import 'dart:convert';
import 'package:jeeth_app/authModule/models/vehicle_detail_modal.dart';
import 'package:jeeth_app/authModule/models/vendor_model.dart';
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
  String ownerName;
  String ownerPhoneNumber;
  String ownerAddress;
  String vehicleImage;
  Vehicle vehicle;
  String accessToken;
  String fcmToken;
  bool isActive;
  Earnings earnings;
  int? vendorId;
  String status;
  Vendor? vendor;

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
    this.ownerName = '',
    this.ownerPhoneNumber = '',
    this.ownerAddress = '',
    this.vehicleImage = '',
    required this.vehicle,
    this.accessToken = '',
    this.fcmToken = '',
    this.isActive = false,
    required this.earnings,
    this.vendorId,
    required this.status,
    this.vendor,
  });

  static Driver jsonToDriver(Map driver) {
    Earnings earning = Earnings(
      accrued: 0,
      currentMonth: 0,
    );

    final int i = driver['MetaData'] != null
        ? (driver['MetaData'] as List)
            .indexWhere((element) => element['key'] == 'Earnings')
        : -1;
    if (i != -1) {
      final earningsMap = json.decode(driver['MetaData'][i]['value']);
      earning.accrued = earningsMap['Accrued'] ?? 0;
      earning.currentMonth = earningsMap['Current Month'] ?? 0;
    }
    return Driver(
      id: driver['id'],
      name: driver['name'] ?? '',
      address: driver['address'] ?? '',
      vendorId: driver['vendor_id'],
      status: driver['status'] ?? '',
      phone: driver['phone'],
      bankName: driver['bankName'] ?? '',
      accNumber: driver['accNumber'] ?? '',
      ifscCode: driver['ifscCode'] ?? '',
      earnings: earning,
      countryCode: driver['countryCode'] ?? '91',
      gender: driver['gender'] ?? '',
      email: driver['email'] ?? '',
      dob: getParseDate(driver['dob']),
      avatar: driver['avatar'] ?? '',
      ownerName: driver['ownerName'] ?? '',
      ownerAddress: driver['ownerAddress'] ?? '',
      ownerPhoneNumber: driver['ownerPhoneNumber'] ?? '',
      vehicleImage: driver['vehicleImage'] ?? '',
      vendor: driver['Vendor'] != null
          ? Vendor.jsonToVendor(driver['Vendor'])
          : null,
      vehicle: Vehicle(
        vehicleModel: driver['vehicleModel'] ?? '',
        vehicleType: driver['vehicleType'] ?? '',
        vehicleMake: driver['vehicleMake'] ?? '',
        vehicleNumber: driver['vehicleNumber'] ?? '',
        vehicleYear: driver['vehicleYear'] ?? '',
        vehicleFuelType: driver['vehicleFuelType'] ?? '',
      ),

      isActive: driver['isActive'] ?? true,

      // fcmToken: user['fcmToken'] ?? '',
    );
  }
}

class Earnings {
  num accrued;
  num currentMonth;

  Earnings({
    required this.accrued,
    required this.currentMonth,
  });
}
