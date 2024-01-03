import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class OwnerDetailsBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;

  const OwnerDetailsBottomSheetWidget(
      {super.key, required this.onUpdatePercentage});

  @override
  OwnerDetailsBottomSheetWidgetState createState() =>
      OwnerDetailsBottomSheetWidgetState();
}

class OwnerDetailsBottomSheetWidgetState
    extends State<OwnerDetailsBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  List<PlatformFile> selectedFiles = [];
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _ownerPhoneNumberController = TextEditingController();
  TextEditingController _ownerAddressController = TextEditingController();
  bool validatePhone = false;
  FocusNode ownerMobileNumberFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late User user;

  bool get validateNumber {
    setState(() {
      validatePhone = false;
    });
    String pattern = r'([6,7,8,9][0-9]{9})';
    RegExp regExp = RegExp(pattern);
    String amount = _ownerPhoneNumberController.text.toString();

    if (amount.length < 10 || amount.isEmpty || !regExp.hasMatch(amount)) {
      setState(() {
        validatePhone = false;
      });
      return false;
    }
    setState(() {
      validatePhone = true;
    });
    return true;
  }

  editProfile() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);
    final Map<String, String> body = {
      'id': user.driver.id.toString(),
      "ownerName": _ownerNameController.text.trim(),
      "ownerPhoneNumber": _ownerPhoneNumberController.text.trim(),
      'ownerAddress': _ownerAddressController.text.trim(),
    };

    final response = await Provider.of<AuthProvider>(context, listen: false)
        .editDriverProfile(
            body: {'owner': body}, id: user.driver.id.toString());
    setState(() => isLoading = false);

    if (response['result'] == 'success') {
      double percentageFilled = calculatePercentageFilled();

      widget.onUpdatePercentage(percentageFilled);
      pop();
    } else {
      showSnackbar(language[response['message']]);
    }
  }

  double calculatePercentageFilled() {
    int totalFields = 3;
    int filledFields = 0;

    if (_ownerNameController.text.isNotEmpty) {
      filledFields++;
    }
    if (_ownerPhoneNumberController.text.isNotEmpty) {
      filledFields++;
    }
    if (_ownerAddressController.text.isNotEmpty) {
      filledFields++;
    }
    return (filledFields / totalFields) * 100;
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
    _ownerNameController.text = user.driver.ownerName;
    _ownerPhoneNumberController.text = user.driver.ownerPhoneNumber;
    _ownerAddressController.text = user.driver.ownerAddress;
    calculatePercentageFilled();

    fetchData();
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
        height: ownerMobileNumberFocus.hasFocus ||
                addressFocus.hasFocus ||
                nameFocus.hasFocus
            ? dH * 0.82
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
            Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Divider(
                      indent: dW * 0.27,
                      endIndent: dW * 0.27,
                      color: Colors.black,
                      thickness: 5,
                    ),
                    SizedBox(
                      height: dW * 0.06,
                    ),
                    CustomTextFieldWithLabel(
                        controller: _ownerNameController,
                        focusNode: nameFocus,
                        textCapitalization: TextCapitalization.words,
                        // initValue: vehicleNumber,
                        label: language['enterOwnerName'],
                        hintText: language['enterOwnerName']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    CustomTextFieldWithLabel(
                        controller: _ownerPhoneNumberController,
                        focusNode: ownerMobileNumberFocus,
                        inputType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            validateNumber;
                          });
                        },
                        // initValue: vehicleNumber,
                        label: language['enterOwnerMobileNumber'],
                        hintText: language['enterOwnerMobileNumber']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    CustomTextFieldWithLabel(
                        controller: _ownerAddressController,
                        focusNode: addressFocus,
                        textCapitalization: TextCapitalization.sentences,

                        // initValue: vehicleNumber,
                        label: language['enterownerAddress'],
                        hintText: language['enterownerAddress']),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: dW * 0.05,
                  left: dW * 0.1,
                  right: dW * 0.1,
                ),
                child: CustomButton(
                  isLoading: isLoading,
                  width: dW,
                  height: dW * 0.15,
                  radius: 21,
                  buttonText: language['save'],
                  buttonColor: validateNumber ? themeColor : Colors.grey,
                  onPressed: validateNumber ? editProfile : () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
