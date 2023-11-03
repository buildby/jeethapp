import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/document_model.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/document_provider.dart';
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

  DriverDocBottomSheetWidget({
    super.key,
    required this.onUpdatePercentage,
  });

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
  String aadhar = '';
  FocusNode bankDetailsFocus = FocusNode();
  Doc? document;
  late User user;
  List<Doc> documents = [];

  TextEditingController _bankDetailsController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  // FocusNode priceFocus = FocusNode();

  void removeDocument(value) {
    // setState(() {
    //   selectedFiles.remove(value);
    // });
  }

  String selectGender = 'Select gender';
  void updateSelectedModel(String count) {
    setState(() {
      selectGender = count;
    });
  }

  returnDocOrNull(String docName) {
    return documents.indexWhere((element) => element.filename == docName) != -1
        ? documents.firstWhere((element) => element.filename == docName)
        : null;
  }

  getAwsSignedUrl({required String filePath}) async {
    final response =
        await Provider.of<AuthProvider>(context, listen: false).getAwsSignedUrl(
      fileName: filePath.split('/').last,
      filePath: filePath,
    );
    if (response['result'] == 'success') {
      return response['data']['signedUrl'].split('?')[0];
    } else {
      return null;
    }
  }

  uploadDocument(
      {required String documentName, required PlatformFile file}) async {
    setState(() {
      isLoading = true;
    });
    int docId = 0;
    int i = Provider.of<DocumentProvider>(context, listen: false)
        .documents
        .indexWhere((element) => element.filename == documentName);
    if (i != -1) {
      final a =
          Provider.of<DocumentProvider>(context, listen: false).documents[i];
      docId =
          Provider.of<DocumentProvider>(context, listen: false).documents[i].id;
    }

    final s3Url = await getAwsSignedUrl(
      filePath: file.path!,
    );

    if (s3Url == null) {
      showSnackbar('Failed to upload document');
      return;
    }

    final response = await Provider.of<DocumentProvider>(context, listen: false)
        .updateDriverDocuments(doc_id: docId, driver_id: user.driver.id, body: {
      "filename": documentName,
      "url": s3Url,
      "filePath": file.path!,
      "type": file.path!.split('.').last == 'pdf' ? 'Document' : 'Image',
    });
    if (response['result'] == 'success') {
      showSnackbar('Document added successfully', greenColor);
    } else {
      showSnackbar(response['message']);
    }

    setState(() {
      isLoading = false;
    });
  }

  double calculatePercentageFilled() {
    int totalFields = 5;

    int selectedDocumentCount = 0;

    for (var i = 0; i < documents.length; i++) {
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
    user = Provider.of<AuthProvider>(context, listen: false).user;

    calculatePercentageFilled();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    documents = Provider.of<DocumentProvider>(context).documents;

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
                    FilePickerWidget(
                      // isLoading: isLoading,
                      document: returnDocOrNull('Aadhar Card'),
                      onFileSelected: (file) async {
                        if (file != null) {
                          await uploadDocument(
                              documentName: 'Aadhar Card', file: file);
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
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
                    FilePickerWidget(
                      // isLoading: isLoading,
                      document: returnDocOrNull('Pan Card'),
                      onFileSelected: (file) async {
                        if (file != null) {
                          await uploadDocument(
                              documentName: 'Pan Card', file: file);
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    const Row(
                      children: [
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
                      // isLoading: isLoading,
                      document: returnDocOrNull('License'),
                      onFileSelected: (file) async {
                        if (file != null) {
                          await uploadDocument(
                              documentName: 'License', file: file);
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    const Row(
                      children: [
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
                      // isLoading: isLoading,
                      document:
                          returnDocOrNull('Police Verification Certificate'),
                      onFileSelected: (file) async {
                        if (file != null) {
                          await uploadDocument(
                              documentName: 'Police Verification Certificate',
                              file: file);
                        }
                      },
                      deleteFile: (file) {
                        removeDocument(file);
                      },
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    const Row(
                      children: [
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
                      // isLoading: isLoading,
                      document: returnDocOrNull(
                          'Bank Passbook/Cancelled Cheque/Statement'),
                      onFileSelected: (file) async {
                        if (file != null) {
                          await uploadDocument(
                              documentName:
                                  'Bank Passbook/Cancelled Cheque/Statement',
                              file: file);
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
