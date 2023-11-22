class LegalAccountantReviewModel {
  final int legalAccountantReviewId;
  final int legalAccountantId;
  final int userAccountId;
  final String firstName;
  final String familyName;
  final String comment;
  final double rating;
  final List<String> featuresAr;
  final List<String> featuresEn;
  final DateTime createdAt;

  LegalAccountantReviewModel({
    required this.legalAccountantReviewId,
    required this.legalAccountantId,
    required this.userAccountId,
    required this.firstName,
    required this.familyName,
    required this.comment,
    required this.rating,
    required this.featuresAr,
    required this.featuresEn,
    required this.createdAt,
  });

  factory LegalAccountantReviewModel.fromJson(Map<String, dynamic> json) {
    return LegalAccountantReviewModel(
      legalAccountantReviewId: int.parse(json['legalAccountantReviewId'].toString()),
      legalAccountantId: int.parse(json['legalAccountantId'].toString()),
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

  static Map<String, dynamic> toMap(LegalAccountantReviewModel legalAccountantReviewModel) {
    return {
      'legalAccountantReviewId': legalAccountantReviewModel.legalAccountantReviewId,
      'legalAccountantId': legalAccountantReviewModel.legalAccountantId,
      'userAccountId': legalAccountantReviewModel.userAccountId,
      'firstName': legalAccountantReviewModel.firstName,
      'familyName': legalAccountantReviewModel.familyName,
      'comment': legalAccountantReviewModel.comment,
      'rating': legalAccountantReviewModel.rating,
      'featuresAr': legalAccountantReviewModel.featuresAr.join('--'),
      'featuresEn': legalAccountantReviewModel.featuresEn.join('--'),
      'createdAt': legalAccountantReviewModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LegalAccountantReviewModel> fromJsonList (List<dynamic> list) => list.map<LegalAccountantReviewModel>((item) => LegalAccountantReviewModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LegalAccountantReviewModel> list) => list.map<Map<String, dynamic>>((item) => LegalAccountantReviewModel.toMap(item)).toList();
}