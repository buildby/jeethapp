import 'package:flutter/material.dart';
import 'package:jeeth_app/api.dart';
import 'package:jeeth_app/authModule/models/driver_model.dart';
import 'package:jeeth_app/http_helper.dart';

class EarningProvider with ChangeNotifier {
  List<Earnings> _earnings = [];
  List<Earnings> get earnings => [..._earnings];

  fetchEarnings({
    required String accessToken,
    required String phone,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchPastWeekEarning']}';
      Map body = {
        'phone': phone,
      };
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, accessToken: accessToken, body: body);

      if (response['result'] != null) {
        List<Earnings> fetchedEarnings = [];

        fetchedEarnings.add(Earnings.jsonToEarning(response['result']));

        _earnings = fetchedEarnings;
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
