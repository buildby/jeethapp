import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/custom_radio_button.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class VehicleYearWidget extends StatefulWidget {
  final Function(String) updateSelectedCount;
  final String? selectedVehicleYear;
  final String? storedSelectedCount;
  const VehicleYearWidget(this.updateSelectedCount, this.selectedVehicleYear,
      this.storedSelectedCount,
      {super.key});

  @override
  VehicleYearWidgetState createState() => VehicleYearWidgetState();
}

class VehicleYearWidgetState extends State<VehicleYearWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  String? selectedModel;
  List<String> models =
      List.generate((15), (y) => (DateTime.now().year - y).toString());
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
    selectedModel = widget.selectedVehicleYear;
    if (widget.storedSelectedCount != null) {
      selectedModel = widget.storedSelectedCount;
    }
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

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
                title: language['selectYear'],
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
          Expanded(
            child: Container(
              height: dH * 0.7,
              margin: EdgeInsets.only(top: dW * 0.03),
              padding: EdgeInsets.symmetric(
                  vertical: dW * 0.03, horizontal: dW * 0.02),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                border: Border(top: BorderSide(color: themeColor)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
