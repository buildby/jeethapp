import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/driver_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/agreement_btmSheet.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/common_widgets/text_widget2.dart';
import 'package:jeeth_app/homeModule/models/my_application_model.dart';
import 'package:jeeth_app/homeModule/providers/my_application_provider.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../../common_widgets/cached_image_widget.dart';

class ExploreDealScreen extends StatefulWidget {
  final ExploreDealScreenArguments args;
  const ExploreDealScreen({
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

  late User user;

  late Map businessModel;
  //  late User user;
  bool alreadyApplied = false;
  String imgPath = '';
  String ownerImg = '';
  bool isDriverSlide = true;
  String header = 'Driver Documents';
  String subHeader = 'Swipe for Vehicle Details';
  num vehicleDetailsPercentage = 0;
  num vehicleDocPercentage = 0;
  num ownerDocPercentage = 0;
  num driverDetailsPercentage = 0;
  List<MyApplication> myApplication = [];

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
        campaignId: widget.args.marketplace.id,
      ),
    );
  }

  isAlreadyAppliedApplication() async {
    setState(() => isLoading = true);
    final response =
        await Provider.of<MyApplicationProvider>(context, listen: false)
            .isAlreadyAppliedApplication(
                accessToken: user.accessToken,
                driverId: user.driver.id,
                campaignId: widget.args.marketplace.id);

    if (response['result'] == 'success' && response['data'] != null) {
      alreadyApplied = true;
    }
    setState(() => isLoading = false);
  }

  fetchData() async {
    setState(() => isLoading = true);
    await isAlreadyAppliedApplication();
    setState(() => isLoading = false);
  }

  Map slots = {};

  List getSlots(Map slots) {
    return slots.keys.toList();
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;

    slots = widget.args.marketplace.data;
    businessModel = widget.args.marketplace.clientSite.businessModel.last;
    fetchData();
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
          GestureDetector(
            onTap: () {
              push(NamedRoute.notificationsScreen);
            },
            child: Container(
              margin: EdgeInsets.only(right: dW * 0.04),
              child: const Icon(Icons.notifications),
            ),
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
                  height: dH,
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
                  height: dH - 10,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                    child: SingleChildScrollView(
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
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: const Color(
                                                        0XFF13A088))),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedImageWidget(
                                                widget.args.marketplace
                                                    .vendorAvatar,
                                                boxFit: BoxFit.cover,
                                                width: dW * 0.2,
                                                height: dW * 0.2,
                                              ),
                                            ),
                                          ),
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
                                          title: widget
                                              .args.marketplace.vendername,
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
                                                          (0xffF4B617)),
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
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 14, 187, 124)
                                                          : const Color
                                                              .fromARGB(255,
                                                              214, 159, 20),
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
                                                      .toStringAsFixed(1),
                                                  color: white,
                                                  fontSize: 12,
                                                )
                                              ]),
                                            ),
                                            // Row(
                                            //   children: const [
                                            //     TextWidgetRoboto(
                                            //       title: 'Vintage :~ ',
                                            //       fontWeight: FontWeight.w300,
                                            //       fontSize: 12,
                                            //     ),
                                            //     TextWidgetRoboto(
                                            //       title: '40 Years',
                                            //       fontWeight: FontWeight.w400,
                                            //       fontSize: 12,
                                            //     ),
                                            //   ],
                                            // ),
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
                            padding: EdgeInsets.only(
                                left: dW * 0.04,
                                right: dW * 0.04,
                                top: dW * 0.03,
                                bottom: dW * 0.02),
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
                                              // TextWidget(
                                              //   title:
                                              //       '${language['company']} : ',
                                              //   fontWeight: FontWeight.w300,
                                              //   color: const Color(0xff242E42),
                                              // ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedImageWidget(
                                                  widget.args.marketplace
                                                      .clientSite.avatar,
                                                  boxFit: BoxFit.cover,
                                                  width: dW * 0.05,
                                                  height: dW * 0.05,
                                                ),
                                              ),
                                              SizedBox(
                                                width: dW * 0.015,
                                              ),
                                              Container(
                                                width: dW * 0.23,
                                                child: TextWidget(
                                                  color:
                                                      const Color(0xff242E42),
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  title: widget.args.marketplace
                                                      .clientSite.name,
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
                                      // Column(
                                      //   children: [
                                      //     Row(
                                      //       children: [
                                      //         const TextWidget(
                                      //           title: 'Mindspace : ',
                                      //           fontWeight: FontWeight.w300,
                                      //           color: Color(0xff242E42),
                                      //         ),
                                      //         SizedBox(
                                      //           width: dW * 0.16,
                                      //           child: TextWidget(
                                      //             color: Color(0xff242E42),
                                      //             title: widget.args.marketplace
                                      //                 .clientSite.location,
                                      //             fontWeight: FontWeight.w400,
                                      //             textOverflow:
                                      //                 TextOverflow.ellipsis,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
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
                                    ...getSlots(slots['loginSlot'])
                                        .map(
                                          (time) => Container(
                                            margin: EdgeInsets.only(
                                              right:
                                                  //  i == 5 ? 0 :
                                                  dW * 0.025,
                                              bottom: dW * 0.03,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: dW * 0.02,
                                              right: dW * 0.015,
                                              top: dW * 0.01,
                                              bottom: dW * 0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  // ((i == 3) || (i == 5))
                                                  //     ? const Color(0xffD5FBE0)
                                                  //     :
                                                  const Color(0xffFCF4CB),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: TextWidgetRoboto(
                                              title: time,
                                              color: const Color(0xff505050),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                        .toList()
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
                                    ...getSlots(slots['logoutSlot'])
                                        .map(
                                          (time) => Container(
                                            margin: EdgeInsets.only(
                                              right:
                                                  //  i == 5 ? 0 :
                                                  dW * 0.025,
                                              bottom: dW * 0.03,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: dW * 0.02,
                                              right: dW * 0.015,
                                              top: dW * 0.01,
                                              bottom: dW * 0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  // ((i == 3) || (i == 5))
                                                  //     ? const Color(0xffD5FBE0)
                                                  //     :
                                                  const Color(0xffFCF4CB),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: TextWidgetRoboto(
                                              title: time,
                                              color: const Color(0xff505050),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                        .toList()
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // if (businessModel['type'] == 'SLAB')
                          Container(
                            width: dW,
                            margin: EdgeInsets.only(bottom: dW * 0.03),
                            padding: EdgeInsets.only(
                                left: dW * 0.04,
                                right: dW * 0.04,
                                top: dW * 0.03,
                                bottom: dW * 0.02),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const TextWidget(
                                                  title: 'Business model : ',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                TextWidget(
                                                  title: businessModel['type'] +
                                                      ' ' +
                                                      (businessModel['type'] ==
                                                              'PACKAGE'
                                                          ? (businessModel[
                                                                      'modeldata']
                                                                  as Map)
                                                              .keys
                                                              .toList()[0]
                                                              .toUpperCase()
                                                          : ''),
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
                                      // SizedBox(
                                      //   width: dW * 0.08,
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: dW * 0.01,
                                  ),
                                  const Divider(
                                    color: Color(0xffF4F4F4),
                                    thickness: 1,
                                  ),
                                  SizedBox(height: dW * 0.01),
                                  if (businessModel['type'] == 'SLAB')
                                    ...List.generate(
                                        businessModel['modeldata'].length, (i) {
                                      return BusinessModelRow(
                                          i: i,
                                          data: (businessModel['modeldata']
                                              as List)[i]);
                                    }),
                                  if (businessModel['type'] == 'KM_FARE')
                                    KMFareWidgetRows(
                                        data: businessModel['modeldata']),
                                  if (businessModel['type'] == 'PACKAGE' &&
                                      (businessModel['modeldata'] as Map)
                                              .keys
                                              .toList()[0] ==
                                          'fixed_trip')
                                    TripPackageWidgetRows(
                                        data:
                                            //  {
                                            //   "suv": {
                                            //     "Petrol/Diesel": {"2": 2000, "4": 4000}
                                            //   },
                                            //   "sedan": {
                                            //     "EV": {"2": 2000, "4": 4000},
                                            //     "CNG": {"2": 3000, "4": 5000},
                                            //     "Petrol/Diesel": {"2": 2000, "4": 4000}
                                            //   }
                                            // }
                                            businessModel['modeldata']
                                                ['fixed_trip']),
                                  if (businessModel['type'] == 'PACKAGE' &&
                                      (businessModel['modeldata'] as Map)
                                              .keys
                                              .toList()[0] ==
                                          'fixed_km')
                                    FixedKMPackageWidgetRows(
                                      data: businessModel['modeldata']
                                          ['fixed_km'],
                                    )
                                ]),
                          ),
                          if (user.driver.vendor == null)
                            Container(
                              margin: EdgeInsets.only(
                                  left: dW * 0.15,
                                  right: dW * 0.15,
                                  bottom: dW * 0.2,
                                  top: dW * 0.02),
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
                                buttonColor:
                                    alreadyApplied ? Colors.grey : themeColor,
                                buttonText: alreadyApplied
                                    ? language['alreadyApplied']
                                    : language['applyNow'],
                                onPressed: alreadyApplied
                                    ? () => showSnackbar(
                                        language['youAlreadyApplied'],
                                        themeColor)
                                    : agreementBottomSheet,
                              ),
                            ),
                          SizedBox(height: dH * 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class BusinessModelRow extends StatelessWidget {
  final int i;
  final Map data;
  BusinessModelRow({
    super.key,
    required this.i,
    required this.data,
  });

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late Driver driver;

  num get amount {
    num toReturn = 0;

    final availableData = data['vehicle_type']
            [driver.vehicle.vehicleType.toLowerCase()] ??
        data['vehicle_type']['mini'] ??
        data['vehicle_type']['suv'] ??
        data['vehicle_type']['sedan'];

    final myVehicleFuelType = driver.vehicle.vehicleFuelType;

    if (myVehicleFuelType.contains('Petrol') ||
        myVehicleFuelType.contains('Diesel')) {
      toReturn = availableData['Petrol/Diesel'] ??
          availableData['CNG'] ??
          availableData['EV'];
    }

    toReturn = availableData[myVehicleFuelType] ??
        availableData['Petrol/Diesel'] ??
        availableData['CNG'] ??
        availableData['EV'];
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    driver = Provider.of<AuthProvider>(context).user.driver;

    return Container(
      padding: EdgeInsets.only(bottom: dW * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: dW * 0.025),
                  padding: EdgeInsets.symmetric(
                      horizontal: dW * 0.015, vertical: dW * 0.005),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: themeColor),
                  child: TextWidget(
                    title: i.toString(),
                    color: white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextWidgetRoboto(
                  title:
                      '${data['range']['min']} - ${data['range']['max']} Kms',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ],
            ),
          ),
          Row(
            // crossAxisAlignment:
            //     CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: dW * 0.25,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextWidgetRoboto(
                    title: '\u20b9 ' + convertAmountString(amount.toDouble()),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff464646),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KMFareWidgetRows extends StatelessWidget {
  // final int i;
  final List data;
  KMFareWidgetRows({
    super.key,
    // required this.i,
    required this.data,
  });

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late Driver driver;

  formatVehicleType(String s) {
    return s.substring(0, 1).toUpperCase() + s.substring(1, s.length);
  }

  Widget rowsWidget(Map data) {
    List<Widget> rows = [];
    int i = 1;
    data.forEach((k, v) {
      rows.add(Container(
        padding: EdgeInsets.only(bottom: dW * 0.03),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: dW * 0.025),
                    padding: EdgeInsets.symmetric(
                        horizontal: dW * 0.015, vertical: dW * 0.005),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: themeColor),
                    child: TextWidget(
                      title: i.toString(),
                      // title: '',
                      color: white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextWidgetRoboto(
                    // title: '${formatVehicleType(vehicleType)} $k /KM',
                    title: '$k /KM',
                    // title: '',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ],
              ),
            ),
            Row(
              // crossAxisAlignment:
              //     CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  width: dW * 0.25,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TextWidgetRoboto(
                      title: '\u20b9 ' + convertAmountString(v.toDouble()),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff464646),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
      i++;
    });
    return Column(
      children: rows,
    );
  }

  Widget get nonAvailabeColumn {
    List<Widget> widgets = [];
    data[0].forEach((k, v) {
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: dW * 0.01, bottom: dW * 0.02),
            child: Text(
              formatVehicleType(k),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tS * 15,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          rowsWidget(v),
        ],
      ));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    driver = Provider.of<AuthProvider>(context).user.driver;

    final availableData = data[0][driver.vehicle.vehicleType.toLowerCase()];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (availableData != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: dW * 0.02),
            child: Text(
              driver.vehicle.vehicleType,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tS * 15,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          rowsWidget(availableData),
        ],
        if (availableData == null) ...[
          nonAvailabeColumn,
        ],
      ],
    );
    // return ;
  }
}

class TripPackageWidgetRows extends StatelessWidget {
  // final int i;
  final Map data;
  TripPackageWidgetRows({
    super.key,
    // required this.i,
    required this.data,
  });

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late Driver driver;

  late Map availableData;

  formatVehicleType(String s) {
    if (s == 'suv') {
      return s.toUpperCase();
    } else {
      return s.substring(0, 1).toUpperCase() + s.substring(1, s.length);
    }
  }

  Widget rowsWidget(Map data) {
    List<Widget> parentRows = [];
    int i = 1;
    List<Widget> rows = [];

    data.forEach(
      (fuelType, tripMap) {
        ///
        ///
        i = 1;
        rows = [];
        tripMap.forEach((k, v) {
          rows.add(Container(
            padding: EdgeInsets.only(bottom: dW * 0.03),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: dW * 0.025),
                        padding: EdgeInsets.symmetric(
                            horizontal: dW * 0.015, vertical: dW * 0.005),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: themeColor),
                        child: TextWidget(
                          title: i.toString(),
                          // title: '',
                          color: white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextWidgetRoboto(
                        // title: '${formatVehicleType(vehicleType)} $k /KM',
                        title: '$k trips',
                        // title: '',
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
                Row(
                  // crossAxisAlignment:
                  //     CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: dW * 0.25,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextWidgetRoboto(
                          title: '\u20b9 ' + convertAmountString(v.toDouble()),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff464646),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
          i++;
        });
////

        parentRows.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: dW * 0.005, bottom: dW * 0.02),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8),
                  SizedBox(width: dW * 0.02),
                  Text(
                    fuelType,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: tS * 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            ...rows,
          ],
        ));
      },
    );
    return Column(
      children: parentRows,
    );
  }

  Widget availableColumn(String vehicleType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: dW * 0.02),
          child: Text(
            formatVehicleType(vehicleType),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: tS * 15,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        rowsWidget(availableData),
        // ...widgets
      ],
    );
  }

  Widget get nonAvailabeColumn {
    List<Widget> widgets = [];
    data[0].forEach((k, v) {
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: dW * 0.01, bottom: dW * 0.02),
            child: Text(
              formatVehicleType(k),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tS * 15,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          rowsWidget(v),
        ],
      ));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    driver = Provider.of<AuthProvider>(context).user.driver;

    Map? matchedVechileData = data[driver.vehicle.vehicleType.toLowerCase()];
    String vehicleType = driver.vehicle.vehicleType;

    if (matchedVechileData == null) {
      data.forEach((key, value) {
        if (matchedVechileData == null) {
          vehicleType = key;
          matchedVechileData = value;
        }
      });
    }

    availableData = matchedVechileData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (availableData != null) ...[
          availableColumn(vehicleType),
        ],
        // if (availableData == null) ...[
        //   nonAvailabeColumn,
        // ],
      ],
    );
  }
}

