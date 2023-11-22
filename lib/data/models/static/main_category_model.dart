class MainCategoryModel {
  final int mainCategoryId;
  final String image;
  final String nameAr;
  final String nameEn;
  final String route;
  final String timeStamp;

  MainCategoryModel({
    required this.mainCategoryId,
    required this.image,
    required this.nameAr,
    required this.nameEn,
    required this.route,
    required this.timeStamp,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      mainCategoryId: json['mainCategoryId'],
      image: json['image'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      route: json['route'],
      timeStamp: json['timeStamp'],
    );
  }

  static Map<String, dynamic> toMap(MainCategoryModel mainCategoryModel) {
    return {
      'mainCategoryId': mainCategoryModel.mainCategoryId,
      'image': mainCategoryModel.image,
      'nameAr': mainCategoryModel.nameAr,
      'nameEn': mainCategoryModel.nameEn,
      'route': mainCategoryModel.route,
      'timeStamp': mainCategoryModel.timeStamp,
    };
  }

  static List<MainCategoryModel> fromJsonList (List<dynamic> list) => list.map<MainCategoryModel>((item) => MainCategoryModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<MainCategoryModel> list) => list.map<Map<String, dynamic>>((item) => MainCategoryModel.toMap(item)).toList();
}