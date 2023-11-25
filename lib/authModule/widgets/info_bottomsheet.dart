import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_dialog.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class InfoBottomSheetWidget extends StatefulWidget {
  const InfoBottomSheetWidget({
    super.key,
  });

  @override
  InfoBottomSheetWidgetState createState() => InfoBottomSheetWidgetState();
}

class InfoBottomSheetWidgetState extends State<InfoBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    pushAndRemoveUntil(NamedRoute.mobileNumberScreen);
  }

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

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: dW * horizontalPaddingFactor,
          horizontal: dW * horizontalPaddingFactor),
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
                  const TextWidget(
                    title: 'Info',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: dW * 0.1, right: dW * 0.1, bottom: dW * 0.1),
            child: CustomButton(
              width: dW,
              height: dW * 0.15,
              radius: 21,
              buttonText: language['gotIt'],
              onPressed: () => pop(),
            ),
          ),
          // GestureDetector(
          //   onTap: () => showDialog(
          //     context: context,
          //     builder: (context) => CustomDialog(
          //       title: language['logout'],
          //       subTitle: language['wantToLogout'],
          //       noText: language['no'],
          //       yesText: language['yes'],
          //       noFunction: () {
          //         pop();
          //       },
          //       yesFunction: () {
          //         logout();
          //       },
          //     ),
          //   ),
          //   child: const TextWidget(
          //     title: 'Logout',
          //     fontWeight: FontWeight.w600,
          //     fontSize: 22,
          //   ),
          // ),
          SizedBox(
            height: dW * 0.1,
          )
        ],
      ),
    );
  }
}
