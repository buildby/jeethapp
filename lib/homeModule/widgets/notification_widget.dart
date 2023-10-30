// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:provider/provider.dart';

class NotificationWidget extends StatelessWidget {
  String title;
  String subTitle;
  String icon;
  NotificationWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      padding: EdgeInsets.only(
          left: dW * 0.04, right: dW * 0.05, top: dW * 0.05, bottom: dW * 0.05),
      color: white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: dW * 0.03, vertical: dW * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xffF1F1F1),
            ),
            child: AssetSvgIcon(
              icon,
            ),
          ),
          SizedBox(
            width: dW * 0.04,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgetPoppins(
                  title: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xff242E42),
                ),
                SizedBox(
                  height: dW * 0.02,
                ),
                TextWidgetPoppins(
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  title: subTitle,
                  color: const Color(0xff242E42),
                  letterSpacing: 0.41,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
