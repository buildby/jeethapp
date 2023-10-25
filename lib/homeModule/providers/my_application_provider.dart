import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/marketplace_model.dart';
import 'package:jeeth_app/homeModule/models/my_application_model.dart';

class MyApplicationProvider with ChangeNotifier {
  List<MyApplication> _myApplications = [];

  MyApplicationProvider() {
    _myApplications = [
      MyApplication(
        id: 1,
        vendorName: Marketplace(id: '1', vendername: 'Shyam Salasar Logistic'),
        status: 'Approved!',
        area: 'Google - Block 1 (Mindspace_1)',
        fieldOfficerName: 'Md. Junaid',
        fieldOfficerNumbers: ['+91 8220151247', ' +91 8206525176'],
        inCorrectDocs: 'Missing documents',
        logo: 'assets/images/4_wheel.png',
      ),
      MyApplication(
        id: 2,
        vendorName: Marketplace(id: '2', vendername: 'Shyam Salasar Logistic'),
        status: 'Rejected!',
        area: 'Google - Block 1 (Mindspace_1)',
        fieldOfficerName: 'Md. Junaid',
        fieldOfficerNumbers: ['+91 8220151247', '+91 8206525176'],
        inCorrectDocs: 'Missing documents',
        logo: 'assets/images/4_wheel.png',
      ),
      MyApplication(
        id: 3,
        vendorName: Marketplace(id: '3', vendername: 'Shyam Salasar Logistic'),
        status: 'Pending!',
        area: 'Google - Block 1 (Mindspace_1)',
        fieldOfficerName: 'Md. Junaid',
        fieldOfficerNumbers: ['+91 8220151247', '+91 8206525176'],
        inCorrectDocs: 'Missing documents',
        logo: 'assets/images/4_wheel.png',
      ),
    ];
  }

  List<MyApplication> get myApplications => _myApplications;
}