class FixedKMPackageWidgetRows extends StatelessWidget {
  // final int i;
  final Map data;
  FixedKMPackageWidgetRows({
    super.key,
    // required this.i,
    required this.data,
  });

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late Driver driver;

  late Map availableData;

  formatVehicleType(String s) {
    if (s == 'suv') {
      return s.toUpperCase();
    } else {
      return s.substring(0, 1).toUpperCase() + s.substring(1, s.length);
    }
  }

  Widget rowWidget({
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: dW * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                // Container(
                //   margin: EdgeInsets.only(right: dW * 0.025),
                //   padding: EdgeInsets.symmetric(
                //       horizontal: dW * 0.015, vertical: dW * 0.005),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(30),
                //       color: themeColor),
                //   child: TextWidget(
                //     title: i.toString(),
                //     // title: '',
                //     color: white,
                //     fontSize: 12,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                TextWidgetRoboto(
                  // title: '${formatVehicleType(vehicleType)} $k /KM',
                  title: title,
                  // title: '',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ],
            ),
          ),
          Row(
            // crossAxisAlignment:
            //     CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: dW * 0.25,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextWidgetRoboto(
                    title: value,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff464646),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    driver = Provider.of<AuthProvider>(context).user.driver;

    List listData = [];
    data['vehicle_type'].forEach((vehicleType, fuels) {
      fuels.forEach((fuelType, details) {
        listData.add({
          'fuelType': fuelType,
          'vehicleType': vehicleType,
          'fixedRate': details['rate'],
          'extraKmRate': details['km_rate'],
          'extraHrRate': details['hour_rate'], // Assuming a placeholder value
        });
      });
    });

