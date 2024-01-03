import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/marketplace_provider.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/homeModule/providers/my_application_provider.dart';
import 'package:jeeth_app/homeModule/widgets/notification_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  String approvedVendorName = '';
  String rejectedVendorName = '';

  fetchData() async {
    setState(() => isLoading = true);
    fetchMyApplication();
    setState(() => isLoading = false);
  }

  logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    pushAndRemoveUntil(NamedRoute.mobileNumberScreen);
  }

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
    language =
        Provider.of<AuthProvider>(context, listen: false).selectedLanguage;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: CustomAppBar(
        dW: dW,
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    final myApplications =
        Provider.of<MyApplicationProvider>(context, listen: false)
            .myApplications;
    final marketplaces =
        Provider.of<MarketplaceProvider>(context, listen: false).marketplaces;
    List<NotificationWidget> getNotificationWidgets() {
      return myApplications
          .where((application) =>
              application.status == 'APPROVED' ||
              application.status == 'REJECTED')
          .map((application) {
        return NotificationWidget(
            icon: application.status == 'APPROVED' ? 'tick' : 'cross',
            title: application.status == 'APPROVED'
                ? 'Your Application is approved by $approvedVendorName'
                : 'Your Application is rejected by $rejectedVendorName',
            subTitle: DateFormat('d MMM, yyyy')
                .format(application.createdAt)
                .toString());
      }).toList();
    }

    bool isApproved =
        myApplications.any((application) => application.status == 'APPROVED');

    final approvedApplications = myApplications
        .where((application) => application.status == 'APPROVED')
        .toList();

    final rejectedApplications = myApplications
        .where((application) => application.status == 'REJECTED')
        .toList();

    if (approvedApplications.isNotEmpty || rejectedApplications.isNotEmpty) {
      if (isApproved) {
        final approvedMarketplace = marketplaces.firstWhere(
          (marketplace) => myApplications.any(
            (application) =>
                application.status == 'APPROVED' &&
                application.campaignId == marketplace.id,
          ),
        );

        approvedVendorName = approvedMarketplace.vendername;
      } else if (!isApproved) {
        final rejectedMarketplace =
            marketplaces.firstWhere((marketplace) => myApplications.any(
                  (application) =>
                      application.status == 'REJECTED' &&
                      application.campaignId == marketplace.id,
                ));

        rejectedVendorName = rejectedMarketplace.vendername;
      }
    }

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
                      height: dW * 0.23,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgetPoppins(
                          title: language['notifications'],
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: white,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.02, vertical: dW * 0.02),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black.withOpacity(0.05),
                            ),
                            child: const AssetSvgIcon(
                              'delete',
                              height: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: dW * 0.08,
                  ),
                  if (getNotificationWidgets().isEmpty &&
                      approvedApplications.isEmpty &&
                      rejectedApplications.isEmpty)
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: TextWidgetPoppins(
                            title: 'No notifications yet...',
                            fontWeight: FontWeight.w600,
                          )),
                        ],
                      ),
                    )
                  else
                    ...getNotificationWidgets(),
                  // NotificationWidget(
                  //     icon: 'tick',
                  //     title: 'Business',
                  //     subTitle:
                  //         'Your application has been approve Your application has been approve..'),
                  // NotificationWidget(
                  //     icon: 'cross',
                  //     title: 'Business',
                  //     subTitle: 'Application Denied, find the details..'),
                  // NotificationWidget(
                  //     icon: 'wallet',
                  //     title: 'Wallet',
                  //     subTitle: 'Earnings ready to withdraw!! Click..'),
                ],
              ),
            ],
          );
  }
}
