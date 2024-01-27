// ignore_for_file: must_be_immutable

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/marketplace_model.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget2.dart';
import 'package:jeeth_app/homeModule/providers/my_application_provider.dart';
import 'package:provider/provider.dart';

import '../../common_functions.dart';
import '../../common_widgets/cached_image_widget.dart';

class MarketplaceWidget extends StatefulWidget {
  final Marketplace marketplace;
  bool loggedIn;
  final User? user;
  MarketplaceWidget(
      {Key? key, required this.marketplace, this.user, this.loggedIn = true})
      : super(key: key);

  @override
  MarketplaceWidgetState createState() => MarketplaceWidgetState();
}

class MarketplaceWidgetState extends State<MarketplaceWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  bool isLoading = false;
  bool alreadyApplied = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  Map vehicle = {};

  isAlreadyAppliedApplication() async {
    setState(() => isLoading = true);
    final response =
        await Provider.of<MyApplicationProvider>(context, listen: false)
            .isAlreadyAppliedApplication(
                accessToken: widget.user!.accessToken,
                driverId: widget.user!.driver.id,
                campaignId: widget.marketplace.id);

    if (response['result'] == 'success' && response['data'] != null) {
      alreadyApplied = true;
    }
    setState(() => isLoading = false);
  }

  getVehicleCount(Map slots, String vehicleType) {
    num totalVehicleCount = 0;

    slots.forEach((timeSlot, vehicleCounts) {
      if (vehicleCounts.containsKey(vehicleType)) {
        totalVehicleCount += vehicleCounts[vehicleType];
      }
    });
    return totalVehicleCount;
  }

  @override
  void initState() {
    super.initState();

    vehicle = widget.marketplace.data;
    isAlreadyAppliedApplication();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      margin: EdgeInsets.only(bottom: dW * 0.05),
      padding: EdgeInsets.only(
          left: dW * 0.015, right: dW * 0.02, bottom: dW * 0.06),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 1.5,
                      color: const Color(0XFF13A088),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedImageWidget(
                      widget.marketplace.clientSite.avatar,
                      boxFit: BoxFit.cover,
                      width: dW * 0.12,
                      height: dW * 0.12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: dW * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: dW * 0.01,
                ),
                Row(
                  children: [
                    // TextWidget(
                    //   title: language['vendor'],
                    //   fontWeight: FontWeight.w300,
                    // ),
                    SizedBox(
                      width: dW * 0.47,
                      child: TextWidget(
                        title: widget.marketplace.vendername,
                        textOverflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff242E42),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: dW * 0.03,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: dW * 0.01, vertical: dW * 0.008),
                      decoration: BoxDecoration(
                          color: widget.marketplace.rating >= 4
                              ? const Color(0xff0CD78E)
                              : const Color(
                                  (0xffF4B617),
                                ),
                          borderRadius: BorderRadius.circular(2)),
                      child: Row(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: widget.marketplace.rating >= 4
                                  ? const Color.fromARGB(255, 14, 187, 124)
                                  : const Color.fromARGB(255, 214, 159, 20),
                              borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.all(1),
                          child: const Icon(
                            Icons.star,
                            color: white,
                            size: 10,
                          ),
                        ),
                        SizedBox(
                          width: dW * 0.008,
                        ),
                        TextWidgetRoboto(
                          title: widget.marketplace.rating.toString(),
                          color: white,
                          fontSize: 12,
                        )
                      ]),
                    ),
                    SizedBox(
                      width: dW * 0.01,
                    ),
                    Row(
                      children: [
                        const TextWidgetRoboto(
                          title: 'Sedan:',
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                        // Image.asset(
                        //   'assets/images/sedan.jpeg',
                        //   scale: 12,
                        // ),
                        TextWidgetRoboto(
                          title: getVehicleCount(vehicle["loginSlot"], "sedan")
                              .toString(),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: dW * 0.015,
                    ),
                    Row(
                      children: [
                        const TextWidgetRoboto(
                          title: 'SUV:',
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                        // Image.asset(
                        //   'assets/images/suv.jpeg',
                        //   scale: 12,
                        // ),
                        TextWidgetRoboto(
                          title: getVehicleCount(vehicle["loginSlot"], "suv")
                              .toString(),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: dW * 0.015,
                    ),
                    Row(
                      children: [
                        const TextWidgetRoboto(
                          title: 'Mini:',
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                        // Image.asset(
                        //   'assets/images/mini.jpeg',
                        //   scale: 10,
                        // ),
                        TextWidgetRoboto(
                          title: getVehicleCount(vehicle["loginSlot"], "mini")
                              .toString(),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                if (alreadyApplied)
                  Container(
                    margin: EdgeInsets.only(top: dW * 0.03),
                    child: TextWidgetRoboto(
                      title: language['alreadyApplied'],
                      color: themeColor,
                    ),
                  ),
              ],
            ),
            if (dW <= 360)
              SizedBox(
                width: dW * 0.03,
              ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: dW * 0.02, vertical: dW * 0.015),
                  margin: EdgeInsets.only(top: dW * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xffD8D8D8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidgetRoboto(
                        title: 'Avg. Fare',
                        fontWeight: FontWeight.w300,
                      ),
                      SizedBox(
                        height: dW * 0.02,
                      ),
                      widget.loggedIn
                          ? SizedBox(
                              width: dW * 0.15,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: TextWidgetRoboto(
                                  title:
                                      'Rs. ${convertAmountString(widget.marketplace.avgFare.toDouble())}*',
                                  color: const Color(0xff13A088),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: SizedBox(
                                  width: dW * 0.15,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: TextWidgetRoboto(
                                      title:
                                          'Rs. ${convertAmountString(widget.marketplace.avgFare.toDouble())}*',
                                      color: const Color(0xff13A088),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
