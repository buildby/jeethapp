import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
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

  Future<void> showAddDocumentDialog(BuildContext context) async {
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
                fileName: pickedFile?.files.single.name ?? 'Choose a file',
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
                  // Process the selected file and document name
                  // Add the document to your list or perform any desired action
                  setState(() {
                    selectedFiles.add(pickedFile!.files.single);
                  });
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

  double calculatePercentageFilled() {
    int totalRequiredDocuments = 5;
    // + (selectedFiles.length);

    int selectedDocumentCount = selectedFiles.length;

    double percentageFilled =
        (selectedDocumentCount / totalRequiredDocuments) * 100;

    return percentageFilled;
  }

  void saveFiles() {
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
                  FilePickerWidget(onFileSelected: (file) {
                    if (file != null) {
                      setState(() {
                        selectedFiles.add(file);
                      });
                    }
                  }),
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
                      showAddDocumentDialog(context);
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
              onPressed: saveFiles,
            ),
          ),
        ],
      ),
    );
  }
}
