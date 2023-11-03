import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_radio_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class VehicleMakeWidget extends StatefulWidget {
  final Function(String) updateSelectedCount;
  final String? selectedVehicleMake;
  final String? storedSelectedCount;
  const VehicleMakeWidget(this.updateSelectedCount, this.selectedVehicleMake,
      this.storedSelectedCount,
      {super.key});

  @override
  VehicleMakeWidgetState createState() => VehicleMakeWidgetState();
}

class VehicleMakeWidgetState extends State<VehicleMakeWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  String? selectedMake;
  List<String> makes = [];
  void selectMake(String make) {
    widget.updateSelectedCount(make);
    setState(() {
      selectedMake = make;
    });
    // pop();
  }

  @override
  void initState() {
    super.initState();
    makes = Provider.of<AuthProvider>(context, listen: false).makes;
    selectedMake = widget.selectedVehicleMake;
    if (widget.storedSelectedCount != null) {
      selectedMake = widget.storedSelectedCount;
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
                title: language['selectMake'],
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
              ...makes.map(
                (make) => CustomRadioButton(
                  label: make.toString(),
                  isSelected: selectedMake == make,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        selectMake(make);
                      } else {
                        selectedMake = null;
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
