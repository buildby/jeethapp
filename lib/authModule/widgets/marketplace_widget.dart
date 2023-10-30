import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/marketplace_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget2.dart';
import 'package:provider/provider.dart';

class MarketplaceWidget extends StatefulWidget {
  final Marketplace marketplace;
  bool loggedIn;
  MarketplaceWidget({Key? key, required this.marketplace, this.loggedIn = true})
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
  TextTheme get textTheme => Theme.of(context).textTheme;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      margin: EdgeInsets.only(bottom: dW * 0.05),
      padding:
          EdgeInsets.only(left: dW * 0.02, right: dW * 0.02, bottom: dW * 0.06),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                widget.marketplace.image,
                scale: 1.8,
              ),
            ],
          ),
          // SizedBox(
          //   width: dW * 0.03,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: dW * 0.01,
              ),
              Row(
                children: [
                  TextWidget(
                    title: language['vendor'],
                    fontWeight: FontWeight.w300,
                  ),
                  SizedBox(
                    width: dW * 0.31,
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
                    width: dW * 0.028,
                  ),
                  Row(
                    children: [
                      const TextWidgetRoboto(
                        title: 'Sedan : ',
                        fontWeight: FontWeight.w300,
                      ),
                      TextWidgetRoboto(
                        title: widget.marketplace.totalSedan.toString(),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: dW * 0.015,
                  ),
                  Row(
                    children: [
                      const TextWidgetRoboto(
                        title: 'SUV : ',
                        fontWeight: FontWeight.w300,
                      ),
                      TextWidgetRoboto(
                        title: widget.marketplace.totalSuv.toString(),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
                        ? TextWidgetRoboto(
                            title:
                                'Rs. ${widget.marketplace.avgFare.toStringAsFixed(0)}*',
                            color: const Color(0xff13A088),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )
                        : ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 5,
                                sigmaY: 5,
                              ),
                              child: TextWidgetRoboto(
                                title:
                                    'Rs. ${widget.marketplace.avgFare.toStringAsFixed(0)}*',
                                color: const Color(0xff13A088),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
