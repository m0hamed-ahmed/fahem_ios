class SettingsModel {
  final int instantConsultationPrice;
  final int secretConsultationPrice;
  final int distanceKm;
  
  SettingsModel({
    required this.instantConsultationPrice,
    required this.secretConsultationPrice,
    required this.distanceKm,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      instantConsultationPrice: int.parse(json['instantConsultationPrice'].toString()),
      secretConsultationPrice: int.parse(json['secretConsultationPrice'].toString()),
      distanceKm: int.parse(json['distanceKm'].toString()),
    );
  }

  static Map<String, dynamic> toMap(SettingsModel settingsModel) {
    return {
      'instantConsultationPrice': settingsModel.instantConsultationPrice,
      'secretConsultationPrice': settingsModel.secretConsultationPrice,
      'distanceKm': settingsModel.distanceKm,
    };
  }

  static List<SettingsModel> fromJsonList (List<dynamic> list) => list.map<SettingsModel>((item) => SettingsModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<SettingsModel> list) => list.map<Map<String, dynamic>>((item) => SettingsModel.toMap(item)).toList();
}