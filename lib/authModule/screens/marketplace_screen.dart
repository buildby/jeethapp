import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/model/marketplace_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/marketplace_provider.dart';
import 'package:jeeth_app/authModule/widgets/incomplete_prof_bottomsheet_widget.dart';
import 'package:jeeth_app/authModule/widgets/marketplace_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({
    Key? key,
  }) : super(key: key);

  @override
  MarketPlaceScreenState createState() => MarketPlaceScreenState();
}

class MarketPlaceScreenState extends State<MarketPlaceScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  void incompleteProfBottomSheet() {
    showModalBottomSheet(
      // isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: dH * 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => const IncompleteProfBottomSheetWidget(),
    );
  }

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    // user = Provider.of<AuthProvider>(context, listen: false).user;
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: CustomAppBar(title: '', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    final marketplace =
        Provider.of<MarketplaceProvider>(context, listen: false).marketplaces;
    return isLoading
        ? const Center(child: CircularLoader())
        : Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: white,
                // height: dH,
                // width: dW,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(right: dW * 0.01, bottom: dW * 0.03),
                      height: dW * 0.3,
                      width: dW,
                      color: themeColor,
                      child: TextWidget(
                        textAlign: TextAlign.end,
                        title: language['go'],
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.06),
                        fontSize: 119,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(left: dW * 0.05, bottom: dW * 0.04),
                      child: TextWidget(
                        title: language['marketplace'],
                        fontWeight: FontWeight.w600,
                        fontSize: 39,
                        color: white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                      child: Container(
                        height: dH * 0.8,
                        padding: EdgeInsets.only(
                            top: dW * 0.06, left: dW * 0.02, right: dW * 0.02),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 3,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          itemCount: marketplace.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => incompleteProfBottomSheet(),
                            child: MarketplaceWidget(
                              key: ValueKey(marketplace[index].id),
                              marketplace: marketplace[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}