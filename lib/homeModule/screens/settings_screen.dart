import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/marketplace_provider.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/homeModule/widgets/custom_container.dart';
import 'package:jeeth_app/authModule/widgets/marketplace_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
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
      appBar: CustomAppBar(
        dW: dW,
      ),
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
                color: white.withOpacity(0.96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: dW * 0.18,
                      color: themeColor,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: dW * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: dW * 0.05),
                          child: TextWidgetPoppins(
                            title: language['settings'],
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                        ),
                        Container(
                          width: dW,
                          margin:
                              EdgeInsets.only(top: dW * 0.1, bottom: dW * 0.05),
                          padding: EdgeInsets.only(
                              left: dW * 0.04,
                              top: dW * 0.02,
                              // bottom: dW * 0.02,
                              right: dW * 0.05),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: const Color(0xffEFEFF4)),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/avatar.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: dW * 0.03,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextWidgetPoppins(
                                        title: 'Darshan Tada',
                                        color: Color(0xff242E42),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      SizedBox(
                                        height: dW * 0.02,
                                      ),
                                      TextWidgetPoppins(
                                        title: language['active'],
                                        color: const Color(0xff8A8A8F),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                ),
                                AssetSvgIcon(
                                  'arrow_forward',
                                  color: Colors.black.withOpacity(0.25),
                                  height: 13,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: dW,
                          padding: EdgeInsets.only(
                              left: dW * 0.06,
                              // top: dW * 0.02,
                              // bottom: dW * 0.02,
                              right: dW * 0.05),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: dW * 0.05, bottom: dW * 0.015),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidgetPoppins(
                                        title: language['notifications'],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                      AssetSvgIcon(
                                        'arrow_forward',
                                        color: Colors.black.withOpacity(0.25),
                                        height: 13,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: Color(0xffEFEFF4),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: dW * 0.025, bottom: dW * 0.015),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidgetPoppins(
                                        title: language['security'],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                      AssetSvgIcon(
                                        'arrow_forward',
                                        color: Colors.black.withOpacity(0.25),
                                        height: 13,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: Color(0xffEFEFF4),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: dW * 0.025, bottom: dW * 0.015),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidgetPoppins(
                                        title: language['language'],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                      AssetSvgIcon(
                                        'arrow_forward',
                                        color: Colors.black.withOpacity(0.25),
                                        height: 13,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: Color(0xffEFEFF4),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: dW * 0.025, bottom: dW * 0.04),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidgetPoppins(
                                        title: language['permissions'],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                      AssetSvgIcon(
                                        'arrow_forward',
                                        color: Colors.black.withOpacity(0.25),
                                        height: 13,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(bottom: dW * 0.05),
                      alignment: Alignment.center,
                      width: dW,
                      color: white,
                      padding: EdgeInsets.symmetric(vertical: dW * 0.05),
                      child: TextWidget(
                        title: language['logout'],
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: const Color(0xffC8C7CC),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
