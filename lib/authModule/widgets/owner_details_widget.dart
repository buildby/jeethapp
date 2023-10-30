import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/file_picker_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
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
  TextEditingController _ownerMobileNumberController = TextEditingController();
  TextEditingController _ownerAddressController = TextEditingController();

  FocusNode ownerMobileNumberFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode nameFocus = FocusNode();

  double calculatePercentageFilled() {
    int totalFields = 3;
    int filledFields = 0;

    if (_ownerNameController.text.isNotEmpty) {
      filledFields++;
    }
    if (_ownerMobileNumberController.text.isNotEmpty) {
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
            Column(
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
                      // initValue: vehicleNumber,
                      label: language['enterOwnerName'],
                      hintText: language['enterOwnerName']),
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  CustomTextFieldWithLabel(
                      controller: _ownerMobileNumberController,
                      focusNode: ownerMobileNumberFocus,
                      inputType: TextInputType.phone,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      // initValue: vehicleNumber,
                      label: language['enterOwnerMobileNumber'],
                      hintText: language['enterOwnerMobileNumber']),
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  CustomTextFieldWithLabel(
                      controller: _ownerAddressController,
                      focusNode: addressFocus,

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
