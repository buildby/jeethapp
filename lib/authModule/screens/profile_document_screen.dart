// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeeth_app/authModule/models/document_model.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/document_provider.dart';
import 'package:jeeth_app/authModule/widgets/document_details_widget.dart';
import 'package:jeeth_app/authModule/widgets/driver_details_btmsheet.dart';
import 'package:jeeth_app/authModule/widgets/driver_doc_bottomsheet.dart';
import 'package:jeeth_app/authModule/widgets/owner_details_widget.dart';
import 'package:jeeth_app/authModule/widgets/owner_documents.dart';
import 'package:jeeth_app/authModule/widgets/vehicleDetails_bottomSheet.dart';
import 'package:jeeth_app/authModule/widgets/vehicleDocuments_bottomSheet.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/cached_image_widget.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_checkbox.dart';
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
  late User user;
  String imgPath = '';
  String ownerImg = '';
  bool isDriverSlide = true;
  String header = 'Driver Documents';
  String subHeader = 'Swipe for Vehicle Details';
  num vehicleDetailsPercentage = 0;
  num vehicleDocPercentage = 0;
  num ownerDocPercentage = 0;
  num ownerDetailsPercentage = 0;
  num driverDocPercentage = 0;
  int selectedFiles = 0;

  num driverDetailsPercentage = 0;

  Map language = {};
  bool showOwnerDetails = true;
  bool isLoading = false;
  bool validateForm1 = false;
  bool driverImgValidation = false;
  bool vehicleImgValidation = false;
  bool isDriverValidateActive = false;
  bool isVehicleValidateActive = false;
  double keybHeight = 0;

  bool validateForm2 = false;
  bool photoRemoved = false;

  List<Doc> documents = [];

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
        // if (isDriverSlide) {
        //   if (imgPath.isNotEmpty) {
        //     photoRemoved = false;
        //   } else {
        //     if (ownerImg.isNotEmpty) {
        //       photoRemoved = false;
        //     }
        //   }
        // }
      });
      pop();
      getAwsSignedUrl();
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
      bool isNetworkImage = false,
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
                border: Border.all(
                    color: isDriverSlide
                        ? isDriverValidateActive
                            ? validateDriverProf
                                ? white
                                : redColor
                            : white
                        : isVehicleValidateActive
                            ? validateVehicleProf
                                ? white
                                : redColor
                            : white,
                    width: 2.5),
                color: backgroundColor ??
                    Theme.of(context).primaryColor.withOpacity(0.2)),
            child: isDriverSlide
                ? imgPath != ''
                    ? Container(
                        width: radius,
                        height: radius,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(imgPath),
                            repeat: ImageRepeat.repeat,
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                        ),
                      )
                    : avatar == null || avatar == ''
                        ? Image.asset(
                            'assets/images/cam.png',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: radius,
                            height: radius,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: isNetworkImage
                                  ? CachedImageWidget(user.driver.avatar)
                                  : Image.file(
                                      File(imgPath),
                                      repeat: ImageRepeat.repeat,
                                      fit: BoxFit.cover,
                                      width: 32,
                                      height: 32,
                                    ),
                            ),
                          )
                : ownerImg != ''
                    ? Container(
                        width: radius,
                        height: radius,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(ownerImg),
                            repeat: ImageRepeat.repeat,
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                        ),
                      )
                    : avatar == null || avatar == ''
                        ? Image.asset(
                            'assets/images/cam.png',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: radius,
                            height: radius,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: isNetworkImage
                                  ? CachedImageWidget(user.driver.vehicleImage)
                                  : Image.file(
                                      File(ownerImg),
                                      repeat: ImageRepeat.repeat,
                                      fit: BoxFit.cover,
                                      width: 32,
                                      height: 32,
                                    ),
                            ),
                          )),
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
                  Text(
                    isDriverSlide ? 'Profile Photo' : 'Vehicle Photo',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: dW * .03),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // if (isDriverSlide
                      //     ? imgPath != '' ||
                      //         (user.driver.avatar != '' && !photoRemoved)
                      //     : ownerImg != '' ||
                      //         (user.driver.vehicleImage != '' && !photoRemoved))
                      //   Container(
                      //     margin: EdgeInsets.only(right: dW * 0.05),
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           if (isDriverSlide) {
                      //             imgPath = '';
                      //             user.driver.avatar = '';
                      //             photoRemoved = true;
                      //           } else {
                      //             ownerImg = '';
                      //             photoRemoved = true;
                      //           }
                      //         });

                      //         pop();
                      //       },
                      //       child: Column(
                      //         children: [
                      //           CircleAvatar(
                      //             radius: dW * .08,
                      //             backgroundColor: Colors.grey.withOpacity(0.4),
                      //             child: const Icon(
                      //               Icons.delete,
                      //               color: Colors.red,
                      //             ),
                      //           ),
                      //           SizedBox(height: dW * .02),
                      //           const Text('Remove '),
                      //           const Text('Photo')
                      //         ],
                      //       ),
                      //     ),
                      //   ),

                      // SizedBox(width: dW * .05),
                      if (isDriverSlide)
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
                      if (isDriverSlide) SizedBox(width: dW * .05),
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
        keybHeight: keybHeight,
        onUpdatePercentage: (percentage) {
          setState(() {
            driverDetailsPercentage = percentage;
          });
        },
      ),
    );
  }

  void driverDocBottomSheet() {
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
      builder: (context) => DriverDocBottomSheetWidget(
        onUpdatePercentage: (percentage) {
          setState(() {
            driverDocPercentage = percentage;
          });
        },
      ),
    ).then((value) {
      setState(() {
        calculateDriverDocPercentage();
      });
    });
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
    ).then((value) {
      setState(() {
        calculateVehicleDetailsPercentage();
      });
    });
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
    ).then((value) {
      setState(() {
        calculateVehicleDocPercentage();
      });
    });
  }

  void ownerDetailsBottomSheet() {
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
      builder: (context) => OwnerDetailsBottomSheetWidget(
        onUpdatePercentage: (percentage) {
          setState(() {
            ownerDetailsPercentage = percentage;
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
    ).then((value) {
      setState(() {
        calculateOwnerDocPercentage();
      });
    });
  }

  bool get validateTab1 {
    // return true;
    setState(() {
      validateForm1 = false;
    });
    if (driverDocPercentage == 100 &&
        driverDetailsPercentage == 100 &&
        (user.driver.avatar.isNotEmpty || imgPath.isNotEmpty)) {
      setState(() {
        validateForm1 = true;
      });
    }
    return validateForm1;
  }

  bool get validateDriverProf {
    // return true;

    if (user.driver.avatar.isNotEmpty || imgPath.isNotEmpty) {
      setState(() {
        driverImgValidation = true;
      });
    } else {
      setState(() {
        driverImgValidation = false;
      });
    }
    return driverImgValidation;
  }

  bool get validateVehicleProf {
    // return true;

    if (user.driver.vehicleImage.isNotEmpty || ownerImg.isNotEmpty) {
      setState(() {
        vehicleImgValidation = true;
      });
    } else {
      setState(() {
        vehicleImgValidation = false;
      });
    }
    return vehicleImgValidation;
  }

  bool get validateTab2 {
    // return true;
    setState(() {
      validateForm2 = false;
    });
    if (showOwnerDetails == false
        ? ownerDocPercentage == 100 &&
            ownerDetailsPercentage == 100 &&
            vehicleDetailsPercentage == 100 &&
            vehicleDocPercentage == 100 &&
            (user.driver.vehicleImage.isNotEmpty || ownerImg.isNotEmpty)
        : vehicleDetailsPercentage == 100 &&
            vehicleDocPercentage == 100 &&
            (user.driver.vehicleImage.isNotEmpty || ownerImg.isNotEmpty)) {
      setState(() {
        validateForm2 = true;
      });
    }
    return validateForm2;
  }

  fetchDriverDocuments() async {
    final response = await Provider.of<DocumentProvider>(context, listen: false)
        .getDriverDocuments(driver_id: user.driver.id.toString());
    if (response['result'] != 'success') {
      showSnackbar('something went wrong');
    }
  }

  fetchVehicleConfigs() async {
    final response = await Provider.of<AuthProvider>(context, listen: false)
        .fetchVehicleConfigs();
    if (response['result'] == 'success') {
    } else {
      showSnackbar('something went wrong');
    }
  }

  Widget get tab1 {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
                          '${double.parse(driverDocPercentage.toStringAsFixed(1)).truncate().toString()}%',
                      onTap: () => driverDocBottomSheet(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          validateTab1
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
                left: dW * 0.12,
                right: dW * 0.12,
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
              buttonColor: (validateTab1 && validateDriverProf)
                  ? themeColor
                  : Colors.grey,
              buttonText: language['next'],
              onPressed: () {
                setState(() {
                  isDriverValidateActive = true;
                });

                if (validateTab1) {
                  //  Provider.of<AuthProvider>(context, listen: false)
                  //     .createVehicleConfigs()
                  _tabController.animateTo(_tabController.index + 1);
                } else {
                  if (user.driver.avatar.isEmpty && imgPath.isEmpty) {
                    showSnackbar(language['enterDriverPhoto']);
                  } else {
                    showSnackbar(language['enterFields']);
                  }
                }
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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: dW * 0.03),
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
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dW * 0.04,
                    ),
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
                            // setState(() {
                            //   showOwnerDetails = !showOwnerDetails;
                            //   updateHeaderName();
                            // });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: dW * 0.05),
                            padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.03, vertical: dW * 0.04),
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
                                const TextWidget(title: 'I am the cab owner'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showOwnerDetails = true;
                                          updateHeaderName();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(title: language['yes']),
                                          SizedBox(
                                            width: dW * 0.01,
                                          ),
                                          CustomCheckbox(
                                            value: showOwnerDetails == true,
                                            activeColor: themeColor,
                                            size: 18,
                                            onChanged: (newValue) {
                                              setState(() {
                                                showOwnerDetails = true;
                                                updateHeaderName();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: dW * 0.02,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showOwnerDetails = false;
                                          updateHeaderName();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(title: language['no']),
                                          SizedBox(
                                            width: dW * 0.01,
                                          ),
                                          CustomCheckbox(
                                            value: showOwnerDetails == false,
                                            activeColor: themeColor,
                                            size: 18,
                                            onChanged: (newValue) {
                                              setState(() {
                                                showOwnerDetails = false;
                                                updateHeaderName();
                                              });
                                            },
                                          )
                                          // Checkbox(
                                          //   value: showOwnerDetails == false,
                                          //   activeColor: themeColor,
                                          //   visualDensity:
                                          //       VisualDensity.compact,
                                          //   shape: const CircleBorder(),
                                          //   onChanged: (newValue) {
                                          //     setState(() {
                                          //       showOwnerDetails = false;
                                          //       updateHeaderName();
                                          //     });
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        !showOwnerDetails
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: dW * 0.025,
                                  ),
                                  DocumentDetailWidget(
                                    name: language['ownerDetails'],
                                    percentage:
                                        '${double.parse(ownerDetailsPercentage.toStringAsFixed(1)).truncate().toString()}%',
                                    onTap: () => ownerDetailsBottomSheet(),
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
                  )
                ],
              ),
            ),
          ),
          validateTab2
              ? const SizedBox()
              : Container(
                  margin: EdgeInsets.only(top: dW * 0.04),
                  child: Row(
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
                ),
          Container(
            margin: EdgeInsets.only(
                left: dW * 0.12,
                right: dW * 0.12,
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
                setState(() {
                  isVehicleValidateActive = true;
                });
                if (validateTab2) {
                  push(NamedRoute.bottomNavBarScreen,
                      arguments: BottomNavArguments());
                } else {
                  if (user.driver.vehicleImage.isEmpty && ownerImg.isEmpty) {
                    showSnackbar(language['enterVehiclePhoto']);
                  } else {
                    showSnackbar(language['enterFields']);
                  }
                }
              },
              buttonColor: validateTab2 ? buttonColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  anyDriverDocExists(List<Doc> docs) {
    for (var i = 0; i < docs.length; i++) {
      if (docs[i].filename == 'Owner Aadhar Card') {
        setState(() {
          showOwnerDetails = false;
        });
        return;
      }
      if (docs[i].filename == 'Owner Lease Agreement') {
        setState(() {
          showOwnerDetails = false;
        });
        return;
      }
    }
    setState(() {
      showOwnerDetails = true;
    });
  }

  fetchData() async {
    setState(() => isLoading = true);
    // await fetchVehicleModels();
    // await fetchVehicleMakes();
    await fetchVehicleConfigs();
    await fetchDriverDocuments();
    await calculateOwnerDocPercentage();
    await calculateDriverDocPercentage();
    await calculateVehicleDocPercentage();

    anyDriverDocExists(
        Provider.of<DocumentProvider>(context, listen: false).documents);

    setState(() => isLoading = false);
  }

  void updateHeaderName() {
    if (_tabController.index == 0) {
      header = language['driverDetails'];
      subHeader = language['swipeForVehicleDetails'];
      isDriverSlide = true;
    } else {
      header = !showOwnerDetails
          ? language['vehicle/OwnerDetails']
          : language['vehicleDetails'];
      subHeader = language['swipeForDriverDetails'];
      isDriverSlide = false;
    }
  }

  String get headerName {
    _tabController.addListener(() {
      setState(() {
        updateHeaderName();
      });
    });
    return header;
  }

  getAwsSignedUrl() async {
    final fileName =
        isDriverSlide ? imgPath.split('/').last : ownerImg.split('/').last;
    final filePath = isDriverSlide ? imgPath : ownerImg;

    final contentType = determineContentType(PlatformFile(
      name: fileName,
      path: filePath,
      size: 0,
    ));

    final response =
        await Provider.of<AuthProvider>(context, listen: false).getAwsSignedUrl(
            fileName: fileName,
            // isDriverSlide ? imgPath.split('/').last : ownerImg.split('/').last,
            filePath: filePath,
            //  isDriverSlide ? imgPath : ownerImg,
            contentType: contentType
            // files: {'file': selectedPhoto},
            );
    if (response['result'] == 'success') {
      final avatar = response['data']['signedUrl'].split('?')[0];

      final updateProfileRes =
          await Provider.of<AuthProvider>(context, listen: false)
              .editDriverProfile(
                  body: isDriverSlide
                      ? {
                          'driver': {'avatar': avatar},
                          'id': user.driver.id.toString()
                        }
                      : {
                          'owner': {'vehicleImage': avatar},
                          'id': user.driver.id.toString()
                        },
                  id: user.driver.id.toString());

      if (updateProfileRes['result'] != 'success') {
        showSnackbar('Failed to update profile');
      }
    } else {
      showSnackbar(response['message']);
    }
  }

  double calculateOwnerDetailsPercentage() {
    user = Provider.of<AuthProvider>(context, listen: false).user;

    int totalFields = 3;

    int selectedDocumentCount = 0;

    if (user.driver.ownerName.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (user.driver.ownerPhoneNumber.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.ownerAddress.isNotEmpty) {
      selectedDocumentCount++;
    }

    return ownerDetailsPercentage = (selectedDocumentCount / totalFields) * 100;
  }

  double calculateVehicleDetailsPercentage() {
    user = Provider.of<AuthProvider>(context, listen: false).user;

    int totalFields = 5;

    int selectedDocumentCount = 0;

    if (user.driver.vehicle.vehicleMake.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (user.driver.vehicle.vehicleModel.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.vehicle.vehicleType.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (user.driver.vehicle.vehicleYear.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (user.driver.vehicle.vehicleNumber.isNotEmpty) {
      selectedDocumentCount++;
    }

    return vehicleDetailsPercentage =
        (selectedDocumentCount / totalFields) * 100;
  }

  double calculateDriverDetailsPercentage() {
    user = Provider.of<AuthProvider>(context, listen: false).user;

    int totalFields = 8;

    int selectedDocumentCount = 0;

    if (user.driver.name.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (user.driver.email.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.dob != null) {
      selectedDocumentCount++;
    }

    if (user.driver.address.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.gender.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (user.driver.bankName.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.accNumber.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.ifscCode.isNotEmpty) {
      selectedDocumentCount++;
    }

    return driverDetailsPercentage =
        (selectedDocumentCount / totalFields) * 100;
  }

  calculateDriverDocPercentage() {
    documents = Provider.of<DocumentProvider>(context, listen: false).documents;

    int totalFields = 5;

    int selectedDocumentCount = 0;

    for (int i = 0; i < documents.length; i++) {
      if (documents[i].filename == 'Aadhar Card') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Pan Card') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'License') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Police Verification Certificate') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Bank Passbook/Cancelled Cheque/Statement') {
        selectedDocumentCount++;
      }
    }

    return driverDocPercentage = (selectedDocumentCount / totalFields) * 100;
  }

  calculateOwnerDocPercentage() {
    documents = Provider.of<DocumentProvider>(context, listen: false).documents;

    int totalFields = 2;

    int selectedDocumentCount = 0;
    for (var i = 0; i < documents.length; i++) {
      if (documents[i].filename == 'Owner Aadhar Card') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Owner Lease Agreement') {
        selectedDocumentCount++;
      }
    }
    return ownerDocPercentage = (selectedDocumentCount / totalFields) * 100;
  }

  calculateVehicleDocPercentage() {
    documents = Provider.of<DocumentProvider>(context, listen: false).documents;

    int totalFields = 5;
    int selectedDocumentCount = 0;

    for (var i = 0; i < documents.length; i++) {
      if (documents[i].filename == 'Vehicle RC') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Vehicle Fitness') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Vehicle Permit') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Vehicle Insurance') {
        selectedDocumentCount++;
      }
      if (documents[i].filename == 'Vehicle PUC') {
        selectedDocumentCount++;
      }
    }

    return vehicleDocPercentage = (selectedDocumentCount / totalFields) * 100;
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;
    calculateDriverDetailsPercentage();
    calculateVehicleDetailsPercentage();

    documents = Provider.of<DocumentProvider>(context, listen: false).documents;

    fetchData();

    _tabController = TabController(vsync: this, length: 2);
    calculateOwnerDetailsPercentage();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    keybHeight = MediaQuery.of(context).viewInsets.bottom;

    documents = Provider.of<DocumentProvider>(context).documents;

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
                                          isNetworkImage: isDriverSlide
                                              ? user.driver.avatar != ''
                                              : user.driver.vehicleImage != '',
                                          avatar: isDriverSlide
                                              ? user.driver.avatar != ''
                                                  ? user.driver.avatar
                                                  : imgPath
                                              : user.driver.vehicleImage != ''
                                                  ? user.driver.vehicleImage
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
                                      title: headerName,
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
                      child: IgnorePointer(
                        child: TabBar(
                          physics: validateTab1
                              ? const BouncingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          indicator: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          splashBorderRadius: BorderRadius.circular(8),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: const MaterialStatePropertyAll(
                              Colors.transparent),
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
                    ),
                    Flexible(
                      child: TabBarView(
                        physics: validateTab1
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
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
