import 'package:fahem/core/utils/enums.dart';

class GovernmentModel {
  final GovernoratesMode governoratesMode;
  final String nameAr;
  final String nameEn;
  double latitude;
  double longitude;

  GovernmentModel({
    required this.governoratesMode,
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
  });

  factory GovernmentModel.fromJson(Map<String, dynamic> json) {
    return GovernmentModel(
      governoratesMode: GovernoratesMode.toGovernoratesMode(json['governoratesMode']),
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  static Map<String, dynamic> toMap(GovernmentModel governmentModel) {
    return {
      'governoratesMode': governmentModel.governoratesMode.name,
      'nameAr': governmentModel.nameAr,
      'nameEn': governmentModel.nameEn,
      'latitude': governmentModel.latitude,
      'longitude': governmentModel.longitude,
    };
  }

  static List<GovernmentModel> fromJsonList (List<dynamic> list) => list.map<GovernmentModel>((item) => GovernmentModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<GovernmentModel> list) => list.map<Map<String, dynamic>>((item) => GovernmentModel.toMap(item)).toList();
}