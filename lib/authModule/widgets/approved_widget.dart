import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/cached_image_widget.dart';

class ApprovedWidget extends StatefulWidget {
  final MyApplicationsStatusArguments args;
  const ApprovedWidget({Key? key, required this.args}) : super(key: key);

  @override
  ApprovedStateWidget createState() => ApprovedStateWidget();
}

class ApprovedStateWidget extends State<ApprovedWidget> {
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

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AssetSvgIcon('approved_bg'),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
          child: Container(
            padding: EdgeInsets.only(top: dW * 0.22, bottom: dW * 0.1),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: dW,

                  // height: dH * 0.7,
                  padding: EdgeInsets.only(
                      bottom: dW * 0.055,
                      left: dW * 0.06,
                      right: dW * 0.06,
                      top: dW * 0.055),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: white),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: dW * 0.15,
                            ),
                            TextWidgetPoppins(
                              title: widget.args.myApplication.vendorName,
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                            SizedBox(
                              height: dW * 0.015,
                            ),
                            TextWidgetPoppins(
                              title: widget.args.myApplication.clientSiteName,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff8A8A8F),
                              fontSize: 15,
                            ),
                            SizedBox(
                              height: dW * 0.1,
                            ),
                            TextWidgetPoppins(
                              title: language['inductionPending'],
                              color: themeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: 0.41,
                            ),
                            SizedBox(
                              height: dW * 0.02,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style:
                                    DefaultTextStyle.of(context).style.copyWith(
                                          fontFamily: 'Poppins',
                                          color: const Color(0xff8A8A8F),
                                        ),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: 'Your application has been\n',
                                    style: TextStyle(
                                        letterSpacing: 0.41,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: 'approved',
                                    style: TextStyle(
                                        letterSpacing: 0.41,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                    text:
                                        ' for inspection by vendor you have applied for, Please visit\nthe below site location along with\nall the documents submitted.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 0.41,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: dW,
                              margin: EdgeInsets.only(
                                  top: dW * 0.15, bottom: dW * 0.02),
                              padding: EdgeInsets.only(
                                  left: dW * 0.05,
                                  right: dW * 0.03,
                                  bottom: dW * 0.03,
                                  top: dW * 0.03),
                              decoration: BoxDecoration(
                                color: const Color(0xffEFEFF4).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffEFEFF4),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    const AssetSvgIcon('profile_icon'),
                                    SizedBox(
                                      width: dW * 0.05,
                                    ),
                                    TextWidgetPoppins(
                                      title:
                                          widget.args.myApplication.vendorName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    const TextWidgetPoppins(
                                      title: ' - ',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    TextWidgetPoppins(
                                      title: language['fieldOfficer'],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: dW,
                              padding: EdgeInsets.only(
                                  left: dW * 0.05,
                                  right: dW * 0.03,
                                  bottom: dW * 0.03,
                                  top: dW * 0.03),
                              decoration: BoxDecoration(
                                color: const Color(0xffEFEFF4).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffEFEFF4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone),
                                  SizedBox(
                                    width: dW * 0.06,
                                  ),
                                  // Expanded(
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Wrap(
                                  //         children: [
                                  //           ...widget.args.myApplication
                                  //               .fieldOfficerNumbers
                                  //               .map(
                                  //             (number) => TextWidgetPoppins(
                                  //               title: number ==
                                  //                       widget
                                  //                           .args
                                  //                           .myApplication
                                  //                           .fieldOfficerNumbers
                                  //                           .last
                                  //                   ? number
                                  //                   : '$number,',
                                  //               fontWeight: FontWeight.w600,
                                  //               fontSize: 14,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          children: [
                                            TextWidgetPoppins(
                                              title: widget.args.myApplication
                                                  .vendorPhone,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     boxShadow: [
                        //       BoxShadow(
                        //           color: Colors.black.withOpacity(.15),
                        //           blurRadius: 30,
                        //           spreadRadius: 0,
                        //           offset: const Offset(0, 26))
                        //     ],
                        //   ),
                        //   child: CustomButton(
                        //     width: dW,
                        //     height: dW * 0.12,
                        //     onPressed: () {},
                        //     radius: 10,
                        //     buttonText: '',
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.end,
                        //       children: [
                        //         const AssetSvgIcon('map'),
                        //         SizedBox(
                        //           width: dW * 0.025,
                        //         ),
                        //         TextWidgetPoppins(
                        //           title: language['navigateToLocation'],
                        //           color: white,
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: 14,
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 1.5,
                          color: const Color(0XFF13A088),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedImageWidget(
                          widget.args.myApplication.vendorAvatar,
                          boxFit: BoxFit.cover,
                          width: dW * 0.25,
                          height: dW * 0.25,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
