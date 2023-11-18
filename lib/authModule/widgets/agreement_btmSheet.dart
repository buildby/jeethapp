// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/vendor_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/agreement_widget.dart';
import 'package:jeeth_app/authModule/widgets/submitted_widget.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/homeModule/providers/my_application_provider.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

import '../../navigation/routes.dart';
import '../models/user_model.dart';

class AgreementBottomSheetWidget extends StatefulWidget {
  String vendorName;
  // Vendor vendor;
  final int campaignId;
  AgreementBottomSheetWidget({
    super.key,
    required this.vendorName,
    // required this.vendor,
    required this.campaignId,
  });

  @override
  AgreementBottomSheetWidgetState createState() =>
      AgreementBottomSheetWidgetState();
}

class AgreementBottomSheetWidgetState
    extends State<AgreementBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  int screenNumber = 1;

  late User user;

  createApplication() async {
    setState(() {
      isLoading = true;
    });

    final body = {
      'campaign_id': widget.campaignId,
      'driver_id': user.driver.id,
      // 'Vendor': widget.vendor,
    };

    final response =
        await Provider.of<MyApplicationProvider>(context, listen: false)
            .createMyApplication(body: body, accessToken: user.accessToken);

    setState(() {
      isLoading = false;
    });

    screenNumber++;

    if (response['result'] == 'success') {}
    // showSnackbar(response['message']);
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    // final userId = Provider.of<AuthProvider>(context).user.id;
    Widget currentWidget = AgreementWidget();

    switch (screenNumber) {
      case 2:
        currentWidget = SubmittedWidget(
          vendorName: widget.vendorName,
        );
        break;
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
            child: currentWidget,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: dW * 0.1, right: dW * 0.1, bottom: dW * 0.1),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 26))
            ],
          ),
          child: isLoading
              ? const CircularLoader()
              : CustomButton(
                  width: dW,
                  height: dW * 0.15,
                  elevation: 9,
                  radius: 21,
                  buttonText: screenNumber == 1
                      ? language['iAgree']
                      : language['goToApplications'],
                  onPressed: () {
                    if (screenNumber == 1) {
                      setState(() {
                        createApplication();
                      });
                    } else {
                      pop();
                      pop();
                      push(NamedRoute.myApplicationsScreen);
                    }
                  },
                ),
        ),
      ],
    );
  }
}
