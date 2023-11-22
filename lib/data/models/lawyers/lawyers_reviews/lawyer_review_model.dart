class LawyerReviewModel {
  final int lawyerReviewId;
  final int lawyerId;
  final int userAccountId;
  final String firstName;
  final String familyName;
  final String comment;
  final double rating;
  final List<String> featuresAr;
  final List<String> featuresEn;
  final DateTime createdAt;

  LawyerReviewModel({
    required this.lawyerReviewId,
    required this.lawyerId,
    required this.userAccountId,
    required this.firstName,
    required this.familyName,
    required this.comment,
    required this.rating,
    required this.featuresAr,
    required this.featuresEn,
    required this.createdAt,
  });

  factory LawyerReviewModel.fromJson(Map<String, dynamic> json) {
    return LawyerReviewModel(
      lawyerReviewId: int.parse(json['lawyerReviewId'].toString()),
      lawyerId: int.parse(json['lawyerId'].toString()),
      userAccountId: int.parse(json['userAccountId'].toString()),
      firstName: json['firstName'],
      familyName: json['familyName'],
      comment: json['comment'],
      rating: double.parse(json['rating'].toString()),
      featuresAr: json['featuresAr'].toString().isEmpty ? [] : json['featuresAr'].toString().split('--'),
      featuresEn: json['featuresEn'].toString().isEmpty ? [] : json['featuresEn'].toString().split('--'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LawyerReviewModel lawyerReviewModel) {
    return {
      'lawyerReviewId': lawyerReviewModel.lawyerReviewId,
      'lawyerId': lawyerReviewModel.lawyerId,
      'userAccountId': lawyerReviewModel.userAccountId,
      'firstName': lawyerReviewModel.firstName,
      'familyName': lawyerReviewModel.familyName,
      'comment': lawyerReviewModel.comment,
      'rating': lawyerReviewModel.rating,
      'featuresAr': lawyerReviewModel.featuresAr.join('--'),
      'featuresEn': lawyerReviewModel.featuresEn.join('--'),
      'createdAt': lawyerReviewModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LawyerReviewModel> fromJsonList (List<dynamic> list) => list.map<LawyerReviewModel>((item) => LawyerReviewModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LawyerReviewModel> list) => list.map<Map<String, dynamic>>((item) => LawyerReviewModel.toMap(item)).toList();
}