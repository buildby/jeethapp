import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/model/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  // late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
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
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : SingleChildScrollView(
              padding: screenHorizontalPadding(dW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: dW * 0.1,
                  ),
                  Image.asset(
                    'assets/images/onBoarding.png',
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: dW * 0.14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          title: language['onRide'],
                          color: white,
                          fontSize: 66,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: dW * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: dW * 0.02),
                          child: TextWidget(
                            title: language['areYouIn'],
                            color: white,
                            fontSize: 27,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: dW * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: dW * 0.14, right: dW * 0.1),
                    child: CustomButton(
                        width: dW,
                        height: dW * 0.125,
                        radius: 21,
                        buttonColor: white,
                        onPressed: () => push(NamedRoute.mobileNumberScreen),
                        elevation: 10,
                        buttonTextSyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                        buttonText: language['getStarted']),
                  )
                ],
              ),
            ),
    );
  }
}
