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

import '../models/document_model.dart';
import '../models/driver_model.dart';

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
  bool inCorrect = false;

  // String otp = '1234';
  TextTheme get textTheme => Theme.of(context).textTheme;
  final _otpEditingController = TextEditingController();

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  bool validateOtp(String value) {
    if (value.isEmpty) {
      // return 'Please enter OTP';
      return false;
    } else if (value.length < 4) {
      // return showSnackbar('Please enter valid OTP');
      // return 'Please enter valid OTP';
      return false;
    }
    // else if (value != 4) {
    //   validateotp = false;
    //   // return showSnackbar('Please enter valid OTP');
    //   // return 'Please enter valid OTP';
    //   return null;
    // }

    return true;
  }

  anyDriverDocExists(List<Doc> docs) {
    for (var i = 0; i < docs.length; i++) {
      if (docs[i].filename == 'Owner Aadhar Card') {
        return true;
      }
      if (docs[i].filename == 'Owner Lease Agreement') {
        return true;
      }
    }
    return false;
  }

  Future<bool> isProfileComplete(List driverDocs) async {
    final docs = driverDocs.map((d) => Doc.jsonToDoc(d)).toList();

    final Driver profile =
        Provider.of<AuthProvider>(context, listen: false).user.driver;

    if (
        // profile.avatar == '' ||
        //   profile.name == '' ||
        //   profile.email == '' ||
        //   profile.dob == null ||
        //   profile.address == '' ||
        //   profile.gender == '' ||
        //   profile.ifscCode == '' ||
        //   profile.bankName == '' ||
        //   profile.accNumber == '' ||
        // profile.vehicle.vehicleMake == '' ||
        // profile.vehicle.vehicleModel == '' ||
        // profile.vehicle.vehicleType == '' ||
        // profile.vehicle.vehicleYear == '' ||
        profile.vehicle.vehicleNumber == '' || profile.vehicleImage == '') {
      return false;
    } else {
      int selectedDocumentCount = 0;

      for (var i = 0; i < docs.length; i++) {
        if (docs[i].filename == 'Vehicle RC') {
          selectedDocumentCount++;
        }
        if (docs[i].filename == 'Vehicle Fitness') {
          selectedDocumentCount++;
        }
        if (docs[i].filename == 'Vehicle Permit') {
          selectedDocumentCount++;
        }
        if (docs[i].filename == 'Vehicle Insurance') {
          selectedDocumentCount++;
        }
        if (docs[i].filename == 'Vehicle PUC') {
          selectedDocumentCount++;
        }
      }

      if (selectedDocumentCount < 5) {
        return false;
      } else if (profile.ownerName != '' ||
          profile.ownerAddress != '' ||
          profile.ownerPhoneNumber != '' ||
          anyDriverDocExists(docs)) {
        if (profile.ownerName == '' ||
            profile.ownerAddress == '' ||
            profile.ownerPhoneNumber == '') {
          return false;
        }

        int selectedOwnerDocumentCount = 0;
        for (var i = 0; i < docs.length; i++) {
          if (docs[i].filename == 'Owner Aadhar Card') {
            selectedOwnerDocumentCount++;
          }
          if (docs[i].filename == 'Owner Lease Agreement') {
            selectedOwnerDocumentCount++;
          }
        }

        if (selectedOwnerDocumentCount < 2) {
          return false;
        }
      }
    }

    return true;
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
      inCorrect = false;
    });
    final response = await Provider.of<AuthProvider>(context, listen: false)
        .verifyOTPofUser(
            widget.args.mobileNo.toString(), _otpEditingController.text);

    if (response['result'] == 'success' && response['data'] != null) {
      if (await isProfileComplete(response['data']['driverDocs'])) {
        Future.delayed(
            const Duration(seconds: 2),
            () => pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
                arguments: BottomNavArguments()));
      } else {
        Future.delayed(const Duration(seconds: 2),
            () => pushAndRemoveUntil(NamedRoute.marketPlaceScreen));
      }
    } else if (response['result'] == 'failure') {
      if (response['message'] != null) {
        showSnackbar(response['message']);
      } else {
        showSnackbar('Incorrect Otp', redColor);
        setState(() {
          inCorrect = true;
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    // if (data == 'success') {
    //   final response = await Provider.of<AuthProvider>(context, listen: false)
    //       .login(query: '?phone=${widget.args.mobileNo}');
    //   if (response['success'] && response['login']) {
    //     pushAndRemoveUntil(
    //       NamedRoute.profileDocumentsScreen,
    //     );
    //   } else if (!response['success']) {
    //     showSnackbar(language['somethingWentWrong']);
    //   } else if (!response['login']) {
    //     pushAndRemoveUntil(
    //       NamedRoute.marketPlaceScreen,
    //       arguments: MarketPlaceScreenArguments(
    //         mobileNo: widget.args.mobileNo,
    //       ),
    //     );
    //   }
  }

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
      child: Container(
        color: white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: dW * horizontalPaddingFactor, right: dW * 0.01),
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
                          SingleChildScrollView(
                            child: Column(
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
                          validateotp = validateOtp(value);
                        });
                        print('');
                      },
                      controller: _otpEditingController,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.black,
                      // validator: (v) => validateOtp(v!),
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
                isLoading: isLoading,
                onPressed: validateotp
                    ? verifyOTP
                    // () => pushAndRemoveUntil(NamedRoute.marketPlaceScreen)
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
