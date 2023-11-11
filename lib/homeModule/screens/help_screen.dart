import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/homeModule/widgets/custom_container.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../authModule/models/user_model.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  late User user;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      backgroundColor: themeColor,
      // appBar: CustomAppBar(
      //   title: language['help'],
      //   dW: dW,
      //   leading: Container(
      //     padding: EdgeInsets.all(dW * 0.035),
      //     child: const AssetSvgIcon(
      //       'drawer',
      //       height: 5,
      //     ),
      //   ),
      //   actions: [
      //     Container(
      //         margin: EdgeInsets.only(right: dW * 0.03),
      //         child: const Icon(Icons.notifications))
      //   ],
      // ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return isLoading
        ? const Center(child: CircularLoader())
        : Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: dW * 0.32,
                      color: themeColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: dW * 0.04,
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -2,
                                left: 30,
                                right: 30,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: dW * 0.07,
                                  ),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: dW * 0.2,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.06, vertical: dW * 0.05),
                                margin: EdgeInsets.only(top: dW * 0.1),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                      offset: const Offset(0, -5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: dW * 0.032),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: themeColor),
                                            child: const AssetSvgIcon(
                                              'help',
                                              color: white,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      width: dW * 0.04,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: dW * 0.01,
                                        ),
                                        TextWidget(
                                          title:
                                              language['contactVendorHelpline'],
                                          color: const Color(0xff242E42),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                        SizedBox(
                                          height: dW * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (user.driver.vendor != null) {
                                              launchCall(
                                                  user.driver.vendor!.phone);
                                            }
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: TextWidget(
                                              title: language['tapToCall'],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: user.driver.vendor != null
                                                  ? themeColor
                                                  : grayColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: dW * 0.03, bottom: dW * 0.05),
                            padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.04, vertical: dW * 0.05),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0, -5))
                              ],
                            ),
                            child: Column(
                              children: [
                                CustomContainer(
                                    name: language['reportAnIssue']),
                                SizedBox(
                                  height: dW * 0.03,
                                ),
                                CustomContainer(
                                    name: language['AccountProfile']),
                                SizedBox(
                                  height: dW * 0.03,
                                ),
                                CustomContainer(
                                    name: language['paymentsAndWithdrawals']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: dW * 0.1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.02, vertical: dW * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xffBFBFBF),
                            ),
                            child: const AssetSvgIcon(
                              'exclaimation',
                              height: 10,
                            ),
                          ),
                          TextWidget(
                            textAlign: TextAlign.center,
                            title: language['callAndReport'],
                            letterSpacing: 0.41,
                            height: 1.1,
                            fontSize: 17,
                            color: const Color(0xff242E42),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
