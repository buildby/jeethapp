import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';

class CustomFileWidget extends StatefulWidget {
  final List<PlatformFile> selectedFiles;
  final String fileName;
  final String documentName;
  final Function() onTap;
  final Function() onRemove;

  CustomFileWidget(
      {required this.fileName,
      required this.documentName,
      required this.onTap,
      required this.onRemove,
      required this.selectedFiles});

  @override
  State<CustomFileWidget> createState() => _CustomFileWidgetState();
}

class _CustomFileWidgetState extends State<CustomFileWidget> {
  double dH = 0.0;
  double dW = 0.0;

  void addDocument() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      setState(() {
        widget.selectedFiles.add(pickedFile.files.single);
      });
    }
  }

  void removeDocument(int index) {
    setState(() {
      widget.selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: widget.onTap,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title: widget.fileName,
                    fontWeight: FontWeight.w400,
                  ),
                  TextWidget(
                    title: widget.documentName,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: widget.onRemove,
              child: const Icon(
                Icons.remove,
                color: redColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
