import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/models/marketplace_model.dart';

class MarketplaceProvider with ChangeNotifier {
  final List<Marketplace> _marketplaces = [
    Marketplace(
      id: '1',
      vendername: 'Shyam Salasar Lo',
      image: 'assets/images/hcl.png',
      companyName: 'HCL',
      rating: 4.2,
      totalSedan: 22,
      totalSuv: 13,
      avgFare: 650,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '2',
      vendername: '4 Wheel Tours and Travels',
      image: 'assets/images/google.png',
      companyName: 'Google LLC',
      rating: 4.5,
      totalSedan: 13,
      totalSuv: 31,
      avgFare: 840.0,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '3',
      vendername: 'Sreenija Tours and Travels',
      image: 'assets/images/ibm.png',
      companyName: 'IBM',
      rating: 3.8,
      totalSedan: 23,
      totalSuv: 14,
      avgFare: 560.0,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '4',
      vendername: 'Shyam Salasar Lo',
      image: 'assets/images/hcl.png',
      companyName: 'HCL',
      rating: 4.2,
      totalSedan: 22,
      totalSuv: 13,
      avgFare: 650,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '5',
      vendername: '4 Wheel Tours and Travels',
      image: 'assets/images/google.png',
      companyName: 'Google LLC',
      rating: 4.5,
      totalSedan: 13,
      totalSuv: 31,
      avgFare: 840.0,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '6',
      vendername: 'Sreenija Tours and Travels',
      image: 'assets/images/ibm.png',
      companyName: 'IBM',
      rating: 3.8,
      totalSedan: 23,
      totalSuv: 14,
      avgFare: 560.0,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '7',
      vendername: 'Shyam Salasar Lo',
      image: 'assets/images/hcl.png',
      companyName: 'HCL',
      rating: 4.2,
      totalSedan: 22,
      totalSuv: 13,
      avgFare: 650,
      isActive: true,
      isDeleted: false,
    ),
    Marketplace(
      id: '8',
      vendername: '4 Wheel Tours and Travels',
      image: 'assets/images/google.png',
      companyName: 'Google LLC',
      rating: 4.5,
      totalSedan: 13,
      totalSuv: 31,
      avgFare: 840.0,
      isActive: true,
      isDeleted: false,
    ),
  ];

  List<Marketplace> get marketplaces => [..._marketplaces];
}
