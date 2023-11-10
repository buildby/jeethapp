import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/custom_radio_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class VehicleFuelTypeWidget extends StatefulWidget {
  final Function(String) updateSelectedCount;
  final String? selectedFuelType;
  final String? storedSelectedCount;
  const VehicleFuelTypeWidget(
      this.updateSelectedCount, this.selectedFuelType, this.storedSelectedCount,
      {super.key});

  @override
  VehicleFuelTypeWidgetState createState() => VehicleFuelTypeWidgetState();
}

class VehicleFuelTypeWidgetState extends State<VehicleFuelTypeWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  String? selectedType;
  List<String> types = ['Petrol', 'Diesel', 'CNG', 'EV'];
  void selectType(String type) {
    widget.updateSelectedCount(type);
    setState(() {
      selectedType = type;
    });
    // pop();
  }

  @override
  void initState() {
    super.initState();
    selectedType = widget.selectedFuelType;
    if (widget.storedSelectedCount != null) {
      selectedType = widget.storedSelectedCount;
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
                title: language['selectFuelType'],
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
              ...types.map(
                (type) => CustomRadioButton(
                  label: type.toString(),
                  isSelected: selectedType == type,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        selectType(type);
                      } else {
                        selectedType = null;
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
