import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class AgreementWidget extends StatefulWidget {
  AgreementWidget({
    super.key,
  });

  @override
  AgreementWidgetState createState() => AgreementWidgetState();
}

class AgreementWidgetState extends State<AgreementWidget> {
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: dW * 0.04,
          ),
          Divider(
            indent: dW * 0.27,
            endIndent: dW * 0.27,
            color: Colors.black,
            thickness: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: dW * 0.08, bottom: dW * 0.08),
            padding: EdgeInsets.symmetric(
                horizontal: dW * 0.05, vertical: dW * 0.045),
            decoration: BoxDecoration(
              color: const Color(0xff0CD78E),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const AssetSvgIcon('timer'),
          ),
          TextWidget(
            title: language['profileWillSubmitted'],
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          SizedBox(
            height: dW * 0.04,
          ),
          TextWidget(
            textAlign: TextAlign.center,
            title: language['agreementSubtitle'],
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: 0.40,
            fontSize: 15,
            color: const Color(0xff555555),
          ),
          SizedBox(
            height: dW * 0.04,
          ),
        ],
      ),
    );
  }
}
