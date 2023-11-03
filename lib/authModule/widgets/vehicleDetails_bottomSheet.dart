import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/user_model.dart';
import 'package:jeeth_app/authModule/models/vehicle_detail_modal.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/driver_details_provider.dart';
import 'package:jeeth_app/authModule/widgets/vehicle_make_widget.dart';
import 'package:jeeth_app/authModule/widgets/vehicle_model_widget.dart';
import 'package:jeeth_app/authModule/widgets/vehicle_type_bottomSheet.dart';
import 'package:jeeth_app/authModule/widgets/vehicle_year_widget.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/custom_button.dart';
import 'package:jeeth_app/common_widgets/custom_text_field.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:jeeth_app/navigation/navigators.dart';
import 'package:jeeth_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class VehicleDetailsBottomSheetWidget extends StatefulWidget {
  final void Function(num) onUpdatePercentage;
  VehicleDetailsBottomSheetWidget(
      {super.key, required this.onUpdatePercentage});

  @override
  VehicleDetailsBottomSheetWidgetState createState() =>
      VehicleDetailsBottomSheetWidgetState();
}

class VehicleDetailsBottomSheetWidgetState
    extends State<VehicleDetailsBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  List<String> makes = [];
  List<Map<String, dynamic>> models = [];

  fetchData() async {}
  String? selectedVehicleModel;
  String? selectedVehicleYear;
  // String? selectedMake;
  String? selectedVehicleType;
  String? selectedVehicleMake;
  String vehicleNumber = '';
  late User user;

  final TextEditingController _vehicleNumberController =
      TextEditingController();

  FocusNode numberFocus = FocusNode();
  // FocusNode priceFocus = FocusNode();

  String selectModel = 'Select model';
  void updateSelectedModel(String count) {
    selectType = models.firstWhere(
      (element) => element['value'] == count,
    )['type'];
    setState(() {
      selectModel = count;
    });
  }

  void vehicleModelBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: VehicleModelWidget(
            updateSelectedModel, selectedVehicleModel, selectModel, selectMake),
      ),
    );
  }

  String selectYear = 'Select year';
  void updateSelectedYear(String count) {
    setState(() {
      selectYear = count;
    });
  }

  void vehicleYearBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: VehicleYearWidget(
            updateSelectedYear, selectedVehicleYear, selectYear),
      ),
    );
  }

  String selectType = 'Select type';
  void updateSelectedType(String count) {
    setState(() {
      selectType = count;
    });
  }

  void vehicleTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: VehicleTypeWidget(
            updateSelectedType, selectedVehicleType, selectType),
      ),
    );
  }

  String selectMake = 'Select make';
  void updateSelectedMake(String count) {
    setState(() {
      selectMake = count;
    });
  }

  void vehicleMakeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: VehicleMakeWidget(
            updateSelectedMake, selectedVehicleMake, selectMake),
      ),
    );
  }

  double calculatePercentageFilled() {
    int totalFields = 5;

    int selectedDocumentCount = 0;

    if (selectMake != 'Select make') {
      selectedDocumentCount++;
    }
    if (selectModel != 'Select model') {
      selectedDocumentCount++;
    }

    if (selectType != 'Select type') {
      selectedDocumentCount++;
    }
    if (selectYear != 'Select year') {
      selectedDocumentCount++;
    }

    if (_vehicleNumberController.text.isNotEmpty) {
      selectedDocumentCount++;
    }

    return (selectedDocumentCount / totalFields) * 100;
  }

  editProfile() async {
    // bool isValid = _formKey.currentState!.validate();

    // if (!isValid) {
    //   setState(() {});
    //   return;
    // }

    setState(() => isLoading = true);
    final Map<String, String> body = {
      'id': user.driver.id.toString(),
      "vehicleMake": selectMake,
      "vehicleModel": selectModel,
      'vehicleType': selectType,
      'vehicleYear': selectYear,
      'vehicleNumber': _vehicleNumberController.text.toString(),
    };

    final response = await Provider.of<AuthProvider>(context, listen: false)
        .editDriverProfile(
            body: {'vehicle': body}, id: user.driver.id.toString());
    setState(() => isLoading = false);

    if (response['result'] == 'success') {
      double percentageFilled = calculatePercentageFilled();

      widget.onUpdatePercentage(percentageFilled);
      pop();
    } else {
      showSnackbar(language[response['message']]);
    }
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;

    makes = Provider.of<AuthProvider>(context, listen: false).makes;
    models = Provider.of<AuthProvider>(context, listen: false).models;

    selectMake = user.driver.vehicle.vehicleMake;
    selectModel = user.driver.vehicle.vehicleModel;
    selectType = user.driver.vehicle.vehicleType;
    selectYear = user.driver.vehicle.vehicleYear;
    _vehicleNumberController.text = user.driver.vehicle.vehicleNumber;
    calculatePercentageFilled();

    fetchData();

    final driverDetailsProvider =
        Provider.of<VehicleDetailProvider>(context, listen: false);
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
    makes = Provider.of<AuthProvider>(context).makes;
    models = Provider.of<AuthProvider>(context).models;

    return Container(
      height: numberFocus.hasFocus ? dH * 0.95 : dW * 1.4,
      padding: EdgeInsets.symmetric(
          vertical: dW * horizontalPaddingFactor,
          horizontal: dW * horizontalPaddingFactor),
      child: Column(
        children: [
          Divider(
            indent: dW * 0.27,
            endIndent: dW * 0.27,
            color: Colors.black,
            thickness: 5,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: dW * 0.06,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        title: language['selectVehicleMake'],
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
                    onTap: () => vehicleMakeBottomSheet(context),
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
                              title: selectMake,
                              fontWeight: FontWeight.w400,
                              // color: placeholderColor,
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
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        title: language['selectVehicleModel'],
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
                    onTap: () => vehicleModelBottomSheet(context),
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
                                  selectModel,
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
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        title: language['selectVehicleType'],
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
                    onTap: () => vehicleTypeBottomSheet(context),
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
                              title: selectType,
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
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        title: language['selectVehicleYear'],
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
                    onTap: () => vehicleYearBottomSheet(context),
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
                                  selectYear,
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
                  SizedBox(
                    height: dW * 0.04,
                  ),
                  CustomTextFieldWithLabel(
                      controller: _vehicleNumberController,
                      focusNode: numberFocus,
                      // initValue: vehicleNumber,
                      label: language['enterVehicleNumber'],
                      hintText: language['enterVehicleNumber']),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: dW * 0.05,
              left: dW * 0.1,
              right: dW * 0.1,
            ),
            child: CustomButton(
              isLoading: isLoading,
              width: dW,
              height: dW * 0.15,
              radius: 21,
              buttonText: language['save'],
              onPressed: editProfile,
            ),
          ),
        ],
      ),
    );
  }
}
