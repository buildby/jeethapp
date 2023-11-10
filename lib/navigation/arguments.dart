import 'package:jeeth_app/authModule/models/marketplace_model.dart';
import 'package:jeeth_app/homeModule/models/my_application_model.dart';

class BottomNavArguments {
  final int index;
  BottomNavArguments({this.index = 0});
}

class SelectLanguageScreenArguments {
  final bool fromOnboarding;
  const SelectLanguageScreenArguments({this.fromOnboarding = false});
}

class VerifyOtpArguments {
  final String mobileNo;
  VerifyOtpArguments({
    required this.mobileNo,
  });
}

class MarketPlaceScreenArguments {
  final String mobileNo;
  MarketPlaceScreenArguments({required this.mobileNo});
}

class ExploreDealScreenArguments {
  final Marketplace marketplace;
  ExploreDealScreenArguments({required this.marketplace});
}

class MyApplicationsStatusArguments {
  final String vendorName;
  final MyApplication myApplication;
  // final String status;
  MyApplicationsStatusArguments(
      {required this.myApplication, required this.vendorName});
}

class WebviewScreenArguments {
  final String link;
  final String title;
  // final String status;
  WebviewScreenArguments({required this.link, required this.title});
}
