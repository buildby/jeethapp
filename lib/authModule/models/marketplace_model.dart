class Marketplace {
  final String id;

  String vendername;
  String image;
  num rating;
  num totalSedan;
  num totalSuv;
  num avgFare;
  bool isActive;
  bool isDeleted;

  Marketplace({
    required this.id,
    this.vendername = '',
    this.image = '',
    this.rating = 0,
    this.totalSedan = 0,
    this.totalSuv = 0,
    this.avgFare = 0,
    this.isActive = false,
    this.isDeleted = false,
  });

  static Marketplace jsonToMarketplace(
    Map marketplace, {
    required String accessToken,
  }) =>
      Marketplace(
        id: marketplace['_id'],
        vendername: marketplace['vendername'] ?? '',
        image: marketplace['image'] ?? '',
        rating: marketplace['rating'] ?? 0,
        totalSedan: marketplace['totalSedan'] ?? 0,
        totalSuv: marketplace['totalSuv'] ?? 0,
        avgFare: marketplace['avgFare'] ?? 0,
        isActive: marketplace['isActive'] ?? true,
        isDeleted: marketplace['isDeleted'] ?? false,
      );
}
