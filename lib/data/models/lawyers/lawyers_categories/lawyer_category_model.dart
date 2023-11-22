class LawyerCategoryModel {
  final int lawyerCategoryId;
  final String nameAr;
  final String nameEn;
  final String image;
  final DateTime createdAt;

  const LawyerCategoryModel({
    required this.lawyerCategoryId,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.createdAt,
  });

  factory LawyerCategoryModel.fromJson(Map<String, dynamic> json) {
    return LawyerCategoryModel(
      lawyerCategoryId: int.parse(json['lawyerCategoryId'].toString()),
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      image: json['image'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LawyerCategoryModel lawyerCategoryModel) {
    return {
      'lawyerCategoryId': lawyerCategoryModel.lawyerCategoryId,
      'nameAr': lawyerCategoryModel.nameAr,
      'nameEn': lawyerCategoryModel.nameEn,
      'image': lawyerCategoryModel.image,
      'createdAt': lawyerCategoryModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LawyerCategoryModel> fromJsonList (List<dynamic> list) => list.map<LawyerCategoryModel>((item) => LawyerCategoryModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LawyerCategoryModel> list) => list.map<Map<String, dynamic>>((item) => LawyerCategoryModel.toMap(item)).toList();
}