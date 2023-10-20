import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/driver_details_provider.dart';
import 'package:jeeth_app/authModule/widgets/custon_radio_button_bottomsheet.dart';
import 'package:jeeth_app/authModule/widgets/file_picker_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class DriverDocBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;
  DriverDocBottomSheetWidget({super.key, required this.onUpdatePercentage});

  @override
  DriverDocBottomSheetWidgetState createState() =>
      DriverDocBottomSheetWidgetState();
}

class DriverDocBottomSheetWidgetState
    extends State<DriverDocBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  String? selectedVehicleModel;
  String? selectedVehicleType;
  String? selectedVehicleMake;
  String vehicleNumber = '';
  List<PlatformFile> selectedFiles = [];
  FocusNode bankDetailsFocus = FocusNode();

  TextEditingController _bankDetailsController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  // FocusNode priceFocus = FocusNode();

  void removeDocument(value) {
    setState(() {
      selectedFiles.remove(value);
    });
  }

  String selectGender = 'Select gender';
  void updateSelectedModel(String count) {
    setState(() {
      selectGender = count;
    });
  }

  void driverGenderBottomSheet(BuildContext context) {
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
          updateSelectedCount: updateSelectedModel,
          selecteditem: selectedVehicleModel,
          storedSelectedCount: selectGender,
          entries: const ['Male', 'Female', 'Others'],
          title: 'selectGender',
        ),
      ),
    );
  }

  double calculatePercentageFilled() {
    int totalFields = 5;

    int selectedDocumentCount = selectedFiles.length;

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
      selectedVehicleModel = existingData.vehicleModel;
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: dW * 0.06,
                    ),
                    Row(
                      children: const [
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
                    FilePickerWidget(
                      onFileSelected: (file) {
                        if (file != null) {
                          setState(() {
                            selectedFiles.add(file);
                          });
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    Row(
                      children: const [
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
                    FilePickerWidget(
                      onFileSelected: (file) {
                        if (file != null) {
                          setState(() {
                            selectedFiles.add(file);
                          });
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    Row(
                      children: const [
                        TextWidget(
                          title: 'License',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          title: '*',
                          color: redColor,
                        ),
                      ],
                    ),
                    FilePickerWidget(
                      onFileSelected: (file) {
                        if (file != null) {
                          setState(() {
                            selectedFiles.add(file);
                          });
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    Row(
                      children: const [
                        TextWidget(
                          title: 'Upload Police Verification Certificate',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          title: '*',
                          color: redColor,
                        ),
                      ],
                    ),
                    FilePickerWidget(
                      onFileSelected: (file) {
                        if (file != null) {
                          setState(() {
                            selectedFiles.add(file);
                          });
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    Row(
                      children: const [
                        TextWidget(
                          title:
                              'Upload Bank Passbook/Cancelled Cheque/Statement',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          title: '*',
                          color: redColor,
                        ),
                      ],
                    ),
                    FilePickerWidget(
                      onFileSelected: (file) {
                        if (file != null) {
                          setState(() {
                            selectedFiles.add(file);
                          });
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: dW * 0.05,
                  left: dW * 0.1,
                  right: dW * 0.1,
                  bottom: dW * 0.02),
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
