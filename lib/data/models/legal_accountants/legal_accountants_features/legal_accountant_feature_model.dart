class LegalAccountantFeatureModel {
  final int legalAccountantFeatureId;
  final String featureAr;
  final String featureEn;
  final DateTime createdAt;

  const LegalAccountantFeatureModel({
    required this.legalAccountantFeatureId,
    required this.featureAr,
    required this.featureEn,
    required this.createdAt,
  });

  factory LegalAccountantFeatureModel.fromJson(Map<String, dynamic> json) {
    return LegalAccountantFeatureModel(
      legalAccountantFeatureId: int.parse(json['legalAccountantFeatureId'].toString()),
      featureAr: json['featureAr'],
      featureEn: json['featureEn'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LegalAccountantFeatureModel legalAccountantFeatureModel) {
    return {
      'legalAccountantFeatureId': legalAccountantFeatureModel.legalAccountantFeatureId,
      'featureAr': legalAccountantFeatureModel.featureAr,
      'featureEn': legalAccountantFeatureModel.featureEn,
      'createdAt': legalAccountantFeatureModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LegalAccountantFeatureModel> fromJsonList (List<dynamic> list) => list.map<LegalAccountantFeatureModel>((item) => LegalAccountantFeatureModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LegalAccountantFeatureModel> list) => list.map<Map<String, dynamic>>((item) => LegalAccountantFeatureModel.toMap(item)).toList();
}