import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  MobileNumberScreenState createState() => MobileNumberScreenState();
}

class MobileNumberScreenState extends State<MobileNumberScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  bool locationLoading = false;

  bool validatePhone = false;
  final _phoneEditingController = TextEditingController();
  TextTheme get textTheme => Theme.of(context).textTheme;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  getOTP() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await Provider.of<AuthProvider>(context, listen: false)
          .sendOTPtoUser(_phoneEditingController.text.toString());
      if (data['result'] != 'success') {
        showSnackbar(
            'Something went wrong, Check internet connection', Colors.red);
      } else {
        if (data['data']['type'] == 'success') {
          push(NamedRoute.verifyOtpScreen,
              arguments: VerifyOtpArguments(
                mobileNo: _phoneEditingController.text.trim(),
              ));
        } else {
          showSnackbar(
              'Something went wrong, Check internet connection', Colors.red);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool get validateNumber {
    setState(() {
      validatePhone = false;
    });
    String pattern = r'([6,7,8,9][0-9]{9})';
    RegExp regExp = RegExp(pattern);
    String amount = _phoneEditingController.text.toString();

    if (amount.length < 10 || amount.isEmpty || !regExp.hasMatch(amount)) {
      setState(() {
        validatePhone = false;
      });
      return false;
    }
    setState(() {
      validatePhone = true;
    });
    return true;
  }

  getOtp() {
    push(NamedRoute.verifyOtpScreen,
        arguments: VerifyOtpArguments(
          mobileNo: _phoneEditingController.text.trim(),
        ));
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
                            height: dW * 0.28,
                            width: dW,
                            color: themeColor,
                            padding: EdgeInsets.only(
                                left: dW * horizontalPaddingFactor,
                                right: dW * 0.01),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: -10,
                                  child: TextWidget(
                                    title: language['get'],
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black.withOpacity(0.06),
                                    fontSize: 119,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: dW * 0.01,
                                  ),
                                  child: TextWidget(
                                    title: language['enterYourMobileNumber'],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 39,
                                    color: white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: dH * 0.6,
                            width: dW,
                            color: white,
                            padding: EdgeInsets.only(
                                left: dW * 0.08, top: dW * 0.045),
                            child: Column(children: [
                              const TextWidget(
                                title:
                                    'We need your phone number to verify your identity',
                                fontSize: 18,
                                color: Color(0xff919191),
                              ),
                              SizedBox(
                                height: dW * 0.04,
                              ),
                              CustomTextFieldWithLabel(
                                borderColor: white,
                                prefixIcon: Container(
                                  margin: EdgeInsets.only(right: dW * 0.15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      TextWidget(
                                        title: '+91',
                                        fontSize: 24,
                                        color: Color(0xff575757),
                                      ),
                                    ],
                                  ),
                                ),
                                border: 4,
                                label: '',
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                                hintText: '',
                                inputFS: 24,
                                letterSpacing: 5,
                                inputType: TextInputType.phone,
                                onChanged: (newValue) {
                                  setState(() {
                                    validateNumber;
                                  });
                                },
                                controller: _phoneEditingController,
                                maxLength: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: dW * 0.1),
                                child: const Divider(
                                  thickness: 4,
                                  color: Color(0xffD8D8D8),
                                ),
                              )
                            ]),
                          )
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
                      isLoading: isLoading,
                      radius: 19,
                      elevation: 12,
                      onPressed: validateNumber ? getOTP : () {},
                      buttonColor: validateNumber ? buttonColor : Colors.grey,
                      buttonText: language['getOtp'],
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
