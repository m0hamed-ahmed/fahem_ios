import 'package:fahem/core/utils/enums.dart';

class FahemServiceModel {
  final FahemServiceType fahemServiceType;
  final String image;
  final String nameAr;
  final String nameEn;
  final String route;

  FahemServiceModel({
    required this.fahemServiceType,
    required this.image,
    required this.nameAr,
    required this.nameEn,
    required this.route,
  });

  factory FahemServiceModel.fromJson(Map<String, dynamic> json) {
    return FahemServiceModel(
      fahemServiceType: json['fahemServiceType'],
      image: json['image'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      route: json['route'],
    );
  }

  static Map<String, dynamic> toMap(FahemServiceModel fahemServiceModel) {
    return {
      'fahemServiceType': fahemServiceModel.fahemServiceType,
      'image': fahemServiceModel.image,
      'nameAr': fahemServiceModel.nameAr,
      'nameEn': fahemServiceModel.nameEn,
      'route': fahemServiceModel.route,
    };
  }

  static List<FahemServiceModel> fromJsonList (List<dynamic> list) => list.map<FahemServiceModel>((item) => FahemServiceModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<FahemServiceModel> list) => list.map<Map<String, dynamic>>((item) => FahemServiceModel.toMap(item)).toList();
}