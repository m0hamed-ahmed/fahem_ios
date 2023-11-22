class PackageModel {
  final int packageId;
  final String nameAr;
  final String nameEn;
  final List<String> featuresAr;
  final List<String> featuresEn;
  final int price;
  final DateTime createdAt;

  const PackageModel({
    required this.packageId,
    required this.nameAr,
    required this.nameEn,
    required this.featuresAr,
    required this.featuresEn,
    required this.price,
    required this.createdAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: int.parse(json['packageId'].toString()),
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      featuresAr: json['featuresAr'].toString().isEmpty ? [] : json['featuresAr'].toString().split('--'),
      featuresEn: json['featuresEn'].toString().isEmpty ? [] : json['featuresEn'].toString().split('--'),
      price: int.parse(json['price'].toString()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(PackageModel packageModel) {
    return {
      'packageId': packageModel.packageId,
      'nameAr': packageModel.nameAr,
      'nameEn': packageModel.nameEn,
      'featuresAr': packageModel.featuresAr.join('--'),
      'featuresEn': packageModel.featuresEn.join('--'),
      'price': packageModel.price,
      'createdAt': packageModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PackageModel> fromJsonList (List<dynamic> list) => list.map<PackageModel>((item) => PackageModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PackageModel> list) => list.map<Map<String, dynamic>>((item) => PackageModel.toMap(item)).toList();
}