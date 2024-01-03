import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/custon_radio_button_bottomsheet.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

import '../providers/marketplace_provider.dart';

class DriverDetailsBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;
  final double keybHeight;
  const DriverDetailsBottomSheetWidget(
      {super.key, required this.onUpdatePercentage, required this.keybHeight});

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
  bool isIfsc = false;
  String? selectedGender;
  String? selectedBank;

  String? selectedVehicleType;
  String? selectedVehicleMake;
  String vehicleNumber = '';
  List<PlatformFile> selectedFiles = [];
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  FocusNode addressFocus = FocusNode();
  FocusNode ifscFocus = FocusNode();
  FocusNode confirmAccFocus = FocusNode();
  FocusNode accFocus = FocusNode();
  bool isEmailValidate = false;

  DateTime? _selectedDate;
  String? selectedGenderUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController confirmAccNumberController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late User user;

  bool ifscInvalid = false;

  getBankName() async {
    setState(() => isIfsc = true);

    final response =
        await Provider.of<MarketplaceProvider>(context, listen: false)
            .getBankName(ifsc: ifscController.text);
    if (response is String) {
      ifscInvalid = true;
    } else {
      selectBank = response['BANK'];
      ifscInvalid = false;
    }
    setState(() => isIfsc = false);
    return response;
  }

  _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime firstDate = currentDate.subtract(const Duration(days: 18 * 365));

    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? firstDate,
      firstDate: DateTime(1950),
      lastDate: firstDate,
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

  String? validateConfirmAccNumber(String value) {
    if (confirmAccNumberController.text != accNumberController.text) {
      return 'Please enter same account number';
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter email address';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid email address';
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

    if (selectGender != 'Select gender') {
      selectedDocumentCount++;
    }
    if (selectBank != 'Select bank') {
      selectedDocumentCount++;
    }

    if (user.driver.accNumber.isNotEmpty) {
      selectedDocumentCount++;
    }

    if (user.driver.ifscCode.isNotEmpty) {
      selectedDocumentCount++;
    }

    return (selectedDocumentCount / totalFields) * 100;
  }

  bool get validate {
    String name = nameController.text;
    String email = emailController.text;
    String dob = dateController.text;
    if (accNumberController.text != confirmAccNumberController.text ||
        accNumberController.text.isEmpty ||
        confirmAccNumberController.text.isEmpty ||
        ifscController.text.isEmpty ||
        name.isEmpty ||
        email.isEmpty ||
        dob.isEmpty ||
        selectBank == 'Select bank' ||
        selectBank.isEmpty ||
        selectGender == 'Select gender' ||
        selectGender.isEmpty) {
      return false;
    }

    return true;
  }

  editProfile() async {
    bool isValid =
        _formKey.currentState!.validate() && (selectGender != 'Select gender');

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);
    final Map<String, String> body = {
      'id': user.driver.id.toString(),
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      'bankName': selectBank,
      'accNumber': accNumberController.text.trim(),
      'ifscCode': ifscController.text.trim(),
      "address": addressController.text.trim(),
      'gender': selectGender,
      'dob': _selectedDate.toString(),
      // "avatar": imgPath,
    };

    // if (imgPath != '') {
    //   files["avatar"] = imgPath;
    // }

    final response = await Provider.of<AuthProvider>(context, listen: false)
        .editDriverProfile(
            body: {'driver': body}, id: user.driver.id.toString());
    setState(() => isLoading = false);

    if (response['result'] == 'success') {
      double percentageFilled = calculatePercentageFilled();

      widget.onUpdatePercentage(percentageFilled);
      pop();
    } else {
      showSnackbar(language[response['message']]);
    }
  }

  void saveForm() {
    double percentageFilled = calculatePercentageFilled();

    widget.onUpdatePercentage(percentageFilled);
    pop();
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;

    nameController.text = user.driver.name;
    emailController.text = user.driver.email;
    addressController.text = user.driver.address;
    accNumberController.text = user.driver.accNumber;
    confirmAccNumberController.text = user.driver.accNumber;
    ifscController.text = user.driver.ifscCode;
    selectBank = user.driver.bankName == '' ? selectBank : user.driver.bankName;
    _selectedDate = (user.driver.dob);
    dateController.text =
        _selectedDate != null ? DateFormat.yMMMd().format(_selectedDate!) : '';
    selectGender = user.driver.gender == '' ? selectGender : user.driver.gender;

    calculatePercentageFilled();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    // ignore: deprecated_member_use
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    // final bankName =
    //     Provider.of<MarketplaceProvider>(context, listen: false).bankName;

    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Container(
        // height: nameFocus.hasFocus || addressFocus.hasFocus
        //     ? dH * 0.95
        //     : ifscFocus.hasFocus ||
        //             confirmAccFocus.hasFocus ||
        //             accFocus.hasFocus
        //         ? dH * 3
        //         : dW * 1.4,
        height: dH * 0.7,
        padding: EdgeInsets.only(
          top: dW * horizontalPaddingFactor,
          bottom: (dW * horizontalPaddingFactor) +
              MediaQuery.of(context).viewInsets.bottom,
          left: dW * horizontalPaddingFactor,
          right: dW * horizontalPaddingFactor,
        ),
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
            Form(
          key: _formKey,
          child: Column(
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
                          textCapitalization: TextCapitalization.words,
                          controller: nameController,
                          onChanged: (text) {
                            final words = text.split(' ');

                            if (words.length > 2) {
                              nameController.text =
                                  words.sublist(0, 2).join(' ');
                            }
                          },
                          focusNode: nameFocus,
                          label: language['name'],
                          hintText: language['name']),
                      SizedBox(
                        height: dW * 0.04,
                      ),
                      CustomTextFieldWithLabel(
                          controller: emailController,
                          focusNode: emailFocus,
                          label: language['email'],
                          validator: validateEmail,
                          hintText: language['email']),
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
                          textCapitalization: TextCapitalization.sentences,
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
                      CustomTextFieldWithLabel(
                          maxLength: 11,
                          onChanged: (text) {
                            if (text.length == 11) {
                              getBankName();
                            } else {
                              setState(() {
                                selectBank = '';
                              });
                            }
                          },
                          validator: (text) {
                            if (text != null &&
                                (text.length != 11 || ifscInvalid)) {
                              return 'Invalid IFSC Code';
                            }
                          },
                          controller: ifscController,
                          textCapitalization: TextCapitalization.characters,
                          focusNode: ifscFocus,
                          label: language['ifscCode'],
                          hintText: language['ifscCode']),
                      SizedBox(
                        height:
                            //  ifscFocus.hasFocus ||
                            //         confirmAccFocus.hasFocus ||
                            //         accFocus.hasFocus
                            //     ? dW * 0.6
                            //     :
                            dW * 0.04,
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
                        onTap: () {
                          // bankBottomSheet(context);
                        },
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
                              // AssetSvgIcon(
                              //   'down_arrow',
                              //   width: dW * 0.05,
                              //   color: blackColor3,
                              // )
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
                          validator: (val) {
                            if (val!.length < 5) {
                              return 'Please enter valid account number';
                            }
                          },
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          maxLength: 17,
                          label: language['accNumber'],
                          hintText: language['accNumber']),
                      SizedBox(
                        height: dW * 0.04,
                      ),
                      CustomTextFieldWithLabel(
                          controller: confirmAccNumberController,
                          focusNode: confirmAccFocus,
                          validator: validateConfirmAccNumber,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          maxLength: 17,
                          // obscureText: true,
                          maxLines: 1,
                          label: language['confimrAccNumber'],
                          hintText: language['confimrAccNumber']),
                    ],
                  ),
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom < 20)
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
                    isLoading: isLoading,
                    radius: 21,
                    buttonText: language['save'],
                    buttonColor: validate ? themeColor : Colors.grey,
                    onPressed: validate ? editProfile : () {},
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
