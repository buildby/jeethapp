import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/document_model.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/document_provider.dart';
import 'package:jeeth_app/authModule/widgets/custom_file_widget.dart';
import 'package:jeeth_app/authModule/widgets/file_picker_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class VehicleDocumentsBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;

  const VehicleDocumentsBottomSheetWidget(
      {super.key, required this.onUpdatePercentage});

  @override
  VehicleDocumentsBottomSheetWidgetState createState() =>
      VehicleDocumentsBottomSheetWidgetState();
}

class VehicleDocumentsBottomSheetWidgetState
    extends State<VehicleDocumentsBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  List<PlatformFile> selectedFiles = [];
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  TextEditingController documentNameController = TextEditingController();
  late User user;
  List<Doc> documents = [];

  void removeDocument(value) {
    // setState(() {
    //   selectedFiles.remove(value);
    // });
  }

  Future<void> showAddDocumentDialog(
      BuildContext context, List<PlatformFile> selectedFiles) async {
    FilePickerResult? pickedFile;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: documentNameController,
                decoration: const InputDecoration(labelText: 'Document Name'),
              ),
              const SizedBox(height: 10),
              CustomFileWidget(
                fileName: pickedFile?.files.single.name ??
                    (selectedFiles.isNotEmpty
                        ? selectedFiles[0].name
                        : 'Choose a file'),
                documentName: documentNameController.text,
                selectedFiles: selectedFiles,
                onTap: () async {
                  pickedFile = await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    setState(() {});
                  }
                },
                onRemove: () {
                  setState(() {
                    pickedFile = null;
                    selectedFiles[0].name == '';
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (documentNameController.text.isNotEmpty &&
                    pickedFile != null) {
                  selectedFiles.add(pickedFile!
                      .files.single); // Update the selectedFiles list
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> showAddDocumentDialog(BuildContext context) async {
  //   FilePickerResult? pickedFile;

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Add Document'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextField(
  //               controller: documentNameController,
  //               decoration: const InputDecoration(labelText: 'Document Name'),
  //             ),
  //             const SizedBox(height: 10),
  //             CustomFileWidget(
  //               fileName: pickedFile?.files.single.name ?? 'Choose a file',
  //               documentName: documentNameController.text,
  //               selectedFiles: selectedFiles,
  //               onTap: () async {
  //                 pickedFile = await FilePicker.platform.pickFiles();
  //                 if (pickedFile != null) {
  //                   setState(() {});
  //                 }
  //               },
  //               onRemove: () {
  //                 setState(() {
  //                   pickedFile = null;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               if (documentNameController.text.isNotEmpty &&
  //                   pickedFile != null) {
  //                 // Process the selected file and document name
  //                 // Add the document to your list or perform any desired action
  //                 setState(() {
  //                   selectedFiles.add(pickedFile!.files.single);
  //                 });
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: const Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void addDocument(String name, PlatformFile file) {
    setState(() {
      selectedFiles.add(file);
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
  }

  double calculatePercentageFilled() {
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
    documents = Provider.of<DocumentProvider>(context, listen: false).documents;

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      // height: numberFocus.hasFocus ? dH * 0.95 : dW * 1.4,
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
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      TextWidget(
                        title: 'Upload RC',
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
                    document: returnDocOrNull('Vehicle RC'),
                    onFileSelected: (file) async {
                      if (file != null) {
                        await uploadDocument(
                            documentName: 'Vehicle RC', file: file);
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
                        title: 'Upload Fitness',
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
                    document: returnDocOrNull('Vehicle Fitness'),
                    onFileSelected: (file) async {
                      if (file != null) {
                        await uploadDocument(
                            documentName: 'Vehicle Fitness', file: file);
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
                        title: 'Upload Permit',
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
                    document: returnDocOrNull('Vehicle Permit'),
                    onFileSelected: (file) async {
                      if (file != null) {
                        await uploadDocument(
                            documentName: 'Vehicle Permit', file: file);
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
                        title: 'Upload Insurance',
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
                    document: returnDocOrNull('Vehicle Insurance'),
                    onFileSelected: (file) async {
                      if (file != null) {
                        await uploadDocument(
                            documentName: 'Vehicle Insurance', file: file);
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
                        title: 'Upload PUC',
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
                    document: returnDocOrNull('Vehicle PUC'),
                    onFileSelected: (file) async {
                      if (file != null) {
                        await uploadDocument(
                            documentName: 'Vehicle PUC', file: file);
                      }
                    },
                    deleteFile: (file) {
                      removeDocument(file);
                    },
                  ),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: selectedFiles.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     final document = selectedFiles[index];
                  //     return CustomFileWidget(
                  //       fileName: documentNameController.text,
                  //       selectedFiles: selectedFiles,
                  //       documentName: document.name.isEmpty
                  //           ? 'Choose a file'
                  //           : document.name,
                  //       onTap: () {
                  //         // Implement the onTap functionality if needed
                  //       },
                  //       onRemove: () {
                  //         removeDocument(index);
                  //       },
                  //     );
                  //   },
                  // ),

                  ElevatedButton(
                    onPressed: () {
                      showAddDocumentDialog(context, selectedFiles);
                    },
                    child: const Text('Add More Documents'),
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
    );
  }
}
