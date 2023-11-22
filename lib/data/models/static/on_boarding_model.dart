class OnBoardingModel {
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String image;

  OnBoardingModel({
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.image,
  });
  
  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(
      titleAr: json['titleAr'],
      titleEn: json['titleEn'],
      bodyAr: json['bodyAr'],
      bodyEn: json['bodyEn'],
      image: json['image'],
    );
  }
  
  static Map<String, dynamic> toMap(OnBoardingModel onBoardingModel) {
    return {
      'titleAr': onBoardingModel.titleAr,
      'titleEn': onBoardingModel.titleEn,
      'bodyAr': onBoardingModel.bodyAr,
      'bodyEn': onBoardingModel.bodyEn,
      'image': onBoardingModel.image,
    };
  }

  static List<OnBoardingModel> fromJsonList (List<dynamic> list) => list.map<OnBoardingModel>((item) => OnBoardingModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<OnBoardingModel> list) => list.map<Map<String, dynamic>>((item) => OnBoardingModel.toMap(item)).toList();
}