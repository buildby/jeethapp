import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class IncompleteProfBottomSheetWidget extends StatefulWidget {
  const IncompleteProfBottomSheetWidget({
    super.key,
  });

  @override
  IncompleteProfBottomSheetWidgetState createState() =>
      IncompleteProfBottomSheetWidgetState();
}

class IncompleteProfBottomSheetWidgetState
    extends State<IncompleteProfBottomSheetWidget> {
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
    // ignore: deprecated_member_use
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    // final userId = Provider.of<AuthProvider>(context).user.id;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: dW * 0.04, horizontal: dW * horizontalPaddingFactor),
      child: Column(
        children: [
          Divider(
            indent: dW * 0.27,
            endIndent: dW * 0.27,
            color: Colors.black,
            thickness: 5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: dW * 0.08, bottom: dW * 0.08),
                    padding: EdgeInsets.symmetric(
                        horizontal: dW * 0.06, vertical: dW * 0.03),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4B617),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const AssetSvgIcon('exclaimation'),
                  ),
                  TextWidget(
                    title: language['incompleteProfile'],
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  TextWidget(
                    textAlign: TextAlign.center,
                    title: language['inCompleteProfBtmStSubtitle'],
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    fontSize: 17,
                  ),
                  SizedBox(
                    height: dW * 0.04,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: dW * 0.1, right: dW * 0.1, bottom: dW * 0.05),
            child: CustomButton(
              width: dW,
              height: dW * 0.15,
              radius: 21,
              buttonText: language['proceed'],
              onPressed: () => push(NamedRoute.profileDocumentsScreen),
            ),
          ),
        ],
      ),
    );
  }
}
