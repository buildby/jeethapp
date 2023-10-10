import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/driver_details_provider.dart';
import 'package:jeeth_app/authModule/widgets/custon_radio_button_bottomsheet.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class DriverDetailsBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;
  DriverDetailsBottomSheetWidget({super.key, required this.onUpdatePercentage});

  @override
  DriverDetailsBottomSheetWidgetState createState() =>
      DriverDetailsBottomSheetWidgetState();
}

class DriverDetailsBottomSheetWidgetState
    extends State<DriverDetailsBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}
  String? selectedVehicleModel;
  String? selectedVehicleType;
  String? selectedVehicleMake;
  String vehicleNumber = '';

  final TextEditingController _nameController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  // FocusNode priceFocus = FocusNode();

  String selectGender = 'Select gender';
  void updateSelectedModel(String count) {
    setState(() {
      selectGender = count;
    });
  }

  void driverGenderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: RadioBtnBtmSheet(
          updateSelectedCount: updateSelectedModel,
          selecteditem: selectedVehicleModel,
          storedSelectedCount: selectGender,
          entries: const ['Male', 'Female', 'Others'],
          title: 'selectGender',
        ),
      ),
    );
  }

  double calculatePercentageFilled() {
    int totalFields = 2;
    int filledFields = 0;

    if (selectGender != 'Select gender') {
      filledFields++;
    }

    if (_nameController.text.isNotEmpty) {
      filledFields++;
    }

    return (filledFields / totalFields) * 100;
  }

  void saveForm() {
    double percentageFilled = calculatePercentageFilled();

    widget.onUpdatePercentage(percentageFilled);
    pop();
  }

  @override
  void initState() {
    super.initState();

    fetchData();

    final driverDetailsProvider =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    if (driverDetailsProvider.driverDetails.isNotEmpty) {
      final existingData = driverDetailsProvider.driverDetails[0];
      selectedVehicleModel = existingData.vehicleModel;
      selectedVehicleType = existingData.vehicleType;
      selectedVehicleMake = existingData.vehicleMake;
      vehicleNumber = existingData.vehicleNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      height: nameFocus.hasFocus ? dH * 0.72 : dW * 1,
      padding: EdgeInsets.symmetric(
          vertical: dW * horizontalPaddingFactor,
          horizontal: dW * horizontalPaddingFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          CustomTextFieldWithLabel(
              controller: _nameController,
              focusNode: nameFocus,
              label: language['enterName'],
              hintText: language['enterName']),
          SizedBox(
            height: dW * 0.04,
          ),
          Row(
            children: [
              TextWidget(
                title: language['selectGender'],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const TextWidget(
                title: '*',
                color: redColor,
              ),
            ],
          ),
          GestureDetector(
            onTap: () => driverGenderBottomSheet(context),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeColor)),
              padding: EdgeInsets.symmetric(
                  vertical: dW * 0.037, horizontal: dW * 0.04),
              margin: EdgeInsets.symmetric(vertical: dW * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextWidget(
                      title:
                          //  selectedVehicleModel ??
                          selectGender,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AssetSvgIcon(
                    'down_arrow',
                    width: dW * 0.05,
                    color: blackColor3,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: dW * 0.1,
              left: dW * 0.1,
              right: dW * 0.1,
            ),
            child: CustomButton(
              width: dW,
              height: dW * 0.15,
              radius: 21,
              buttonText: language['save'],
              onPressed: saveForm,
            ),
          ),
        ],
      ),
    );
  }
}
