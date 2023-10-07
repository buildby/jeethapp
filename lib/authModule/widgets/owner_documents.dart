import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/widgets/custom_file_widget.dart';
import 'package:jeeth_app/authModule/widgets/file_picker_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class OwnerDocumentsBottomSheetWidget extends StatefulWidget {
  const OwnerDocumentsBottomSheetWidget({
    super.key,
  });

  @override
  OwnerDocumentsBottomSheetWidgetState createState() =>
      OwnerDocumentsBottomSheetWidgetState();
}

class OwnerDocumentsBottomSheetWidgetState
    extends State<OwnerDocumentsBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  List<PlatformFile> selectedFiles = [];
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  TextEditingController _bankDetailsController = TextEditingController();
  FocusNode bankDetailsFocus = FocusNode();

  void addDocument(String name, PlatformFile file) {
    setState(() {
      selectedFiles.add(file);
    });
  }

  void removeDocument(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  void saveFiles() {
    for (var file in selectedFiles) {
      print('Saved file: ${file.name}');
    }
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
        height: bankDetailsFocus.hasFocus ? dH * 0.95 : dW * 1.4,
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
            SizedBox(
              height: dW * 0.06,
            ),
            const Row(
              children: [
                TextWidget(
                  title: 'Upload Aadhaar',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                TextWidget(
                  title: '*',
                  color: redColor,
                ),
              ],
            ),
            FilePickerWidget(onFileSelected: (file) {
              if (file != null) {
                setState(() {
                  selectedFiles.add(file);
                });
              }
            }),
            SizedBox(
              height: dW * 0.04,
            ),
            const Row(
              children: [
                TextWidget(
                  title: 'Upload Pan',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                TextWidget(
                  title: '*',
                  color: redColor,
                ),
              ],
            ),
            FilePickerWidget(onFileSelected: (file) {
              if (file != null) {
                setState(() {
                  selectedFiles.add(file);
                });
              }
            }),
            SizedBox(
              height: dW * 0.04,
            ),
            const Row(
              children: [
                TextWidget(
                  title: 'Upload Bank Passbook/Cancelled Cheque/Statement',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                TextWidget(
                  title: '*',
                  color: redColor,
                ),
              ],
            ),
            FilePickerWidget(onFileSelected: (file) {
              if (file != null) {
                setState(() {
                  selectedFiles.add(file);
                });
              }
            }),
            SizedBox(
              height: dW * 0.04,
            ),
            CustomTextFieldWithLabel(
                controller: _bankDetailsController,
                focusNode: bankDetailsFocus,
                // initValue: vehicleNumber,
                label: language['bankAccountDetails'],
                hintText: language['bankAccountDetails']),
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
                onPressed: saveFiles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
