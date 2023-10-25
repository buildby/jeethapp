import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/driver_details_provider.dart';
import 'package:jeeth_app/authModule/widgets/custon_radio_button_bottomsheet.dart';
import 'package:jeeth_app/authModule/widgets/file_picker_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class DriverDetailsBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;
  DriverDetailsBottomSheetWidget({super.key, required this.onUpdatePercentage});

  @override
  DriverDetailsBottomSheetWidgetState createState() =>
      DriverDetailsBottomSheetWidgetState();
}

class DriverDetailsBottomSheetWidgetState
    extends State<DriverDetailsBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  String? selectedGender;
  String? selectedBank;

  String? selectedVehicleType;
  String? selectedVehicleMake;
  String vehicleNumber = '';
  List<PlatformFile> selectedFiles = [];
  FocusNode nameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode ifscFocus = FocusNode();
  FocusNode confirmAccFocus = FocusNode();
  FocusNode accFocus = FocusNode();

  DateTime? _selectedDate;
  String? selectedGenderUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController confirmAccNumberController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  // FocusNode nameFocus = FocusNode();
  // FocusNode priceFocus = FocusNode();

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2040),
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //         colorScheme: const ColorScheme.dark(
      //           primary: Colors.deepPurple,
      //           onPrimary: Colors.white,
      //           surface: white,
      //           // Colors.blueGrey,
      //           onSurface: Colors.black,
      //           //  Colors.yellow,
      //         ),
      //         dialogBackgroundColor: themeColor
      //         // Colors.blue[500],
      //         ),
      //     child: child!,
      //   );
      // }
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateController
        ..text = DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  String selectGender = 'Select gender';
  void updateSelectedGender(String count) {
    setState(() {
      selectGender = count;
    });
  }

  String selectBank = 'Select bank';
  void updateSelectedBank(String count) {
    setState(() {
      selectBank = count;
    });
  }

  String? validateDob(String value) {
    if (value.isEmpty) {
      return 'Please enter your date of birth';
    }
    return null;
  }

  void genderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: RadioBtnBtmSheet(
          updateSelectedCount: updateSelectedGender,
          selecteditem: selectedGender,
          storedSelectedCount: selectGender,
          entries: const ['Male', 'Female', 'Others'],
          title: 'selectGender',
        ),
      ),
    );
  }

  void bankBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: RadioBtnBtmSheet(
          updateSelectedCount: updateSelectedBank,
          selecteditem: selectedBank,
          storedSelectedCount: selectedBank,
          entries: const ['BOI', 'SBI', 'PNB'],
          title: 'selectBank',
        ),
      ),
    );
  }

  double calculatePercentageFilled() {
    int totalFields = 8;

    int selectedDocumentCount = selectedFiles.length;

    if (nameController.text.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (dateController.text.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (addressController.text.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (selectGender != 'Select gender') {
      selectedDocumentCount++;
    }
    if (selectBank != 'Select bank') {
      selectedDocumentCount++;
    }

    if (accNumberController.text.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (confirmAccNumberController.text.isNotEmpty) {
      selectedDocumentCount++;
    }
    if (ifscController.text.isNotEmpty) {
      selectedDocumentCount++;
    }

    return (selectedDocumentCount / totalFields) * 100;
  }

  void saveForm() {
    double percentageFilled = calculatePercentageFilled();

    widget.onUpdatePercentage(percentageFilled);
    pop();
  }

  @override
  void initState() {
    super.initState();

    fetchData();

    final driverDetailsProvider =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    if (driverDetailsProvider.driverDetails.isNotEmpty) {
      final existingData = driverDetailsProvider.driverDetails[0];
      selectedGender = existingData.vehicleModel;
      selectedVehicleType = existingData.vehicleType;
      selectedVehicleMake = existingData.vehicleMake;
      vehicleNumber = existingData.vehicleNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Container(
        height: nameFocus.hasFocus || addressFocus.hasFocus
            ? dH * 0.95
            : ifscFocus.hasFocus ||
                    confirmAccFocus.hasFocus ||
                    accFocus.hasFocus
                ? dH * 3
                : dW * 1.4,
        padding: EdgeInsets.symmetric(
            vertical: dW * horizontalPaddingFactor,
            horizontal: dW * horizontalPaddingFactor),
        child:
            // Column(
            //   children: [
            //     FilePickerWidget(
            //         onFileSelected: (file) {
            //           if (file != null) {
            //             // print('Selected file: ${file.name}');
            //           } else {
            //             print('No file selected.');
            //           }
            //         },
            //         ),
            //   ],
            // ),
            Column(
          children: [
            Divider(
              indent: dW * 0.27,
              endIndent: dW * 0.27,
              color: Colors.black,
              thickness: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: dW * 0.06,
                    ),
                    CustomTextFieldWithLabel(
                        controller: nameController,
                        focusNode: nameFocus,
                        label: language['name'],
                        hintText: language['name']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: CustomTextFieldWithLabel(
                          label: language['dob'],
                          hintText: language['dob'],
                          controller: dateController,
                          borderColor: themeColor,
                          labelColor: Colors.black,
                          textCapitalization: TextCapitalization.words,
                          validator: validateDob,
                          suffixIcon: Container(
                            padding: EdgeInsets.all(dW * 0.02),
                            margin: EdgeInsets.only(right: dW * 0.02),
                            child: const AssetSvgIcon(
                              'calendar',
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    CustomTextFieldWithLabel(
                        controller: addressController,
                        focusNode: addressFocus,
                        label: language['fullAddress'],
                        hintText: language['fullAddress']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    Row(
                      children: [
                        TextWidget(
                          title: language['gender'],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        const TextWidget(
                          title: '*',
                          color: redColor,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => genderBottomSheet(context),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: themeColor)),
                        padding: EdgeInsets.symmetric(
                            vertical: dW * 0.037, horizontal: dW * 0.04),
                        margin: EdgeInsets.symmetric(vertical: dW * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextWidget(
                                title:
                                    //  selectedVehicleModel ??
                                    selectGender,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            AssetSvgIcon(
                              'down_arrow',
                              width: dW * 0.05,
                              color: blackColor3,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    Row(
                      children: [
                        TextWidget(
                          title: language['bankName'],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        const TextWidget(
                          title: '*',
                          color: redColor,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => bankBottomSheet(context),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: themeColor)),
                        padding: EdgeInsets.symmetric(
                            vertical: dW * 0.037, horizontal: dW * 0.04),
                        margin: EdgeInsets.symmetric(vertical: dW * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextWidget(
                                title:
                                    //  selectedVehicleModel ??
                                    selectBank,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            AssetSvgIcon(
                              'down_arrow',
                              width: dW * 0.05,
                              color: blackColor3,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    CustomTextFieldWithLabel(
                        controller: accNumberController,
                        focusNode: accFocus,
                        obscureText: true,
                        maxLines: 1,
                        label: language['accNumber'],
                        hintText: language['accNumber']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    CustomTextFieldWithLabel(
                        controller: confirmAccNumberController,
                        focusNode: confirmAccFocus,
                        // obscureText: true,
                        maxLines: 1,
                        label: language['confimrAccNumber'],
                        hintText: language['confimrAccNumber']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    CustomTextFieldWithLabel(
                        controller: ifscController,
                        focusNode: ifscFocus,
                        label: language['ifscCode'],
                        hintText: language['ifscCode']),
                    SizedBox(
                      height: ifscFocus.hasFocus ||
                              confirmAccFocus.hasFocus ||
                              accFocus.hasFocus
                          ? dW * 0.4
                          : dW * 0.04,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: dW * 0.05,
                bottom: dW * 0.02,
                left: dW * 0.1,
                right: dW * 0.1,
              ),
              child: CustomButton(
                width: dW,
                height: dW * 0.15,
                radius: 21,
                buttonText: language['save'],
                onPressed: saveForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
