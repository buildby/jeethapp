class Vendor {
  final int id;
  String name;
  String phone;

  Vendor({
    required this.id,
    required this.name,
    required this.phone,
  });

  static Vendor jsonToVendor(Map vendor) => Vendor(
        id: vendor['id'],
        name: vendor['name'] ?? '',
        phone: vendor['phone'] ?? '',
      );
}

final a = {
  "fixed_trip": {
    "suv": {
      "Petrol/Diesel": {"2": 2000, "4": 4000}
    },
    "sedan": {
      "CNG": {"2": 3000, "4": 5000},
      "Petrol/Diesel": {"2": 2000, "4": 4000},
      "EV": {"2": 2000, "4": 4000}
    }
  }
};

final b = {
  "fixed_trip": {
    "suv": {
      "Petrol/Diesel": {"2": 2000, "4": 4000}
    },
    "sedan": {
      "EV": {"2": 2000, "4": 4000},
      "CNG": {"2": 3000, "4": 5000},
      "Petrol/Diesel": {"2": 2000, "4": 4000}
    }
  }
};
