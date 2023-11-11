import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget3.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/cached_image_widget.dart';

class PendingWidget extends StatefulWidget {
  final MyApplicationsStatusArguments args;
  const PendingWidget({Key? key, required this.args}) : super(key: key);

  @override
  ApprovedStateWidget createState() => ApprovedStateWidget();
}

class ApprovedStateWidget extends State<PendingWidget> {
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
      child: Container(
        padding: EdgeInsets.only(top: dW * 0.25, bottom: dW * 0.1),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: dW,

              // height: dH * 0.7,
              padding: EdgeInsets.only(
                  bottom: dW * 0.055,
                  left: dW * 0.06,
                  right: dW * 0.06,
                  top: dW * 0.055),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: dW * 0.15,
                      ),
                      TextWidgetPoppins(
                        title: widget.args.myApplication.vendorName,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                      SizedBox(
                        height: dW * 0.015,
                      ),
                      TextWidgetPoppins(
                        title: widget.args.myApplication.clientSiteName,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8A8A8F),
                        fontSize: 15,
                      ),
                      SizedBox(
                        height: dW * 0.1,
                      ),
                      TextWidgetPoppins(
                        title: language['decisionPending'],
                        color: const Color(0xffE4CF11),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: 0.41,
                      ),
                      SizedBox(
                        height: dW * 0.02,
                      ),
                      TextWidgetPoppins(
                        textAlign: TextAlign.center,
                        title: language['pendingPara'],
                        height: 1.5,
                        color: const Color(0xff8A8A8F),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.41,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        // left: dW * 0.12,
                        // right: dW * 0.12,
                        // bottom: dW * 0.1,
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
                      height: dW * 0.12,
                      onPressed: () {
                        pop();
                        pop();
                      },
                      radius: 10,
                      buttonText: language['backHome'],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -50,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 1.5, color: const Color(0XFF13A088))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedImageWidget(
                      widget.args.myApplication.vendorAvatar,
                      boxFit: BoxFit.cover,
                      width: dW * 0.25,
                      height: dW * 0.25,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
