import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/screens/marketplace_screen.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyOtpScreen extends StatefulWidget {
  final VerifyOtpArguments args;

  const VerifyOtpScreen({Key? key, required this.args}) : super(key: key);

  @override
  VerifyOtpScreenState createState() => VerifyOtpScreenState();
}

class VerifyOtpScreenState extends State<VerifyOtpScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  bool validateotp = false;
  // String otp = '1234';
  TextTheme get textTheme => Theme.of(context).textTheme;
  final _otpEditingController = TextEditingController();

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  String? validateOtp(String value) {
    if (value.isEmpty) {
      validateotp = false;
      // return 'Please enter OTP';
      return null;
    } else if (value.length < 4) {
      validateotp = false;
      // return showSnackbar('Please enter valid OTP');
      // return 'Please enter valid OTP';
      return null;
    }
    // else if (value != 4) {
    //   validateotp = false;
    //   // return showSnackbar('Please enter valid OTP');
    //   // return 'Please enter valid OTP';
    //   return null;
    // }
    validateotp = true;
    return null;
  }

  // Future<void> verifyOTP() async {
  //   final value = _otpEditingController.text;
  //   if (value != otp) {
  //     return showSnackbar('Please enter valid OTP');
  //   }
  // }

  // Future<void> verifyOTP() async {
  //   final data = await Provider.of<AuthProvider>(context, listen: false)
  //       .verifyOTPofUser(
  //           widget.args.mobileNo.toString(), _otpEditingController.text);
  //   if (data == 'success') {
  //     final response = await Provider.of<AuthProvider>(context, listen: false)
  //         .login(query: '?phone=${widget.args.mobileNo}');
  //     if (response['success'] && response['login']) {
  //       pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
  //           arguments: BottomNavArgumnets());
  //     } else if (!response['success']) {
  //       showSnackbar(language['somethingWentWrong']);
  //     } else if (!response['login']) {
  //       pushAndRemoveUntil(
  //         NamedRoute.registerUserScreen,
  //         arguments: RegistrationArguments(
  //           mobileNo: widget.args.mobileNo,
  //         ),
  //       );
  //     }
  //     //
  //   } else {
  //     showSnackbar('Incorrect OTP', Colors.red);
  //     setState(() {
  //       inCorrect = true;
  //     });
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // user = Provider.of<AuthProvider>(context, listen: false).user;
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: CustomAppBar(title: '', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : Container(
              color: white,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: dW * horizontalPaddingFactor,
                                right: dW * 0.01),
                            height: dW * 0.28,
                            width: dW,
                            color: themeColor,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: -10,
                                  child: TextWidget(
                                    title: language['set'],
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black.withOpacity(0.06),
                                    fontSize: 119,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      title: language['phoneVerification'],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 39,
                                      color: white,
                                    ),
                                    SizedBox(
                                      height: dW * 0.03,
                                    ),
                                    TextWidget(
                                      title: language['enterOtpHere'],
                                      fontSize: 17,
                                      color: white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: dW * 0.2,
                          ),
                          PinCodeTextField(
                            appContext: context,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            ],
                            length: 4,
                            onChanged: (value) {
                              setState(() {
                                validateotp = validateOtp(value) != null;
                              });
                            },
                            controller: _otpEditingController,
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.black,
                            validator: (v) => validateOtp(v!),
                            textStyle: const TextStyle(
                                fontSize: 36,
                                fontFamily: 'Blinker',
                                fontWeight: FontWeight.w400),
                            pinTheme: PinTheme(
                                fieldHeight: 80,
                                borderWidth: 5,
                                shape: PinCodeFieldShape.underline,
                                activeColor: const Color(0xffD8D8D8),
                                inactiveColor: const Color(0xffD8D8D8),
                                selectedFillColor: const Color(0xffBFC0C8),
                                disabledColor: const Color(0xffBFC0C8),
                                selectedColor: themeColor),
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: dW * 0.15, vertical: dW * 0.1),
                    child: CustomButton(
                      width: dW,
                      height: dW * 0.145,
                      radius: 19,
                      elevation: 12,
                      onPressed: validateotp
                          ? () => push(NamedRoute.marketPlaceScreen)
                          : () {},
                      // onPressed: validateotp ? verifyOTP : () {},
                      buttonColor: validateotp ? buttonColor : Colors.grey,
                      buttonText: language['proceed'],
                      buttonTextSyle: const TextStyle(
                          fontFamily: 'Blinker',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
