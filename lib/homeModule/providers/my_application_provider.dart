import 'package:flutter/material.dart';
import 'package:jeeth_app/homeModule/models/my_application_model.dart';

import '../../api.dart';
import '../../http_helper.dart';

class MyApplicationProvider with ChangeNotifier {
  List<MyApplication> _myApplications = [];

  MyApplicationProvider() {
    _myApplications = [
      // MyApplication(
      //   id: 1,
      //   // vendorName: Marketplace(id: 1, vendername: 'Shyam Salasar Logistic'),
      //   status: 'Approved!',
      //   area: 'Google - Block 1 (Mindspace_1)',
      //   fieldOfficerName: 'Md. Junaid',
      //   fieldOfficerNumbers: ['+91 8220151247', ' +91 8206525176'],
      //   inCorrectDocs: 'Missing documents',
      //   logo: 'assets/images/4_wheel.png',
      // ),
      // MyApplication(
      //   id: 2,
      //   vendorName: Marketplace(id: 2, vendername: 'Shyam Salasar Logistic'),
      //   status: 'Rejected!',
      //   area: 'Google - Block 1 (Mindspace_1)',
      //   fieldOfficerName: 'Md. Junaid',
      //   fieldOfficerNumbers: ['+91 8220151247', '+91 8206525176'],
      //   inCorrectDocs: 'Missing documents',
      //   logo: 'assets/images/4_wheel.png',

      // ),
      // MyApplication(
      //   id: 3,
      //   vendorName: Marketplace(id: 3, vendername: 'Shyam Salasar Logistic'),
      //   status: 'Pending!',
      //   area: 'Google - Block 1 (Mindspace_1)',
      //   fieldOfficerName: 'Md. Junaid',
      //   fieldOfficerNumbers: ['+91 8220151247', '+91 8206525176'],
      //   inCorrectDocs: 'Missing documents',
      //   logo: 'assets/images/4_wheel.png',
      // ),
    ];
  }

  List<MyApplication> get myApplications => _myApplications;

  createMyApplication({
    required Map body,
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['createMyApplication']}';

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
        accessToken: accessToken,
      );

      if (response['result'] == 'success') {
        _myApplications.insert(
          0,
          MyApplication.jsonToMyApplication(response['data']),
        );
        notifyListeners();
      }
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create application',
      };
    }
  }

  fetchMyApplication({
    required String accessToken,
    required int driverId,
  }) async {
    try {
      final url =
          '${webApi['domain']}${endPoint['fetchMyApplication']}/$driverId';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['result'] == 'success') {
        List<MyApplication> fetchedMyApplications = [];

        response['data'].forEach((myApplication) {
          fetchedMyApplications
              .add(MyApplication.jsonToMyApplication(myApplication));
        });
        _myApplications = fetchedMyApplications;
        notifyListeners();
      }
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to get My applications',
      };
    }
  }
}
