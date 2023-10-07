import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';

class FilePickerWidget extends StatefulWidget {
  final Function(PlatformFile?) onFileSelected;

  const FilePickerWidget({super.key, required this.onFileSelected});

  @override
  // ignore: library_private_types_in_public_api
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  PlatformFile? selectedFile;
  double dH = 0.0;
  double dW = 0.0;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'svg'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
        });
        widget.onFileSelected(selectedFile);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void _removeFile() {
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: _pickFile,
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
                title:
                    selectedFile == null ? 'Choose a file' : selectedFile!.name,
                fontWeight: FontWeight.w400,
              ),
            ),
            selectedFile == null
                ? const Icon(Icons.add)
                : GestureDetector(
                    onTap: _removeFile,
                    child: const Icon(
                      Icons.remove,
                      color: redColor,
                    )),
          ],
        ),
      ),
    );
  }
}
