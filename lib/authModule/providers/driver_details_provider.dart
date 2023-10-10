import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/driver_details.dart';

class DriverDetailsProvider extends ChangeNotifier {
  List<DriverDetails> _driverDetails = [];

  List<DriverDetails> get driverDetails => [..._driverDetails];

  void addData(DriverDetails newData) {
    _driverDetails.add(newData);
    notifyListeners();
  }

  void updateData(List<DriverDetails> newDataList) {
    _driverDetails = newDataList;
    notifyListeners();
  }
}
