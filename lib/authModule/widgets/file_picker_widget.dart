import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jeeth_app/authModule/models/document_model.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';

class FilePickerWidget extends StatefulWidget {
  Future<void> Function(PlatformFile?) onFileSelected;
  final Function(PlatformFile?) deleteFile;
  final Doc? document;

  FilePickerWidget({
    super.key,
    required this.onFileSelected,
    required this.deleteFile,
    this.document,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  PlatformFile? selectedFile;
  double dH = 0.0;
  double dW = 0.0;
  bool isLoading = false;

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
        await widget.onFileSelected(selectedFile);
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
    widget.deleteFile(selectedFile);
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: isLoading ? null : _pickFile,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeColor),
        ),
        padding: EdgeInsets.symmetric(
          vertical: dW * 0.037,
          horizontal: dW * 0.04,
        ),
        margin: EdgeInsets.symmetric(vertical: dW * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextWidget(
                title: widget.document != null
                    ? widget.document!.url.split('/').last
                    : selectedFile == null
                        ? 'Choose a file'
                        : selectedFile!.name,
                fontWeight: FontWeight.w400,
              ),
            ),
            widget.document != null
                ? isLoading
                    ? circularForButton(23, sW: 2, color: themeColor)
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
                        ))
                : selectedFile == null
                    ? const Icon(Icons.add)
                    : isLoading
                        ? circularForButton(23, sW: 2, color: themeColor)
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _removeFile();
                                // widget.deleteFile;
                              });
                            },
                            child: Icon(
                              // Icons.remove,
                              Icons.edit,

                              color: themeColor,
                            )),
          ],
        ),
      ),
    );
  }
}
