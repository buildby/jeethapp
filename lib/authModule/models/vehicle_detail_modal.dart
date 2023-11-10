class Vehicle {
  String vehicleModel;
  String vehicleType;
  String vehicleMake;
  String vehicleNumber;
  String vehicleYear;
  String vehicleFuelType;

  Vehicle({
    required this.vehicleModel,
    required this.vehicleType,
    required this.vehicleMake,
    required this.vehicleNumber,
    required this.vehicleYear,
    required this.vehicleFuelType,
  });

  static Vehicle jsonToVehicle(Map vehicle) => Vehicle(
        vehicleMake: vehicle['vehicleMake'] ?? '',
        vehicleModel: vehicle['vehicleModel'] ?? '',
        vehicleType: vehicle['vehicleType'] ?? '',
        vehicleYear: vehicle['vehicleYear'] ?? '',
        vehicleNumber: vehicle['vehicleNumber'] ?? '',
        vehicleFuelType: vehicle['vehicleFuelType'] ?? '',
      );
}
