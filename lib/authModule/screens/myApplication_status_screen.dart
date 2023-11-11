import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/approved_widget.dart';
import 'package:jeeth_app/authModule/widgets/pending_widget.dart';
import 'package:jeeth_app/authModule/widgets/rejected_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/homeModule/providers/my_application_provider.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:provider/provider.dart';

class MyApplicationsStatusScreen extends StatefulWidget {
  final MyApplicationsStatusArguments args;
  const MyApplicationsStatusScreen({Key? key, required this.args})
      : super(key: key);

  @override
  MyApplicationsStatusScreenState createState() =>
      MyApplicationsStatusScreenState();
}

class MyApplicationsStatusScreenState
    extends State<MyApplicationsStatusScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  int screenNumber = 1;

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
    // final myApplication =
    //     Provider.of<MyApplicationProvider>(context, listen: false)
    //         .myApplications;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: CustomAppBar(
        title: widget.args.myApplication.status == 'PENDING' ||
                widget.args.myApplication.status == 'HOLD'
            ? language['pending']
            : widget.args.myApplication.status == 'REJECTED'
                ? language['rejected']
                : language['aproved'],
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w900,
        dW: dW,
        centerTitle: true,
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    Widget currentWidget = widget.args.myApplication.status == 'PENDING' ||
            widget.args.myApplication.status == 'HOLD'
        ? PendingWidget(
            args: MyApplicationsStatusArguments(
              myApplication: widget.args.myApplication,
            ),
          )
        : widget.args.myApplication.status == 'REJECTED'
            ? RejectedWidget(
                args: MyApplicationsStatusArguments(
                  myApplication: widget.args.myApplication,
                ),
              )
            : ApprovedWidget(
                args: MyApplicationsStatusArguments(
                  myApplication: widget.args.myApplication,
                ),
              );

    return isLoading ? const Center(child: CircularLoader()) : currentWidget;
  }
}
