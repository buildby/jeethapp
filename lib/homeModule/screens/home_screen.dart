import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/marketplace_provider.dart';
import 'package:jeeth_app/authModule/widgets/marketplace_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onIndexChanged;

  HomeScreen({
    Key? key,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    return Scaffold(
      // key: _scaffoldKey,
      // drawer: const MyNavigationDrawer(),
      backgroundColor: themeColor,
      // appBar: CustomAppBar(
      //   title: language['chooseYourClient'],
      //   dW: dW,
      //   leading: GestureDetector(
      //     onTap: () => _scaffoldKey.currentState?.openDrawer(),
      //     child: Container(
      //       padding: EdgeInsets.all(dW * 0.035),
      //       child: const AssetSvgIcon(
      //         'drawer',
      //         height: 5,
      //       ),
      //     ),
      //   ),
      //   actions: [
      //     Container(
      //       margin: EdgeInsets.only(right: dW * 0.03),
      //       child: const Icon(Icons.notifications),
      //     ),
      //   ],
      // ),
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
              Column(
                children: [
                  Container(
                    color: themeColor,
                    height: dW * 0.4,
                  ),
                  Expanded(
                    child: Container(
                      color: white,
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            onTap: () {
                              widget.onIndexChanged(0);
                              push(NamedRoute.exploreDealScreen,
                                  arguments: ExploreDealScreenArguments(
                                      marketplace: marketplace[index]));
                            },
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
