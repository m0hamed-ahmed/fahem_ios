class PublicRelationFeatureModel {
  final int publicRelationFeatureId;
  final String featureAr;
  final String featureEn;
  final DateTime createdAt;

  const PublicRelationFeatureModel({
    required this.publicRelationFeatureId,
    required this.featureAr,
    required this.featureEn,
    required this.createdAt,
  });

  factory PublicRelationFeatureModel.fromJson(Map<String, dynamic> json) {
    return PublicRelationFeatureModel(
      publicRelationFeatureId: int.parse(json['publicRelationFeatureId'].toString()),
      featureAr: json['featureAr'],
      featureEn: json['featureEn'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(PublicRelationFeatureModel publicRelationFeatureModel) {
    return {
      'publicRelationFeatureId': publicRelationFeatureModel.publicRelationFeatureId,
      'featureAr': publicRelationFeatureModel.featureAr,
      'featureEn': publicRelationFeatureModel.featureEn,
      'createdAt': publicRelationFeatureModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PublicRelationFeatureModel> fromJsonList (List<dynamic> list) => list.map<PublicRelationFeatureModel>((item) => PublicRelationFeatureModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PublicRelationFeatureModel> list) => list.map<Map<String, dynamic>>((item) => PublicRelationFeatureModel.toMap(item)).toList();
}