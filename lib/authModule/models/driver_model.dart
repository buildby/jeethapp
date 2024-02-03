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

      // id: '',
    );

    final int i = driver['MetaData'] != null
        ? (driver['MetaData'] as List)
            .indexWhere((element) => element['key'] == 'Earnings')
        : -1;
    if (i != -1) {
      final earningsMap = json.decode(driver['MetaData'][i]['value']);
      earning.accrued = earningsMap['Accrued'] ?? 0;
      earning.currentMonth = earningsMap['Current Month'] ?? 0;
      earning.currentMonthEarning = earningsMap['currentMonthEarning'] ?? 0;
      earning.widthDrawalAmount = earningsMap['widthDrawalAmount'] ?? 0;

      // earning.id = earningsMap['id'];
      // earning.clientsiteId = earningsMap['clientsite_id'] ?? '';
      // earning.distanceTravelled = earningsMap['distanceTravelled'] ?? '';
      // earning.escort = earningsMap['escort'] ?? false;
      // earning.eta = getParseDate(earningsMap['eta']);
      // earning.ota = getParseDate(earningsMap['ota']);
      // earning.etd = getParseDate(earningsMap['etd']);
      // earning.otd = getParseDate(earningsMap['otd']);
      // earning.shiftTime = getParseDate(earningsMap['shiftTime']);
      // earning.type = earningsMap['ClientSite']['BusinessModel']['type'] ?? '';
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
  final Performance? performance;
  String date;
  List? earning;
  num accrued;
  num currentMonth;
  num? currentMonthEarning;
  num? widthDrawalAmount;

  Earnings({
    this.performance,
    this.earning,
    this.date = '',
    this.currentMonthEarning,
    this.widthDrawalAmount,
    required this.accrued,
    required this.currentMonth,
  });

  static Earnings jsonToEarning(Map earning) {
    return Earnings(
      accrued: earning['Accrued'] ?? 0,
      currentMonth: earning['Current Month'] ?? 0,
      currentMonthEarning: earning['currentMonthEarning'] ?? 0,
      widthDrawalAmount: earning['widthDrawalAmount'] ?? 0,
      performance: Performance.fromJsonPerformance(earning['performance']),
      earning: earning['earnings'] ?? [],
    );
  }
}

class Performance {
  final String ota;
  final String otd;

  Performance({
    required this.ota,
    required this.otd,
  });

  factory Performance.fromJsonPerformance(Map<String, dynamic> performance) {
    return Performance(
      ota: performance['ota'] ?? '',
      otd: performance['otd'] ?? '',
    );
  }
}
