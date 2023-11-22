class PublicRelationCategoryModel {
  final int publicRelationCategoryId;
  final String nameAr;
  final String nameEn;
  final String image;
  final DateTime createdAt;

  const PublicRelationCategoryModel({
    required this.publicRelationCategoryId,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.createdAt,
  });

  factory PublicRelationCategoryModel.fromJson(Map<String, dynamic> json) {
    return PublicRelationCategoryModel(
      publicRelationCategoryId: int.parse(json['publicRelationCategoryId'].toString()),
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      image: json['image'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(PublicRelationCategoryModel publicRelationCategoryModel) {
    return {
      'publicRelationCategoryId': publicRelationCategoryModel.publicRelationCategoryId,
      'nameAr': publicRelationCategoryModel.nameAr,
      'nameEn': publicRelationCategoryModel.nameEn,
      'image': publicRelationCategoryModel.image,
      'createdAt': publicRelationCategoryModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PublicRelationCategoryModel> fromJsonList (List<dynamic> list) => list.map<PublicRelationCategoryModel>((item) => PublicRelationCategoryModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PublicRelationCategoryModel> list) => list.map<Map<String, dynamic>>((item) => PublicRelationCategoryModel.toMap(item)).toList();
}