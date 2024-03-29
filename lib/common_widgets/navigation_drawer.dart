import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/cached_image_widget.dart';
import 'package:jeeth_app/common_widgets/custom_dialog.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget2.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../colors.dart';
import '../../navigation/routes.dart';
import '../authModule/models/user_model.dart';
import '../navigation/arguments.dart';

class MyNavigationDrawer extends StatefulWidget {
  final Function(int) onIndexChanged;

  const MyNavigationDrawer({super.key, required this.onIndexChanged});

  @override
  State<MyNavigationDrawer> createState() => MyNavigationDrawerState();
}

class MyNavigationDrawerState extends State<MyNavigationDrawer> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  late User user;
  bool isLoading = false;

  fetchData() async {}

  logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    pushAndRemoveUntil(NamedRoute.mobileNumberScreen);
  }

  Widget buildOptionWidget(
      {required BuildContext context,
      required String text,
      required String iconName,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.only(right: dW * .05, top: dW * .04, bottom: dW * .04),
        decoration: BoxDecoration(
            // color: themeColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: dW * 0.08,
              child: AssetSvgIcon(
                iconName,
                // color: grayColor,
              ),
            ),
            SizedBox(
              width: dW * 0.035,
            ),
            Expanded(
              child: TextWidgetPoppins(
                title: text,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    customTextTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Drawer(
        backgroundColor: themeColor,
        width: dW * 0.8,
        child: Container(
          height: dH,
          child: Column(
            children: [
              // SizedBox(
              //   height: dW * 0.07,
              // ),
              Stack(
                children: [
                  const AssetSvgIcon('drawer_bg'),
                  Padding(
                    padding: EdgeInsets.only(
                        top: dW * .07,
                        right: dW * .05,
                        // bottom: dW * .05,
                        left: dW * 0.02),
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          margin: EdgeInsets.only(
                            right: dW * 0.02,
                            // top: dW * 0.07
                          ),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: user.driver.avatar.isEmpty
                              ? Image.asset(
                                  'assets/images/avatar.png',
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedImageWidget(
                                          user.driver.avatar,
                                          height: 32,
                                          width: 32)),
                                ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: dW * 0.04),
                            TextWidgetPoppins(
                              title: user.driver.name,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: white,
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.onIndexChanged(1);
                                pop();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: dW * 0.03),
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.03, vertical: dW * 0.02),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: white),
                                child: Row(
                                  children: [
                                    TextWidget(
                                      title: language['wallet'],
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: dW * 0.01, left: dW * 0.03),
                                      child: TextWidgetPoppins(
                                        title:
                                            '\u20b9 ${user.driver.earnings.accrued}',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                        color: themeColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: dW * 0.005,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
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
              // SizedBox(height: dW * .05),
              Expanded(
                child: Container(
                  color: white,
                  padding: EdgeInsets.only(
                    right: dW * .05,
                    top: dW * .05,
                    bottom: dW * .05,
                    left: dW * 0.07,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildOptionWidget(
                          context: context,
                          iconName: 'my_profile',
                          text: language['myProfile'],
                          onTap: () => push(NamedRoute.profileDocumentsScreen),
                        ),
                        buildOptionWidget(
                          context: context,
                          iconName: 'my_applications',
                          text: language['myApplications'],
                          onTap: () => push(NamedRoute.myApplicationsScreen),
                        ),
                        // buildOptionWidget(
                        //   context: context,
                        //   iconName: 'notifications',
                        //   text: language['notifications'],
                        //   onTap: () => push(NamedRoute.notificationsScreen),
                        // ),
                        // buildOptionWidget(
                        //   context: context,
                        //   iconName: 'refer_friend',
                        //   text: language['referAFriend'],
                        //   onTap: () => push(NamedRoute.referAFriendScreen),
                        // ),
                        // buildOptionWidget(
                        //   context: context,
                        //   iconName: 'settings',
                        //   text: language['appSettings'],
                        //   onTap: () => push(NamedRoute.settingsScreen),
                        // ),
                        buildOptionWidget(
                          context: context,
                          iconName: 'logout',
                          text: language['logout'],
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              title: language['logout'],
                              subTitle: language['wantToLogout'],
                              noText: language['no'],
                              yesText: language['yes'],
                              noFunction: () {
                                pop();
                              },
                              yesFunction: () {
                                logout();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: dW * 0.03,
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffDCDCDC),
                        ),
                        SizedBox(
                          height: dW * 0.06,
                        ),
                        // const TextWidgetPoppins(
                        //   title: 'FAQ’s',
                        //   color: Color(0xff757575),
                        //   fontWeight: FontWeight.w400,
                        // ),
                        // SizedBox(
                        //   height: dW * 0.06,
                        // ),
                        GestureDetector(
                          onTap: () => push(NamedRoute.webviewScreen,
                              arguments: WebviewScreenArguments(
                                title: 'Terms & Conditions',
                                link: 'https://staging.jeeth.co.in/terms',
                              )),
                          child: const TextWidgetPoppins(
                            title: 'Terms & Conditions',
                            color: Color(0xff757575),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: dW * 0.06,
                        ),
                        GestureDetector(
                          onTap: () => push(NamedRoute.webviewScreen,
                              arguments: WebviewScreenArguments(
                                title: 'Privacy Policy',
                                link:
                                    'https://staging.jeeth.co.in/privacy-policy',
                              )),
                          child: const TextWidgetPoppins(
                            title: 'Privacy Policy',
                            color: Color(0xff757575),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: dW * 0.06,
                        ),
                        // const TextWidgetPoppins(
                        //   title: 'Payment Policy',
                        //   color: Color(0xff757575),
                        //   fontWeight: FontWeight.w400,
                        // ),
                        SizedBox(
                          height: dW * 0.06,
                        ),
                        // const TextWidgetPoppins(
                        //   title: 'Revenue Policy',
                        //   color: Color(0xff757575),
                        //   fontWeight: FontWeight.w400,
                        // ),
                        SizedBox(
                          height: dW * 0.06,
                        ),
                        // const TextWidgetPoppins(
                        //   title: 'Grievances',
                        //   color: Color(0xff757575),
                        //   fontWeight: FontWeight.w400,
                        // ),
                        SizedBox(
                          height: dW * 0.06,
                        ),
                        // const Spacer(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
