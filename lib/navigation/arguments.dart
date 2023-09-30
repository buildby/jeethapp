class BottomNavArgumnets {
  final int index;
  BottomNavArgumnets({this.index = 0});
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