    int j = listData.indexWhere((d) =>
        d['vehicleType'].contains(driver.vehicle.vehicleType.toLowerCase()) &&
        d['fuelType'] == driver.vehicle.vehicleFuelType);
    // d['vehicleType'].contains('suv') && d['fuelType'] == 'CNG');

    if (j != -1) {
      availableData = listData[j];
    } else {
      availableData = listData[0];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Range: ${data['range']} Kms',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tS * 15,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(width: dW * 0.035),
            if (data['hourlyLimit'] != null)
              Text(
                'Hours: ${data['hourlyLimit']} hrs',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: tS * 15,
                  color: Colors.grey.shade800,
                ),
              ),
          ],
        ),
        SizedBox(height: dW * 0.035),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              formatVehicleType(availableData['vehicleType']) + ' - ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tS * 15,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              formatVehicleType(availableData['fuelType']),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tS * 15,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: dW * 0.025),
        rowWidget(
          title: 'Fixed rate',
          value: '\u20b9 ${availableData['fixedRate']}',
        ),
        if (availableData['hourlyLimit'] != null)
          rowWidget(
            title: 'Fixed hours',
            value: '\u20b9 ${availableData['hourlyLimit']}',
          ),
        if (availableData['extraKmRate'] != null)
          rowWidget(
            title: 'Extra KM rate',
            value: '\u20b9 ${availableData['extraKmRate']} /KM',
          ),
        if (availableData['extraHrRate'] != null)
          rowWidget(
            title: 'Extra Hr rate',
            value: '\u20b9 ${availableData['extraHrRate']} /Hr',
          ),
      ],
    );
  }
}
