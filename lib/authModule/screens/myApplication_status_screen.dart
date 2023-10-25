import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
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
    final myApplication =
        Provider.of<MyApplicationProvider>(context, listen: false)
            .myApplications;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: CustomAppBar(
        title: widget.args.myApplication.status,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w900,
        dW: dW,
        centerTitle: true,
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : SingleChildScrollView(
              padding: screenHorizontalPadding(dW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: dW * 0.05),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (widget.args.myApplication.status == 'Approved!')
                        const Center(child: AssetSvgIcon('approved_bg')),
                      Positioned(
                        top: widget.args.myApplication.status == 'Approved!'
                            ? 85
                            : null,
                        left: widget.args.myApplication.status == 'Approved!'
                            ? 0
                            : null,
                        right: widget.args.myApplication.status == 'Approved!'
                            ? 0
                            : null,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: widget.args.myApplication.status ==
                                      'Approved!'
                                  ? 0
                                  : dW * 0.2),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: dW,
                                padding: EdgeInsets.only(
                                    bottom: dW * 0.055,
                                    left: dW * 0.06,
                                    right: dW * 0.06),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: white),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: dW * 0.2,
                                    ),
                                    TextWidgetPoppins(
                                      title: widget.args.vendorName,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -48,
                                right: 18,
                                left: 0,
                                child: CircleAvatar(
                                  radius: 50,
                                  child: Image.asset(
                                    widget.args.myApplication.logo,
                                    scale: 1.3,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
