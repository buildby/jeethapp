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
import '../../common_widgets/cached_image_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  ReportsScreenState createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen>
    with TickerProviderStateMixin {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
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
      //   title: language['reports'],
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
              SizedBox(
                height: dW * 0.04,
              ),
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
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: user.driver.avatar.isEmpty
                                              ? Image.asset(
                                                  'assets/images/profile.jpeg',
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CachedImageWidget(
                                                          user.driver.avatar,
                                                          height: 32,
                                                          width: 32)),
                                                ),
                                        ),
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
                                              language['yourWeeklyPerformance'],
                                          color: const Color(0xff242E42),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        SizedBox(
                                          height: dW * 0.025,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const TextWidget(
                                              title: 'OTA : ',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            ),
                                            const TextWidget(
                                              // title: '81${'%'}',
                                              title: ' --',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffEAC02A),
                                              fontSize: 18,
                                            ),
                                            SizedBox(
                                              width: dW * 0.04,
                                            ),
                                            const TextWidget(
                                              title: 'OTD : ',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            ),
                                            const TextWidget(
                                              // title: '91${'%'}',
                                              title: ' --',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff78B84C),
                                              fontSize: 18,
                                            ),
                                          ],
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
                                GestureDetector(
                                  onTap: () =>
                                      showSnackbar('Coming soon!!', themeColor),
                                  child: CustomContainer(
                                    name: language['MISReport'],
                                    axisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
                                SizedBox(
                                  height: dW * 0.03,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      showSnackbar('Coming soon!!', themeColor),
                                  child: CustomContainer(
                                    name: language['performanceReport'],
                                    axisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
                                SizedBox(
                                  height: dW * 0.03,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      showSnackbar('Coming soon!!', themeColor),
                                  child: CustomContainer(
                                    name: language['earningsReport'],
                                    axisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
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
                                color: const Color(0xffBFBFBF)),
                            child: const AssetSvgIcon(
                              'exclaimation',
                              height: 10,
                            ),
                          ),
                          TextWidget(
                            textAlign: TextAlign.center,
                            title: language['maintainOta/Otd'],
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
