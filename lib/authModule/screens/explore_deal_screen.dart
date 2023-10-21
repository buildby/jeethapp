import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/agreement_btmSheet.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget2.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:provider/provider.dart';

class ExploreDealScreen extends StatefulWidget {
  final ExploreDealScreenArguments args;
  ExploreDealScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  ExploreDealScreenState createState() => ExploreDealScreenState();
}

class ExploreDealScreenState extends State<ExploreDealScreen>
    with TickerProviderStateMixin {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  //  late User user;
  String imgPath = '';
  String ownerImg = '';
  bool isDriverSlide = true;
  String header = 'Driver Documents';
  String subHeader = 'Swipe for Vehicle Details';
  num vehicleDetailsPercentage = 0;
  num vehicleDocPercentage = 0;
  num ownerDocPercentage = 0;
  num driverDetailsPercentage = 0;

  Map language = {};
  bool showOwnerDetails = true;
  bool isLoading = false;
  bool validateForm = false;

  TextTheme get textTheme => Theme.of(context).textTheme;

  final List<String> dataList = [
    '0-20 Kms',
    '21-40 Kms',
    '41-60 Kms',
  ];

  final List<String> price = [
    '466.82',
    '533.26',
    '679.15',
  ];

  void agreementBottomSheet() {
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
      builder: (context) => AgreementBottomSheetWidget(
        vendorName: widget.args.marketplace.vendername,
      ),
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
      appBar: CustomAppBar(
        title: language['exploreDeal'],
        dW: dW,
        actions: [
          Container(
            margin: EdgeInsets.only(right: dW * 0.04),
            child: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: dW * 0.32,
                        color: themeColor,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -2,
                              left: 30,
                              right: 30,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: dW * 0.07,
                                ),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                height: dW * 0.2,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: dW * 0.06, vertical: dW * 0.05),
                              margin: EdgeInsets.only(top: dW * 0.1),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/vendor.png',
                                        scale: 1.8,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: dW * 0.04,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: dW * 0.01,
                                      ),
                                      TextWidget(
                                        title:
                                            widget.args.marketplace.vendername,
                                        color: const Color(0xff242E42),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                      SizedBox(
                                        height: dW * 0.03,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: dW * 0.05),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: dW * 0.01,
                                                vertical: dW * 0.008),
                                            decoration: BoxDecoration(
                                                color: widget.args.marketplace
                                                            .rating >=
                                                        4
                                                    ? const Color(0xff0CD78E)
                                                    : const Color(
                                                        (0xffF4B617),
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: Row(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: widget
                                                                .args
                                                                .marketplace
                                                                .rating >=
                                                            4
                                                        ? const Color.fromARGB(
                                                            255, 14, 187, 124)
                                                        : const Color.fromARGB(
                                                            255, 214, 159, 20),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                padding:
                                                    const EdgeInsets.all(1),
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
                                                title: widget
                                                    .args.marketplace.rating
                                                    .toString(),
                                                color: white,
                                                fontSize: 12,
                                              )
                                            ]),
                                          ),
                                          Row(
                                            children: const [
                                              TextWidgetRoboto(
                                                title: 'Vintage :~ ',
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                              TextWidgetRoboto(
                                                title: '40 Years',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: dW,
                          margin: EdgeInsets.only(
                              top: dW * 0.03, bottom: dW * 0.03),
                          padding: EdgeInsets.symmetric(
                              horizontal: dW * 0.04, vertical: dW * 0.05),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -5))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            TextWidget(
                                              title:
                                                  '${language['company']} : ',
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xff242E42),
                                            ),
                                            Image.asset(
                                              widget.args.marketplace.image,
                                              scale: 6,
                                            ),
                                            SizedBox(
                                              width: dW * 0.015,
                                            ),
                                            Container(
                                              width: dW * 0.23,
                                              child: TextWidget(
                                                color: const Color(0xff242E42),
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                title: widget.args.marketplace
                                                    .companyName,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: dW * 0.07,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const TextWidget(
                                              title: 'Midspace : ',
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xff242E42),
                                            ),
                                            SizedBox(
                                              width: dW * 0.16,
                                              child: const TextWidget(
                                                color: Color(0xff242E42),
                                                title: 'Hitesh Chaudhary',
                                                fontWeight: FontWeight.w400,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: dW * 0.01,
                              ),
                              const Divider(
                                color: Color(0xffF4F4F4),
                                thickness: 1,
                              ),
                              SizedBox(
                                height: dW * 0.01,
                              ),
                              TextWidget(
                                title: language['loginSlots'],
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color(0xff242E42),
                              ),
                              SizedBox(
                                height: dW * 0.03,
                              ),
                              Wrap(
                                children: [
                                  for (int i = 0; i < 8; i++)
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: i == 5 ? 0 : dW * 0.025,
                                        bottom: dW * 0.03,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: dW * 0.02,
                                        right: dW * 0.015,
                                        top: dW * 0.01,
                                        bottom: dW * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ((i == 3) || (i == 5))
                                            ? const Color(0xffD5FBE0)
                                            : const Color(0xffFCF4CB),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: TextWidgetRoboto(
                                        title: [
                                          '05:30',
                                          '08:30',
                                          '10:40',
                                          '13:00',
                                          '18:00',
                                          '13:00',
                                          '18:00',
                                          '20:30'
                                        ][i],
                                        color: const Color(0xff505050),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: dW * 0.04,
                              ),
                              TextWidget(
                                title: language['logoutSlots'],
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color(0xff242E42),
                              ),
                              SizedBox(
                                height: dW * 0.03,
                              ),
                              Wrap(
                                children: [
                                  for (int i = 0; i < 8; i++)
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: i == 5 ? 0 : dW * 0.025,
                                        bottom: dW * 0.03,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: dW * 0.02,
                                        right: dW * 0.015,
                                        top: dW * 0.01,
                                        bottom: dW * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ((i == 3) || (i == 5))
                                            ? const Color(0xffD5FBE0)
                                            : const Color(0xffFCF4CB),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: TextWidgetRoboto(
                                        title: [
                                          '05:30',
                                          '08:30',
                                          '10:40',
                                          '13:00',
                                          '18:00',
                                          '13:00',
                                          '18:00',
                                          '20:30'
                                        ][i],
                                        color: const Color(0xff505050),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: dW,
                          margin: EdgeInsets.only(bottom: dW * 0.03),
                          padding: EdgeInsets.symmetric(
                              horizontal: dW * 0.04, vertical: dW * 0.05),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffF4F4F4), width: 1),
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -5))
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: const [
                                              TextWidget(
                                                title: 'Business model : ',
                                                fontWeight: FontWeight.w300,
                                              ),
                                              TextWidget(
                                                title: 'Trip wise',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const TextWidget(
                                      title: 'Net Fare',
                                      color: Color(0xff767676),
                                      fontWeight: FontWeight.w300,
                                    ),
                                    SizedBox(
                                      width: dW * 0.08,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: dW * 0.01,
                                ),
                                const Divider(
                                  color: Color(0xffF4F4F4),
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: dW * 0.01,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: dW * 0.025),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: dW * 0.015,
                                                    vertical: dW * 0.005),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: themeColor),
                                                child: const TextWidget(
                                                  title: '1',
                                                  color: white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const TextWidgetRoboto(
                                                title: '0-20 Kms',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.end,
                                      children: [
                                        TextWidgetRoboto(
                                          title: '\u20b9',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff464646),
                                        ),
                                        SizedBox(
                                          width: dW * 0.01,
                                        ),
                                        TextWidgetRoboto(
                                          title: '466.82',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff464646),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: dW * 0.07,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: dW * 0.03,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: dW * 0.025),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: dW * 0.015,
                                                    vertical: dW * 0.005),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: themeColor),
                                                child: const TextWidget(
                                                  title: '2',
                                                  color: white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const TextWidgetRoboto(
                                                title: '21-40 Kms',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.end,
                                      children: [
                                        TextWidgetRoboto(
                                          title: '\u20b9',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff464646),
                                        ),
                                        SizedBox(
                                          width: dW * 0.01,
                                        ),
                                        TextWidgetRoboto(
                                          title: '533.26',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff464646),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: dW * 0.07,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: dW * 0.03,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: dW * 0.025),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: dW * 0.015,
                                                    vertical: dW * 0.005),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: themeColor),
                                                child: const TextWidget(
                                                  title: '3',
                                                  color: white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const TextWidgetRoboto(
                                                title: '41-60 Kms',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.end,
                                      children: [
                                        TextWidgetRoboto(
                                          title: '\u20b9',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff464646),
                                        ),
                                        SizedBox(
                                          width: dW * 0.01,
                                        ),
                                        TextWidgetRoboto(
                                          title: '679.15',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff464646),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: dW * 0.07,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: dW * 0.15,
                              right: dW * 0.15,
                              // bottom: dW * 0.1,
                              top: dW * 0.05),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.12),
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 26))
                            ],
                          ),
                          child: CustomButton(
                            width: dW,
                            height: dW * 0.15,
                            elevation: 12,
                            radius: 21,
                            buttonText: language['applyNow'],
                            onPressed: agreementBottomSheet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
