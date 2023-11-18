import 'dart:math';

class Marketplace {
  final int id;
  String vendername;
  String venderPhone;

  String companyName;
  String vendorAvatar;
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
    this.venderPhone = '',
    this.companyName = '',
    this.vendorAvatar = '',
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
        vendername: marketplace['Vendor']['name'] ?? '',
        venderPhone: marketplace['Vendor']['phone'] ?? '',

        companyName: marketplace['companyName'] ?? '',
        vendorAvatar: marketplace['Vendor']['avatar'] ?? '',
        rating: marketplace['rating'] ?? 0,
        // rating: 4,
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

// Slab
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

  // KM
  final b = [
    {
      "suv": {"CNG": 18, "Petrol/Diesel": 20}
    }
  ];

  // Package fiex km
  final c = {
    "fixed_km": {
      "range": 5000,
      "vehicle_type": {
        "suv": {
          "CNG": {"rate": 4000, "km_rate": 30},
          "Petrol/Diesel": {"rate": 5000, "km_rate": 20}
        },
        "sedan": {
          "CNG": {"rate": 4000, "km_rate": 30},
          "Petrol/Diesel": {"rate": 5000, "km_rate": 20}
        }
      }
    }
  };

  final g = [
    {
      'fuelType': 'CNG',
      'vehicleType': 'suv',
      'fixedRate': 4000,
      'extra_km_rate': 30,
      'extra_hr_rate': 20
    },
    {
      'fuelType': 'Petrol/Diesel',
      'vehicleType': 'suv',
      'fixedRate': 5000,
      'extra_km_rate': 20,
      'extra_hr_rate': 10
    },
    {
      'fuelType': 'CNG',
      'vehicleType': 'sedan',
      'fixedRate': 4000,
      'extra_km_rate': 30,
      'extra_hr_rate': 20
    },
    {
      'fuelType': 'Petrol/Diesel',
      'vehicleType': 'sedan',
      'fixedRate': 5000,
      'extra_km_rate': 20,
      'extra_hr_rate': 10
    }
  ];

// Pckage fixed trips
  final d = {
    "fixed_trip": {
      "suv": {
        "Petrol/Diesel": {"2": 2000, "4": 4000}
      },
      "sedan": {
        "CNG": {"2": 3000, "4": 5000}
      }
    }
  };
}
