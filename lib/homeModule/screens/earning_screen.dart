import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/homeModule/widgets/custom_container.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget2.dart';
import 'package:provider/provider.dart';

import '../../authModule/models/user_model.dart';
import '../../common_widgets/cached_image_widget.dart';

class EarningsScreen extends StatefulWidget {
  final Function(int)? onIndexChanged;

  const EarningsScreen({Key? key, this.onIndexChanged}) : super(key: key);

  @override
  EarningsScreenState createState() => EarningsScreenState();
}

class EarningsScreenState extends State<EarningsScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';

          switch (value.toInt()) {
            case 0:
              text = 'Mon';
              break;
            case 1:
              text = 'Tue';
              break;
            case 2:
              text = 'Wed';
              break;
            case 3:
              text = 'Thu';
              break;
            case 4:
              text = 'Fri';
              break;
            case 5:
              text = 'Sat';
              break;
            case 6:
              text = 'Sun';
              break;
          }

          return Text(text);
        },
      );

  List<BarChartGroupData> barChartData = [
    BarChartGroupData(
      x: 0,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          // y: 500,
          width: 25,
          // borderRadius: BorderRadius.circular(8),
          color: themeColor, toY: 500,
        ),
      ],
    ),
    BarChartGroupData(
      x: 1,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: 1000,
          width: 25,
          color: themeColor,
        ),
      ],
    ),
    BarChartGroupData(
      x: 2,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: 1500,
          width: 25,
          color: themeColor,
        ),
      ],
    ),
    BarChartGroupData(
      x: 3,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: 2000,
          width: 25,
          color: themeColor,
        ),
      ],
    ),
    BarChartGroupData(
      x: 4,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: 2500,
          width: 25,
          color: themeColor,
        ),
      ],
    ),
    BarChartGroupData(
      x: 5,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: 3000,
          width: 25,
          color: themeColor,
        ),
      ],
    ),
    BarChartGroupData(
      x: 6,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: 2000,
          width: 25,
          color: themeColor,
        ),
      ],
    ),
  ];

  num get withrawableAmount => (80 / 100) * user.driver.earnings.accrued;

  refreshUserEarnings() async {
    setState(() => isLoading = true);
    final response = await Provider.of<AuthProvider>(context, listen: false)
        .refreshUserEarnings(driverId: user.driver.id.toString());

    if (response['result'] != 'success') {
      refreshUserEarnings();
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    refreshUserEarnings();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: themeColor,
      // appBar: CustomAppBar(
      //   title: language['earnings'],
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
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : Stack(
              //  clipBehavior: Clip.none,
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
                Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: dH - (dH * 0.25),
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        Row(
                                          children: [
                                            TextWidget(
                                              title:
                                                  language['accruedEarnings'],
                                              color: const Color(0xff242E42),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: dW * 0.01),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: dW * 0.012,
                                                  vertical: dW * 0.005),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color:
                                                      const Color(0xffCFCFCF)),
                                              child: const TextWidget(
                                                title: '!',
                                                color: white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: dW * 0.025,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const AssetSvgIcon(
                                              'coin',
                                            ),
                                            SizedBox(width: dW * 0.015),
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return const LinearGradient(
                                                  colors: [
                                                    Color(0xFFDD992B),
                                                    Color(0xFFFFC850),
                                                    Color(0xFFDD992B),
                                                  ],
                                                  stops: [0.0, 0.5, 1.0],
                                                ).createShader(bounds);
                                              },
                                              child: TextWidgetRoboto(
                                                title: convertAmountString(user
                                                    .driver.earnings.accrued
                                                    .toDouble()),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: white,
                                              ),
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
                            width: dW,
                            margin: EdgeInsets.only(
                                top: dW * 0.03, bottom: dW * 0.03),
                            padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.04, vertical: dW * 0.05),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: const Offset(0, -5))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomContainer(
                                  name: language['currentMonthEarnings'],
                                  widgets: Row(
                                    children: [
                                      TextWidgetRoboto(
                                        title:
                                            'Rs. ${convertAmountString(user.driver.earnings.currentMonth.toDouble())}',
                                        color: const Color(0xff78B84C),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: dW * 0.025,
                                ),
                                CustomContainer(
                                  name: language['eligibleToWithdraw'],
                                  widgets: Row(
                                    children: [
                                      TextWidgetRoboto(
                                        title:
                                            'Rs. ${convertAmountString(withrawableAmount.toDouble())}',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: dW,
                            padding: EdgeInsets.symmetric(vertical: dW * 0.02),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: const Offset(0, -5))
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: dW * 0.01,
                                ),
                                TextWidgetRoboto(
                                  title: language['earningsLastWeek'],
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                                Container(
                                  height: dW * 0.51,
                                  margin: EdgeInsets.only(top: dW * 0.02),
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,

                                      maxY: 3000,
                                      // groupsSpace: 5,
                                      borderData: FlBorderData(
                                        show: true,
                                        border: const Border(
                                            left: BorderSide(
                                              width: 1,
                                              color: Color(0xffC8C8C8),
                                            ),
                                            bottom: BorderSide(
                                              width: 1,
                                              color: Color(0xffC8C8C8),
                                            )),
                                      ),
                                      gridData: FlGridData(
                                        show: false,
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(
                                          // axisNameSize: 10,
                                          sideTitles: _bottomTitles,
                                        ),

                                        // leftTitles: AxisTitles(
                                        //   drawBelowEverything: true,
                                        //   axisNameSize: 16,
                                        // ),
                                      ),
                                      barGroups: barChartData.map((data) {
                                        return data.copyWith(
                                          barRods: data.barRods
                                              .map((rod) => rod.copyWith(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ))
                                              .toList(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: dW * 0.12,
                                right: dW * 0.12,
                                bottom: dW * 0.1,
                                top: dW * 0.05),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.15),
                                    blurRadius: 30,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 26))
                              ],
                            ),
                            child: CustomButton(
                              width: dW,
                              height: dW * 0.15,
                              elevation: 9,
                              radius: 21,
                              buttonText: language['withdrawAmount'],
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
