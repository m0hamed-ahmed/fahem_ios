class PeriodModel {
  final String periodId;
  final String nameAr;
  final String nameEn;

  PeriodModel({
    required this.periodId,
    required this.nameAr,
    required this.nameEn,
  });

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      periodId: json['periodId'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  static Map<String, dynamic> toMap(PeriodModel periodModel) {
    return {
      'periodId': periodModel.periodId,
      'nameAr': periodModel.nameAr,
      'nameEn': periodModel.nameEn,
    };
  }

  static List<PeriodModel> fromJsonList (List<dynamic> list) => list.map<PeriodModel>((item) => PeriodModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PeriodModel> list) => list.map<Map<String, dynamic>>((item) => PeriodModel.toMap(item)).toList();
}