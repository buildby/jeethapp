import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/marketplace_model.dart';
import '../../api.dart';
import '../../http_helper.dart';

class MarketplaceProvider with ChangeNotifier {
  List<Marketplace> _marketplaces = [];

  List<Marketplace> get marketplaces => [..._marketplaces];

  fetchMarketPlace({
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchAllCampaignsApp']}';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['result'] == 'success') {
        List<Marketplace> marketPlaces = [];

        response['data'].forEach((marketPlace) {
          marketPlaces.add(Marketplace.jsonToMarketplace(marketPlace));
        });
        _marketplaces = marketPlaces;

        notifyListeners();
      }
      return response;
    } catch (e) {
      return {
        'result': 'error',
        'message': 'Failed to get Market place',
      };
    }
  }

  //   String _bankName = '';

  // String get bankName => _bankName;

  // getBankName({required String ifsc}) async {
  //   try {
  //     final url = 'https://ifsc.razorpay.com/$ifsc';
  //     final response =
  //         await RemoteServices.httpRequest(method: 'GET', url: url);

  //     if (response['result'] == 'success') {
  //       _bankName = response['BANK'];
  //       notifyListeners();
  //     }
  //     return response;
  //   } catch (e) {
  //     return 'Not Found';
  //   }
  // }

  getBankName({required String ifsc}) async {
    try {
      final url = 'https://ifsc.razorpay.com/$ifsc';
      final response =
          await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['result'] == 'success') {}
      return response;
    } catch (e) {
      return 'Not Found';
    }
  }
}
