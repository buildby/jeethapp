import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyApplication {
  int id;
  int campaignId;
  String campaignName;
  String clientSiteName;
  String ClientSiteLocation;
  int vendorId;
  String vendorName;
  String vendorPhone;
  String vendorAvatar;
  String status;
  final DateTime createdAt;

  MyApplication({
    required this.id,
    required this.campaignId,
    required this.campaignName,
    required this.clientSiteName,
    required this.ClientSiteLocation,
    required this.vendorId,
    required this.vendorName,
    required this.vendorPhone,
    required this.vendorAvatar,
    required this.status,
    required this.createdAt,
  });

  static MyApplication jsonToMyApplication(Map myApplication) {
    return MyApplication(
      id: myApplication['id'],
      campaignId: myApplication['campaign_id'],
      campaignName: myApplication['Campaign']['name'],
      clientSiteName: myApplication['Campaign']['ClientSite']['name'],
      ClientSiteLocation: myApplication['Campaign']['ClientSite']['location'],
      vendorId: myApplication['Campaign']['Vendor']['id'],
      vendorName: myApplication['Campaign']['Vendor']['name'],
      vendorPhone: myApplication['Campaign']['Vendor']['phone'],
      vendorAvatar: myApplication['Campaign']['Vendor']['avatar'],
      status: myApplication['status'],
      createdAt: myApplication['created_at'] != null
          ? DateTime.parse(myApplication['created_at']).toLocal()
          : DateTime.now(),
    );
  }
}
