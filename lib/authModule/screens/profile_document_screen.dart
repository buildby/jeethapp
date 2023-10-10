import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/document_details_widget.dart';
import 'package:jeeth_app/authModule/widgets/driver_details_bottomsheet.dart';
import 'package:jeeth_app/authModule/widgets/owner_documents.dart';
import 'package:jeeth_app/authModule/widgets/vehicleDetails_bottomSheet.dart';
import 'package:jeeth_app/authModule/widgets/vehicleDocuments_bottomSheet.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/bottom_aligned_widget.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class ProfileDocumentsScreen extends StatefulWidget {
  const ProfileDocumentsScreen({Key? key}) : super(key: key);

  @override
  ProfileDocumentsScreenState createState() => ProfileDocumentsScreenState();
}

class ProfileDocumentsScreenState extends State<ProfileDocumentsScreen>
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
  final TextEditingController _nameEditingController = TextEditingController();
  late TabController _tabController;

  pickImage(ImageSource source) async {
    try {
      ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: source);

      setState(() {
        isDriverSlide
            ? imgPath = image?.path ?? ''
            : ownerImg = image?.path ?? '';
      });
      pop();
      return image;
    } catch (e) {
      return null;
    }
  }

  Widget getProfilePic(
      {required BuildContext context,
      required String? name,
      required String? avatar,
      required double radius,
      Color? backgroundColor,
      double fontSize = 18,
      FontWeight? fontWeight,
      Color? fontColor,
      required double tS}) {
    _nameEditingController.addListener(() {
      setState(() {});
    });

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: radius,
          height: radius,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ??
                  Theme.of(context).primaryColor.withOpacity(0.2)),
          child: avatar == null || avatar == ''
              ? Image.asset(
                  'assets/images/profile.jpeg',
                  fit: BoxFit.cover,
                )
              : Container(
                  width: radius,
                  height: radius,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      File(isDriverSlide ? imgPath : ownerImg),
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
        ),
        Container(
          padding: EdgeInsets.all(dW * 0.015),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: buttonColor,
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 8,
          ),
        )
      ],
    );
  }

  imagePicker(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (BuildContext context) {
          return SizedBox(
            height: dH * .2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dW * .05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: dW * .02),
                  const Text(
                    'Profile Photo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: dW * .03),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isDriverSlide ? imgPath != '' : ownerImg != '')
                        Container(
                          margin: EdgeInsets.only(right: dW * 0.05),
                          child: GestureDetector(
                            onTap: () {
                              setState(() =>
                                  isDriverSlide ? imgPath = '' : ownerImg = '');

                              pop();
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: dW * .08,
                                  backgroundColor: Colors.grey.withOpacity(0.4),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: dW * .02),
                                const Text('Remove '),
                                const Text('Photo')
                              ],
                            ),
                          ),
                        ),
                      // SizedBox(width: dW * .05),
                      GestureDetector(
                        onTap: () => pickImage(ImageSource.gallery),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: dW * .08,
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              child: const Icon(
                                Icons.image,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(height: dW * .02),
                            const Text('Gallery')
                          ],
                        ),
                      ),
                      SizedBox(width: dW * .05),
                      GestureDetector(
                        onTap: () => pickImage(ImageSource.camera),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: dW * .08,
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: dW * .02),
                            const Text('Camera')
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void driverDetailsBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      // enableDrag: true,
      // constraints: BoxConstraints(maxHeight: dH),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => DriverDetailsBottomSheetWidget(
        onUpdatePercentage: (percentage) {
          setState(() {
            driverDetailsPercentage = percentage;
          });
        },
      ),
    );
  }

  void vehicleDetailsBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      // enableDrag: true,
      // constraints: BoxConstraints(maxHeight: dH),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => VehicleDetailsBottomSheetWidget(
        onUpdatePercentage: (percentage) {
          setState(() {
            vehicleDetailsPercentage = percentage;
          });
        },
      ),
    );
  }

  void vehicleDocumentsBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      // enableDrag: true,
      constraints: BoxConstraints(maxHeight: dH * 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => VehicleDocumentsBottomSheetWidget(
        onUpdatePercentage: (percentage) {
          setState(() {
            vehicleDocPercentage = percentage;
          });
        },
      ),
    );
  }

  void ownerDocumentsBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      // enableDrag: true,
      // constraints: BoxConstraints(maxHeight: dH * 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => OwnerDocumentsBottomSheetWidget(
        onUpdatePercentage: (percentage) {
          setState(() {
            ownerDocPercentage = percentage;
          });
        },
      ),
    );
  }

  bool get validate {
    setState(() {
      validateForm = false;
    });
    if (vehicleDetailsPercentage == 100 &&
        // vehicleDocPercentage == 100 &&
        // ownerDocPercentage == 100 &&
        driverDetailsPercentage == 100) {
      setState(() {
        validateForm = true;
      });
    }
    return validateForm;
  }

  Widget get tab1 {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: dW * 0.03, bottom: dW * 0.5),
            padding: EdgeInsets.symmetric(
                horizontal: dW * 0.04, vertical: dW * 0.05),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -5))
              ],
            ),
            child: Column(
              children: [
                DocumentDetailWidget(
                  name: language['driverDetails'],
                  percentage:
                      '${double.parse(driverDetailsPercentage.toStringAsFixed(1)).truncate().toString()}%',
                  onTap: () => driverDetailsBottomSheet(),
                ),
                SizedBox(
                  height: dW * 0.025,
                ),
                DocumentDetailWidget(
                  name: language['driverDocuments'],
                  percentage:
                      '${double.parse(vehicleDocPercentage.toStringAsFixed(1)).truncate().toString()}%',
                  onTap: () => vehicleDocumentsBottomSheet(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: dW * 0.01),
                padding: EdgeInsets.symmetric(
                    horizontal: dW * 0.02, vertical: dW * 0.01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xffBFBFBF)),
                child: const AssetSvgIcon(
                  'exclaimation',
                  height: 10,
                ),
              ),
              TextWidget(
                title: language['profileIncomplete'],
                color: const Color(0xff242E42),
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                left: dW * 0.15,
                right: dW * 0.15,
                bottom: dW * 0.1,
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
              height: dW * 0.15,
              radius: 21,
              buttonText: language['next'],
              onPressed: () {
                _tabController.animateTo(_tabController.index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get tab2 {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: dW * 0.03, bottom: dW * 0.03),
              padding: EdgeInsets.symmetric(
                  horizontal: dW * 0.04, vertical: dW * 0.05),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, -5))
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showOwnerDetails = !showOwnerDetails;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: dW * 0.03),
                      padding: EdgeInsets.only(
                          left: dW * 0.03, bottom: dW * 0.02, top: dW * 0.02),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xffEFEFF4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(title: 'I am owner'),
                          Checkbox(
                            // title: const TextWidget(title: 'I am owner'),
                            value: showOwnerDetails,
                            activeColor: themeColor,
                            visualDensity: VisualDensity.compact,
                            // controlAffinity: ListTileControlAffinity.trailing,
                            // contentPadding: EdgeInsets.all(0),
                            shape: const CircleBorder(),
                            onChanged: (newValue) {
                              setState(() {
                                showOwnerDetails = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  DocumentDetailWidget(
                    name: language['vehicleDetails'],
                    percentage:
                        '${double.parse(vehicleDetailsPercentage.toStringAsFixed(1)).truncate().toString()}%',
                    onTap: () => vehicleDetailsBottomSheet(),
                  ),
                  SizedBox(
                    height: dW * 0.025,
                  ),
                  DocumentDetailWidget(
                    name: language['vehicleDocuments'],
                    percentage:
                        '${double.parse(vehicleDocPercentage.toStringAsFixed(1)).truncate().toString()}%',
                    onTap: () => vehicleDocumentsBottomSheet(),
                  ),
                  showOwnerDetails
                      ? Column(
                          children: [
                            SizedBox(
                              height: dW * 0.025,
                            ),
                            DocumentDetailWidget(
                              name: language['ownerDetails'],
                              percentage: '100%',
                            ),
                            SizedBox(
                              height: dW * 0.025,
                            ),
                            DocumentDetailWidget(
                              name: language['ownerDocuments'],
                              percentage:
                                  '${double.parse(ownerDocPercentage.toStringAsFixed(1)).truncate().toString()}%',
                              onTap: () => ownerDocumentsBottomSheet(),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            validate
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: dW * 0.01),
                        padding: EdgeInsets.symmetric(
                            horizontal: dW * 0.02, vertical: dW * 0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xffBFBFBF)),
                        child: const AssetSvgIcon(
                          'exclaimation',
                          height: 10,
                        ),
                      ),
                      TextWidget(
                        title: language['profileIncomplete'],
                        color: const Color(0xff242E42),
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ],
                  ),
            Container(
              margin: EdgeInsets.only(
                  left: dW * 0.15,
                  right: dW * 0.15,
                  bottom: dW * 0.1,
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
                height: dW * 0.15,
                radius: 21,
                buttonText: language['next'],
                onPressed: validate
                    ? () => push(NamedRoute.bottomNavBarScreen,
                        arguments: BottomNavArguments())
                    : () {},
                buttonColor: validate ? buttonColor : Colors.grey,
              ),
            ),
          ],
        ),
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
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          header = language['driverDetails'];
          subHeader = language['swipeForVehicleDetails'];
          isDriverSlide = true;
          validate;
        } else {
          header = language['vehicle/OwnerDetails'];
          subHeader = language['swipeForDriverDetails'];
          isDriverSlide = false;
          validate;
        }
      });
    });

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
                      child: TextWidget(
                        title: language['profile/Documents'],
                        fontWeight: FontWeight.w600,
                        color: white,
                        fontSize: 39,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
                      child: Stack(
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
                                horizontal: dW * 0.05, vertical: dW * 0.05),
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
                                    GestureDetector(
                                      onTap: () => imagePicker(context),
                                      child: getProfilePic(
                                          context: context,
                                          // backgroundColor: blackColor3,
                                          name: _nameEditingController.text,
                                          avatar: isDriverSlide
                                              ? imgPath
                                              : ownerImg,
                                          radius: 50,
                                          fontSize: 26,
                                          tS: tS),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: dW * 0.04,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: dW * 0.01,
                                    ),
                                    TextWidget(
                                      title: header,
                                      color: const Color(0xff242E42),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                    SizedBox(
                                      height: dW * 0.02,
                                    ),
                                    TextWidget(
                                      title: subHeader,
                                      color: const Color(0xffB7B7B7),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: dW * 0.06, horizontal: dW * 0.35),
                      decoration: BoxDecoration(
                          color: const Color(0xffEFEFF4),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]),
                      child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        indicator: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashBorderRadius: BorderRadius.circular(8),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        tabs: [
                          Tab(
                            height: dW * .015,
                            child: const Text(
                              '',
                            ),
                          ),
                          Tab(
                            height: dW * .015,
                            child: const Text(
                              '',
                            ),
                          ),
                        ],
                        controller: _tabController,
                      ),
                    ),
                    Flexible(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: _tabController,
                        children: [
                          tab1,
                          tab2,
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
