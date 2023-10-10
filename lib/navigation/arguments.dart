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
