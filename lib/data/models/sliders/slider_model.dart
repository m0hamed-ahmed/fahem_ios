class SliderModel {
  final int sliderId;
  final String image;
  final String? route;
  final DateTime createdAt;
  
  SliderModel({
    required this.sliderId,
    required this.image,
    this.route,
    required this.createdAt,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      sliderId: int.parse(json['sliderId'].toString()),
      image: json['image'],
      route: json['route'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(SliderModel sliderModel) {
    return {
      'sliderId': sliderModel.sliderId,
      'image': sliderModel.image,
      'route': sliderModel.route,
      'createdAt': sliderModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<SliderModel> fromJsonList (List<dynamic> list) => list.map<SliderModel>((item) => SliderModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<SliderModel> list) => list.map<Map<String, dynamic>>((item) => SliderModel.toMap(item)).toList();
}