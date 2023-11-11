class MyApplication {
  int id;
  int campaignId;
  String campaignName;
  String clientSiteName;
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
      vendorId: myApplication['Campaign']['Vendor']['id'],
      vendorName: myApplication['Campaign']['Vendor']['name'],
      vendorPhone: myApplication['Campaign']['Vendor']['phone'],
      vendorAvatar: myApplication['Campaign']['Vendor']['avatar'],
      status: myApplication['status'],
      createdAt: myApplication['created_At'] != null
          ? DateTime.parse(myApplication['created_At']).toLocal()
          : DateTime.now(),
    );
  }
}
