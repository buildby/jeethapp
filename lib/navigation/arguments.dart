import 'package:jeeth_app/authModule/models/marketplace_model.dart';

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
