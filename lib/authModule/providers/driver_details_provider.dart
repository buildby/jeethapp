import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/vehicle_detail_modal.dart';

class VehicleDetailProvider extends ChangeNotifier {
  List<Vehicle> _driverDetails = [];

  List<Vehicle> get driverDetails => [..._driverDetails];

  // void addData(VehicleDetail newData) {
  //   _driverDetails.add(newData);
  //   notifyListeners();
  // }

  // void updateData(List<VehicleDetail> newDataList) {
  //   _driverDetails = newDataList;
  //   notifyListeners();
  // }
}
