import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class ReferAFriendScreen extends StatefulWidget {
  const ReferAFriendScreen({Key? key}) : super(key: key);

  @override
  ReferAFriendScreenState createState() => ReferAFriendScreenState();
}

class ReferAFriendScreenState extends State<ReferAFriendScreen> {
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
      // appBar: CustomAppBar(
      //     title: language['referAFriend'], centerTitle: true, dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : Stack(
              children: [
                AssetSvgIcon(
                  'refer_friend_bg',
                  width: dW,
                ),
                Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: dW * 0.07,
                                top: dW * 0.06,
                                right: dW * 0.12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => pop(),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: white,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidgetPoppins(
                                    textAlign: TextAlign.center,
                                    title: language['referAFriend'],
                                    letterSpacing: 0.46,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 19,
                                    color: white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: dW * 0.22,
                          ),
                          Image.asset('assets/images/refer_friend_reward.png'),
                          SizedBox(
                            height: dW * 0.04,
                          ),
                          TextWidgetPoppins(
                            title: language['referAndEarn'],
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: white,
                            letterSpacing: 0.36,
                          ),
                          SizedBox(
                            height: dW * 0.02,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: dW * 0.06),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Invite your friends to download the ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing: 0.41,
                                      color: Colors
                                          .white, // Color can be customized as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'JEETH',
                                    style: TextStyle(
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      letterSpacing: 0.41,
                                      color: Colors
                                          .white, // Color can be customized as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' mobile app and earn rewards for every referral.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.41,
                                      fontSize: 18,
                                      color: Colors
                                          .white, // Color can be customized as needed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: dW * 0.05, vertical: dW * 0.07),
                      color: white,
                      width: dW,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetPoppins(
                              title: language['shareTheDownloadLink'],
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              letterSpacing: 0.41,
                              color: themeColor,
                            ),
                            SizedBox(
                              height: dW * 0.06,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidgetPoppins(
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        title: 'https://tinyurl.com/bdh499rf',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.41,
                                        color: Color(0xff595959),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: dW * 0.04,
                                ),
                                const AssetSvgIcon(
                                  'share',
                                  height: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: dW * 0.01,
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xff242E42),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
