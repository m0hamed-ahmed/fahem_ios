class ReviewModel {
  final int reviewId;
  final int targetId;
  final String targetName;
  final String timeStamp;

  const ReviewModel({
    required this.reviewId,
    required this.targetId,
    required this.targetName,
    required this.timeStamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'],
      targetId: json['targetId'],
      targetName: json['targetName'],
      timeStamp: json['timeStamp'],
    );
  }

  static Map<String, dynamic> toMap(ReviewModel reviewModel) {
    return {
      'reviewId': reviewModel.reviewId,
      'targetId': reviewModel.targetId,
      'targetName': reviewModel.targetName,
      'timeStamp': reviewModel.timeStamp,
    };
  }

  static List<ReviewModel> fromJsonList (List<dynamic> list) => list.map<ReviewModel>((item) => ReviewModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<ReviewModel> list) => list.map<Map<String, dynamic>>((item) => ReviewModel.toMap(item)).toList();
}