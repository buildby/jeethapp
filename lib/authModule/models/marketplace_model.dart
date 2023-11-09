class Marketplace {
  final int id;
  String vendername;
  String companyName;
  String image;
  num rating;
  num totalSedan;
  num totalSuv;
  num avgFare;
  bool isActive;
  bool isDeleted;
  final ClientSite clientSite;
  final Map data;

  Marketplace({
    required this.id,
    this.vendername = '',
    this.companyName = '',
    this.image = '',
    this.rating = 0,
    this.totalSedan = 0,
    this.totalSuv = 0,
    this.avgFare = 0,
    this.isActive = false,
    this.isDeleted = false,
    required this.clientSite,
    required this.data,
  });

  static Marketplace jsonToMarketplace(Map marketplace) => Marketplace(
        id: marketplace['id'],
        vendername: marketplace['name'] ?? '',
        companyName: marketplace['companyName'] ?? '',
        image: marketplace['image'] ?? '',
        rating: marketplace['rating'] ?? 0,
        totalSedan: marketplace['totalSedan'] ?? 0,
        totalSuv: marketplace['totalSuv'] ?? 0,
        avgFare: marketplace['avgFare'] ?? 0,
        isActive: marketplace['isActive'] ?? true,
        isDeleted: marketplace['isDeleted'] ?? false,
        clientSite: ClientSite.jsonToClientSite(marketplace['ClientSite']),
        data: marketplace['data'],
      );
}

class ClientSite {
  final int id;
  final String name;
  final String location;
  final String avatar;
  final List workingDays;
  final List contactNumbers;
  final int venderId;
  final List businessModel;

  ClientSite({
    required this.id,
    required this.name,
    required this.location,
    required this.avatar,
    required this.workingDays,
    required this.contactNumbers,
    required this.venderId,
    required this.businessModel,
  });

  static ClientSite jsonToClientSite(Map clientSite) => ClientSite(
      id: clientSite['id'],
      name: clientSite['name'] ?? '',
      location: clientSite['location'] ?? '',
      avatar: clientSite['avatar'] ?? '',
      workingDays: clientSite['workingDays'],
      contactNumbers: clientSite['contactNumbers'],
      venderId: clientSite['vender_id'] ?? 0,
      businessModel: clientSite['BusinessModel']);

  final a = [
    {
      'id': 1,
      'name': 'Slab Model 1',
      'type': 'SLAB',
      'modeldata': [
        {
          'range': {'max': 30, 'min': 0},
          'vehicle_type': {
            'suv': {'Petrol/Diesel': 400}
          }
        }
      ],
      'vendor_id': 1,
      'clientsite_id': 1
    }
  ];
}
