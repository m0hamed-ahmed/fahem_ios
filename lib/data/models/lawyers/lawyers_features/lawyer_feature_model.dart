class LawyerFeatureModel {
  final int lawyerFeatureId;
  final String featureAr;
  final String featureEn;
  final DateTime createdAt;

  const LawyerFeatureModel({
    required this.lawyerFeatureId,
    required this.featureAr,
    required this.featureEn,
    required this.createdAt,
  });

  factory LawyerFeatureModel.fromJson(Map<String, dynamic> json) {
    return LawyerFeatureModel(
      lawyerFeatureId: int.parse(json['lawyerFeatureId'].toString()),
      featureAr: json['featureAr'],
      featureEn: json['featureEn'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LawyerFeatureModel lawyerFeatureModel) {
    return {
      'lawyerFeatureId': lawyerFeatureModel.lawyerFeatureId,
      'featureAr': lawyerFeatureModel.featureAr,
      'featureEn': lawyerFeatureModel.featureEn,
      'createdAt': lawyerFeatureModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LawyerFeatureModel> fromJsonList (List<dynamic> list) => list.map<LawyerFeatureModel>((item) => LawyerFeatureModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LawyerFeatureModel> list) => list.map<Map<String, dynamic>>((item) => LawyerFeatureModel.toMap(item)).toList();
}