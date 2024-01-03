import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/models/document_model.dart';
import '../../authModule/models/user_model.dart';
import '../../authModule/providers/auth_provider.dart';
import '../../authModule/providers/document_provider.dart';
import '../../authModule/providers/marketplace_provider.dart';
import '../../colors.dart';
import '../../common_functions.dart';
import '../../common_widgets/asset_svg_icon.dart';
import '../../common_widgets/circular_loader.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/text_widget.dart';
import '../providers/my_application_provider.dart';
import '../widgets/custom_container.dart';

class ReportAnIssueScreen extends StatefulWidget {
  const ReportAnIssueScreen({Key? key}) : super(key: key);

  @override
  ReportAnIssueScreenState createState() => ReportAnIssueScreenState();
}

class ReportAnIssueScreenState extends State<ReportAnIssueScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  List<Doc> documents = [];
  PlatformFile? selectedFile;
  TextEditingController issueController = TextEditingController();
  int wordCount = 0;
  int maxWords = 200;

  void updateWordCount(String value) {
    if (value.isEmpty) {
      // Reset the word count to 0 if the text is empty
      setState(() {});
    } else {
      // Update the word count
      setState(() {});
    }

    if (issueController.text.trim().split(' ').length > maxWords) {
      // Save the selected text and cursor position
      final TextSelection previousSelection = issueController.selection;
      // ignore: unused_local_variable
      final String previousText = issueController.text;

      // If the word count exceeds the limit, truncate the text
      final int currentPosition = previousSelection.baseOffset;
      setState(() {
        issueController.text =
            issueController.text.trim().split(' ').take(maxWords).join(' ');
      });

      // Restore the cursor position
      final int newPosition = currentPosition <= issueController.text.length
          ? currentPosition
          : issueController.text.length;
      issueController.selection =
          TextSelection.fromPosition(TextPosition(offset: newPosition));
    }
  }

  returnDocOrNull(String docName) {
    return documents.indexWhere((element) => element.filename == docName) != -1
        ? documents.firstWhere((element) => element.filename == docName)
        : null;
  }

  getAwsSignedUrl({required String filePath}) async {
    final contentType = determineContentType(PlatformFile(
      name: filePath.split('/').last,
      path: filePath,
      size: 0,
    ));
    final response = await Provider.of<AuthProvider>(context, listen: false)
        .getAwsSignedUrl(
            fileName: filePath.split('/').last,
            filePath: filePath,
            contentType: contentType);
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
      // final a =
      //     Provider.of<DocumentProvider>(context, listen: false).documents[i];
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

    // ignore: use_build_context_synchronously
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

  void removeDocument(value) {
    // setState(() {
    //   selectedFiles.remove(value);
    // });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'PDF',
          'jpeg',
          'png',
          'jpg',
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
        });
        setState(() {
          isLoading = true;
        });
        selectedFile;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void _removeFile() {
    // if (widget.deleteFile != null) {
    //   widget.deleteFile!(selectedFile);
    // }
    (selectedFile);
    setState(() {
      selectedFile = null;
    });
  }

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: CustomAppBar(title: 'Report an Issue', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    final marketplaces =
        Provider.of<MarketplaceProvider>(context, listen: false).marketplaces;

    final myApplication =
        Provider.of<MyApplicationProvider>(context, listen: false)
            .myApplications;

    bool isApproved =
        myApplication.any((application) => application.status == 'APPROVED');
    return isLoading
        ? const Center(child: CircularLoader())
        : GestureDetector(
            onTap: () => hideKeyBoard(),
            child: Stack(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: dW * 0.04,
                            ),
                            Stack(
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
                                      horizontal: dW * 0.06,
                                      vertical: dW * 0.05),
                                  margin: EdgeInsets.only(top: dW * 0.1),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 0.1, color: themeColor),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     spreadRadius: 0,
                                    //     blurRadius: 20,
                                    //     offset: const Offset(0, -5),
                                    //   ),
                                    // ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              width: 50,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: dW * 0.032),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: themeColor),
                                              child: const AssetSvgIcon(
                                                'help',
                                                color: white,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: dW * 0.04,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: dW * 0.01,
                                          ),
                                          TextWidget(
                                            title: language[
                                                'contactVendorHelpline'],
                                            color: const Color(0xff242E42),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                          SizedBox(
                                            height: dW * 0.02,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // if (user.driver.vendor != null) {
                                              //   launchCall(
                                              //       user.driver.vendor!.phone

                                              //       );
                                              // }
                                              if (isApproved &&
                                                  marketplaces.isNotEmpty) {
                                                launchCall(myApplication
                                                    .firstWhere((application) =>
                                                        application.status ==
                                                        'APPROVED')
                                                    .vendorPhone);
                                              } else {
                                                showSnackbar(
                                                    language['notApprovedYet']);
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: TextWidget(
                                                title: language['tapToCall'],
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color:
                                                    // user.driver.vendor != null
                                                    isApproved &&
                                                            marketplaces
                                                                .isNotEmpty
                                                        ? themeColor
                                                        : grayColor
                                                            .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: dW * 0.03, bottom: dW * 0.05),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: dW * 0.04,
                                      vertical: dW * 0.05),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 0.1, color: themeColor),
                                  ),
                                  child: Column(
                                    children: [
                                      CustomContainer(
                                        onTap: () => showSnackbar(
                                            'Coming soon!!', themeColor),
                                        name: language['chooseYourIssue'],
                                        widgets: const AssetSvgIcon(
                                          'down_arrow',
                                          height: 7,
                                          color: Color(0xffC1C0C9),
                                        ),
                                      ),
                                      SizedBox(
                                        height: dW * 0.03,
                                      ),
                                      Container(
                                        width: dW,
                                        padding: EdgeInsets.only(
                                            left: dW * 0.03,
                                            right: dW * 0.03,
                                            bottom: dW * 0.03,
                                            top: dW * 0.03),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF8F8F8),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            width: 1,
                                            color: const Color(0xffEFEFF4),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: issueController,
                                          maxLines: 4,
                                          onChanged: (value) {
                                            updateWordCount(value);
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                language['describeYourIssue'],
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              color: Color(0xff262628),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: dW * 0.01),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextWidget(
                                            title:
                                                '${issueController.text.isEmpty ? 0 : issueController.text.trim().split(' ').length} / $maxWords',
                                            color: issueController.text
                                                        .trim()
                                                        .split(' ')
                                                        .length >
                                                    maxWords
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: dW * 0.03,
                                      ),
                                      GestureDetector(
                                        onTap: isLoading ? null : _pickFile,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: dW * 0.03,
                                              right: dW * 0.03,
                                              bottom: dW * 0.045,
                                              top: dW * 0.045),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF8F8F8),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xffEFEFF4),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: selectedFile != null
                                                    ? TextWidget(
                                                        title: returnDocOrNull(
                                                                    'Aadhar Card') !=
                                                                null
                                                            ? returnDocOrNull(
                                                                    'Aadhar Card')
                                                                .url
                                                                .split('/')
                                                                .last
                                                            : selectedFile!
                                                                .name,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )
                                                    : Row(
                                                        children: [
                                                          TextWidget(
                                                            title: language[
                                                                'uploadScreenshot'],
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                          ),
                                                          SizedBox(
                                                            width: dW * 0.005,
                                                          ),
                                                          TextWidget(
                                                            title: language[
                                                                '(Optional)'],
                                                            color: const Color(
                                                                0xffA7A7A7),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                              returnDocOrNull('Aadhar Card') !=
                                                      null
                                                  ? isLoading
                                                      ? circularForButton(23,
                                                          sW: 2,
                                                          color: themeColor)
                                                      : GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _removeFile();
                                                              // widget.deleteFile;
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: themeColor,
                                                            size: 18,
                                                          ))
                                                  : selectedFile == null
                                                      ? const Icon(Icons.add,
                                                          size: 18,
                                                          color:
                                                              Color(0xffC1C0C9))
                                                      : isLoading
                                                          ? circularForButton(
                                                              23,
                                                              sW: 2,
                                                              color: themeColor)
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  _removeFile();
                                                                  // widget.deleteFile;
                                                                });
                                                              },
                                                              child: const Icon(
                                                                Icons.remove,
                                                                // Icons.edit,
                                                                size: 18,

                                                                color: redColor,
                                                              )),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: dW * 0.06),
                        child: CustomButton(
                          width: dW,
                          height: dW * 0.15,
                          elevation: 12,
                          radius: 21,
                          buttonText: language['submit'],
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
