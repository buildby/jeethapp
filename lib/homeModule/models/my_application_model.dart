import 'package:jeeth_app/authModule/models/marketplace_model.dart';

class MyApplication {
  int id;
  Marketplace vendorName;
  String status;
  String area;
  String fieldOfficerName;
  List<String> fieldOfficerNumbers;
  String? inCorrectDocs;
  String logo;

  MyApplication(
      {required this.vendorName,
      required this.id,
      required this.status,
      required this.area,
      required this.fieldOfficerName,
      required this.fieldOfficerNumbers,
      required this.logo,
      this.inCorrectDocs});
}
