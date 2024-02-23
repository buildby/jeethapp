import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeeth_app/authModule/models/driver_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/homeModule/providers/earning_provider.dart';
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
  late List<Earnings> earningsProvider;

  DateTime parseDate(String dateString) {
    List<String> dateParts = dateString.split('/');
    if (dateParts.length == 3) {
      int month = int.tryParse(dateParts[0]) ?? 1;
      int day = int.tryParse(dateParts[1]) ?? 1;
      int year = int.tryParse(dateParts[2]) ?? 2000;

      return DateTime(year, month, day);
    } else {
      throw FormatException("Invalid date format: $dateString");
    }
  }

  SideTitles _bottomTitles2(List<String> dateStrings) {
    // Sort dateStrings in ascending order (oldest to newest)
    dateStrings.sort((a, b) => parseDate(a).compareTo(parseDate(b)));

    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        int index = value.toInt();
        if (index >= 0 && index < dateStrings.length) {
          String dateString = dateStrings[index];
          DateTime date = parseDate(dateString);
          return TextWidget(
            title: DateFormat('EEE').format(date),
            fontSize: 13,
          );
        } else {
          return const TextWidget(
            title: '',
            fontSize: 13,
          );
        }
      },
    );
  }

  double parseEarning(String earning) {
    String numericPart = earning.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numericPart) ?? 0.0;
  }

  List<BarChartGroupData> generateBarChartData(
      {required List<Earnings> earnings}) {
    earnings.first.earning!
        .sort((a, b) => parseDate(a['date']).compareTo(parseDate(b['date'])));

    return List.generate(earnings.first.earning!.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 1,
        barRods: [
          BarChartRodData(
            toY: parseEarning(
                earnings.first.earning![index]['earning'].toString()),
            width: 25,
            color: themeColor,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }

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

  double calculateMaxY(List<dynamic>? earnings) {
    if (earnings == null || earnings.isEmpty) {
      // Handle the case when earnings is null or empty
      return 0.0;
    }

    // Extract earning values from the list
    List<double> earningValues = earnings.map((entry) {
      String earningString = entry['earning'].toString();
      return double.tryParse(
              earningString.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0.0;
    }).toList();

    // Find the maximum earning value
    double maxEarning = earningValues.isNotEmpty
        ? earningValues.reduce((a, b) => a > b ? a : b)
        : 0.0;

    // Calculate the next multiple of 500 greater than maxEarning
    double maxY = ((maxEarning ~/ 500) + 1) * 500.0;

    return maxY;
  }

  fetchEarnings() async {
    setState(() => isLoading = true);

    final response = await Provider.of<EarningProvider>(context, listen: false)
        .fetchEarnings(accessToken: user.accessToken, phone: user.phone);
    if (response['result'] != null) {}
    setState(() => isLoading = false);
  }

  myInit() async {
    setState(() {
      isLoading = true;
    });
    await fetchEarnings();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    earningsProvider =
        Provider.of<EarningProvider>(context, listen: false).earnings;
    user = Provider.of<AuthProvider>(context, listen: false).user;
    refreshUserEarnings();
    myInit();
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
    // print(earnings[1].etd);
    final earning =
        Provider.of<EarningProvider>(context, listen: false).earnings;

    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(
              child: CircularLoader(
              color: white,
            ))
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
                    height: dH - (dH * 0.23),
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
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
                                border:
                                    Border.all(width: 0.1, color: themeColor),
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
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: const Color(
                                                              0XFF13A088))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: CachedImageWidget(
                                                      user.driver.avatar,
                                                      boxFit: BoxFit.cover,
                                                      width: dW * 0.2,
                                                      height: dW * 0.2,
                                                    ),
                                                  ),
                                                ),
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
                                                language['availableEarnedWage'],
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
                                                color: const Color(0xffCFCFCF)),
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
                                            child: earning.isEmpty
                                                ? const TextWidgetRoboto(
                                                    title: '0',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: white,
                                                  )
                                                : TextWidgetRoboto(
                                                    title: (earning.first
                                                            .currentMonthEarning!)
                                                        .toString(),
                                                    // user.driver.earnings
                                                    //     .availableEarnings
                                                    //     .toString(),
                                                    // convertAmountString(user
                                                    //     .driver.earnings.accrued
                                                    //     .toDouble()),
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
                        // SizedBox(
                        //   height: dW * 0.01,
                        // ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  width: dW,
                                  margin: EdgeInsets.only(
                                      top: dW * 0.03, bottom: dW * 0.03),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: dW * 0.04,
                                      vertical: dW * 0.05),
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 0.1, color: themeColor)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomContainer(
                                        onTap: () => showSnackbar(
                                            'Coming soon!!', themeColor),
                                        name: language['currentMonthEarnings'],
                                        widgets: Row(
                                          children: [
                                            earning.isEmpty
                                                ? const TextWidgetRoboto(
                                                    title: 'Rs. 0',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff78B84C),
                                                    fontSize: 16,
                                                  )
                                                : TextWidgetRoboto(
                                                    title:
                                                        'Rs. ${earning.first.currentMonthEarning}',

                                                    // 'Rs. ${convertAmountString(withrawableAmount.toDouble())}',
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        const Color(0xff78B84C),
                                                    fontSize: 16,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: dW * 0.025,
                                      ),
                                      CustomContainer(
                                        onTap: () => showSnackbar(
                                            'Coming soon!!', themeColor),
                                        name: language['amountWithdrawn'],
                                        widgets: Row(
                                          children: [
                                            TextWidgetRoboto(
                                              title:
                                                  // 'Rs. ${earning.first.widthDrawalAmount}',

                                                  'Rs. ${convertAmountString(user.driver.earnings.currentMonth.toDouble())}',
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
                                        onTap: () => showSnackbar(
                                            'Coming soon!!', themeColor),
                                        name: language['eligibleToWithdraw'],
                                        widgets: Row(
                                          children: [
                                            earning.isEmpty
                                                ? const TextWidgetRoboto(
                                                    title: 'Rs. 0',

                                                    // 'Rs. ${convertAmountString(withrawableAmount.toDouble())}',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff78B84C),
                                                    fontSize: 16,
                                                  )
                                                : TextWidgetRoboto(
                                                    title:
                                                        'Rs. ${earning.first.widthDrawalAmount}',

                                                    // 'Rs. ${convertAmountString(withrawableAmount.toDouble())}',
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        const Color(0xff78B84C),
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
                                  padding:
                                      EdgeInsets.symmetric(vertical: dW * 0.02),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 0.1, color: themeColor),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: dW * 0.01,
                                      ),
                                      TextWidgetRoboto(
                                        title: language['earningsLastWeek'],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      if (earning.isNotEmpty)
                                        Container(
                                          height: dW * 0.51,
                                          margin:
                                              EdgeInsets.only(top: dW * 0.02),
                                          child: BarChart(
                                            BarChartData(
                                                barTouchData: BarTouchData(
                                                    touchTooltipData:
                                                        BarTouchTooltipData(
                                                  tooltipBgColor: Colors.grey
                                                      .withOpacity(0.5),
                                                )),
                                                alignment: BarChartAlignment
                                                    .spaceAround,
                                                maxY:
                                                    // maxEarning,
                                                    calculateMaxY(
                                                        earning.first.earning),

                                                // groupsSpace: 5,
                                                borderData: FlBorderData(
                                                  show: true,
                                                  border: const Border(
                                                      left: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xffC8C8C8),
                                                      ),
                                                      bottom: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xffC8C8C8),
                                                      )),
                                                ),
                                                gridData: const FlGridData(
                                                  show: false,
                                                ),
                                                titlesData: FlTitlesData(
                                                  topTitles: const AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  rightTitles: const AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  bottomTitles: AxisTitles(
                                                    // axisNameSize: 10,

                                                    sideTitles: _bottomTitles2(
                                                        (earning.first.earning
                                                                as List<
                                                                    dynamic>)
                                                            .map((entry) =>
                                                                entry['date']
                                                                    .toString())
                                                            .toList()),
                                                  ),

                                                  // leftTitles: AxisTitles(
                                                  //   drawBelowEverything: true,
                                                  //   axisNameSize: 16,
                                                  // ),
                                                ),
                                                barGroups: generateBarChartData(
                                                    earnings: earning)

                                                //     barChartData.map((data) {
                                                //   return data.copyWith(
                                                //     barRods: data.barRods
                                                //         .map((rod) => rod.copyWith(
                                                //               borderRadius:
                                                //                   BorderRadius.zero,
                                                //             ))
                                                //         .toList(),
                                                //   );
                                                // }).toList(),
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
                                    onPressed: () {
                                      showSnackbar('Coming soon!!', themeColor);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
