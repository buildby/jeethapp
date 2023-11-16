import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/myApplication_container.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/homeModule/providers/my_application_provider.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({Key? key}) : super(key: key);

  @override
  MyApplicationsScreenState createState() => MyApplicationsScreenState();
}

class MyApplicationsScreenState extends State<MyApplicationsScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  late User user;

  fetchMyApplication() async {
    setState(() => isLoading = true);
    final response =
        await Provider.of<MyApplicationProvider>(context, listen: false)
            .fetchMyApplication(
      accessToken: user.accessToken,
      driverId: user.driver.id,
    );
    if (response['result'] == 'success') {
      // showSnackbar(response['message']);
    }
    setState(() => isLoading = false);
  }

  String formatDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String formattedDay = _formatDay(int.parse(day));
    String formattedMonth = DateFormat('MMM').format(date);
    String formattedYear = DateFormat('y').format(date);
    return '$formattedDay $formattedMonth, $formattedYear';
  }

  String _formatDay(int day) {
    if (day >= 11 && day <= 13) {
      return '$day${'th'}';
    }
    switch (day % 10) {
      case 1:
        return '$day${day == 11 ? 'th' : 'st'}';
      case 2:
        return '$day${day == 12 ? 'th' : 'nd'}';
      case 3:
        return '$day${day == 13 ? 'th' : 'rd'}';
      default:
        return '$day${'th'}';
    }
  }

  logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    pushAndRemoveUntil(NamedRoute.mobileNumberScreen);
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    fetchMyApplication();
    Provider.of<AuthProvider>(context, listen: false)
        .driverAutoLogin(phone: user.driver.phone, refresh: true);
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
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    // DateTime currentDate = DateTime.now();
    // String formattedDate = formatDate(currentDate);
    final myApplication =
        Provider.of<MyApplicationProvider>(context, listen: false)
            .myApplications;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          color: white.withOpacity(0.96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: dW * 0.25,
                color: themeColor,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: dW * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(left: dW * 0.05, right: dW * 0.04),
              child: TextWidgetPoppins(
                title: language['myApplications'],
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: white,
              ),
            ),
            SizedBox(
              height: dW * 0.06,
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularLoader())
                  : RefreshIndicator(
                      color: themeColor,
                      onRefresh: () async {
                        await fetchMyApplication();
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: myApplication.length,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            // final subtitle = myApplication[i].status;
                            return GestureDetector(
                              onTap: () {
                                push(
                                  NamedRoute.myApplicationsStatusScreen,
                                  arguments: MyApplicationsStatusArguments(
                                    myApplication: myApplication[i],
                                  ),
                                );
                              },
                              child: MyApplicationContainer(
                                application: myApplication[i],
                                // onTap: () {
                                // push(
                                //   NamedRoute.myApplicationsStatusScreen,
                                //   arguments: MyApplicationsStatusArguments(
                                //       myApplication: myApplication[i],
                                //       vendorName: marketplace[i].vendername),
                                // );
                                // },
                                // title: marketplace[i].vendername,
                                // subTitle: subtitle == 'Approved!'
                                //     ? 'approved'
                                //     : subtitle == 'Pending!'
                                //         ? 'awaitingApproval'
                                //         : 'denied',
                                // date: formattedDate,
                              ),
                            );
                          }),
                    ),
            ),
            // MyApplicationContainer(
            //     title: 'Shyam Salasar Logist.',
            //     subTitle: 'awaitingApproval',
            //     onTap: () {
            //       push(NamedRoute.myApplicationsStatusScreen,
            //           arguments: MyApplicationsStatusArguments(
            //               status: myApplication.first.status));
            //     },
            //     date: formattedDate),
            // MyApplicationContainer(
            //     title: '4 Wheel Travels',
            //     onTap: () {},
            //     subTitle: 'denied',
            //     date: formattedDate),
            // MyApplicationContainer(
            //     title: 'Shyam Salasar Logist.',
            //     onTap: () {},
            //     subTitle: 'approved',
            //     date: formattedDate),
          ],
        ),
      ],
    );
  }
}
