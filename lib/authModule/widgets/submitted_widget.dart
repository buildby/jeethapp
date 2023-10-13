import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/marketplace_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class SubmittedWidget extends StatefulWidget {
  String vendorName;
  SubmittedWidget({super.key, required this.vendorName});

  @override
  SubmittedWidgetState createState() => SubmittedWidgetState();
}

class SubmittedWidgetState extends State<SubmittedWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    // final userId = Provider.of<AuthProvider>(context).user.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(
          indent: dW * 0.27,
          endIndent: dW * 0.27,
          color: Colors.black,
          thickness: 5,
        ),
        SizedBox(
          height: dW * 0.02,
        ),
        Image.asset(
          'assets/images/tickmark.png',
          scale: 3.5,
        ),
        SizedBox(
          height: dW * 0.03,
        ),
        TextWidget(
          title: language['profileHasSubmitted'],
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        SizedBox(
          height: dW * 0.04,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text:
                    'Hey User, your profile has been successfully shared with ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Blinker',
                  fontSize: 15,
                  color: Color(0xff555555),
                ),
              ),
              TextSpan(
                text: widget.vendorName,
                style: const TextStyle(
                  fontFamily: 'Blinker',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xff555555),
                ),
              ),
              const TextSpan(
                text:
                    ' for further approval and inspection. You will be notified shortly, Thanks.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Blinker',
                  fontSize: 15,
                  color: Color(0xff555555),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
