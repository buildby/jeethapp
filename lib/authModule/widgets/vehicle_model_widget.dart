import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_radio_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class VehicleModelWidget extends StatefulWidget {
  final Function(String) updateSelectedCount;
  final String? selectedVehicleModel;
  final String? storedSelectedCount;
  const VehicleModelWidget(this.updateSelectedCount, this.selectedVehicleModel,
      this.storedSelectedCount,
      {super.key});

  @override
  VehicleModelWidgetState createState() => VehicleModelWidgetState();
}

class VehicleModelWidgetState extends State<VehicleModelWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  String? selectedModel;
  List<String> models = ['2020', '2021', '2022'];
  void selectModel(String model) {
    widget.updateSelectedCount(model);
    setState(() {
      selectedModel = model;
    });
    // pop();
  }

  @override
  void initState() {
    super.initState();
    selectedModel = widget.selectedVehicleModel;
    if (widget.storedSelectedCount != null) {
      selectedModel = widget.storedSelectedCount;
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
                title: language['selectModel'],
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
              ...models.map(
                (model) => CustomRadioButton(
                  label: model.toString(),
                  isSelected: selectedModel == model,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        selectModel(model);
                      } else {
                        selectedModel = null;
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
