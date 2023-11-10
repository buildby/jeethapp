// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/homeModule/models/my_application_model.dart';
import 'package:provider/provider.dart';

class MyApplicationContainer extends StatelessWidget {
  final MyApplication application;
  String date;

  MyApplicationContainer({
    required this.application,
    required this.date,
    super.key,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidgetPoppins(
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      title: application.campaignName,
                      color: const Color(0xff242E42),
                      letterSpacing: 0.41,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: dW * 0.18,
              ),
              TextWidgetPoppins(
                title: date.toString(),
                fontWeight: FontWeight.w400,
                fontSize: 12,
                letterSpacing: 0.41,
              ),
            ],
          ),
          SizedBox(
            height: dW * 0.02,
          ),
          TextWidgetPoppins(
            title: application.status,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.41,
            fontSize: 14,
            color:
                application.status == 'PENDING' || application.status == 'HOLD'
                    ? const Color(0xffDFA716)
                    : application.status == 'REJECTED'
                        ? const Color(0xffFF0000)
                        : const Color(0xff049A49),
          ),
        ],
      ),
    );
  }
}
