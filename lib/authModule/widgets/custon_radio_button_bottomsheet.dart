import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/custom_radio_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class RadioBtnBtmSheet extends StatefulWidget {
  final Function(String) updateSelectedCount;
  final String? selecteditem;
  final String? storedSelectedCount;
  final List<String> entries;
  String title;
  RadioBtnBtmSheet({
    super.key,
    required this.entries,
    required this.title,
    required this.updateSelectedCount,
    required this.selecteditem,
    required this.storedSelectedCount,
  });

  @override
  RadioBtnBtmSheetState createState() => RadioBtnBtmSheetState();
}

class RadioBtnBtmSheetState extends State<RadioBtnBtmSheet> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  String? selectedItem;
  void selectModel(String item) {
    widget.updateSelectedCount(item);
    setState(() {
      selectedItem = item;
    });
    // pop();
  }

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selecteditem;
    if (widget.storedSelectedCount != null) {
      selectedItem = widget.storedSelectedCount;
    }
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      padding:
          EdgeInsets.symmetric(vertical: dW * 0.055, horizontal: dW * 0.045),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: language[widget.title],
                fontWeight: FontWeight.w500,
              ),
              // GestureDetector(
              //     onTap: () => pop(),
              //     child: const AssetSvgIcon(
              //       'cross_red',
              //       color: Colors.black,
              //     )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: dW * 0.03),
            padding: EdgeInsets.symmetric(
                vertical: dW * 0.03, horizontal: dW * 0.02),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              border: Border(top: BorderSide(color: themeColor)),
            ),
            child: Column(children: [
              ...widget.entries.map(
                (entry) => CustomRadioButton(
                  label: entry.toString(),
                  isSelected: selectedItem == entry,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        selectModel(entry);
                      } else {
                        selectedItem = null;
                      }
                      pop();
                    });
                  },
                  activeColor: buttonColor,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
