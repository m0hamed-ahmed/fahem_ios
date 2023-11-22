class PublicRelationReviewModel {
  final int publicRelationReviewId;
  final int publicRelationId;
  final int userAccountId;
  final String firstName;
  final String familyName;
  final String comment;
  final double rating;
  final List<String> featuresAr;
  final List<String> featuresEn;
  final DateTime createdAt;

  PublicRelationReviewModel({
    required this.publicRelationReviewId,
    required this.publicRelationId,
    required this.userAccountId,
    required this.firstName,
    required this.familyName,
    required this.comment,
    required this.rating,
    required this.featuresAr,
    required this.featuresEn,
    required this.createdAt,
  });

  factory PublicRelationReviewModel.fromJson(Map<String, dynamic> json) {
    return PublicRelationReviewModel(
      publicRelationReviewId: int.parse(json['publicRelationReviewId'].toString()),
      publicRelationId: int.parse(json['publicRelationId'].toString()),
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

  static Map<String, dynamic> toMap(PublicRelationReviewModel publicRelationReviewModel) {
    return {
      'publicRelationReviewId': publicRelationReviewModel.publicRelationReviewId,
      'publicRelationId': publicRelationReviewModel.publicRelationId,
      'userAccountId': publicRelationReviewModel.userAccountId,
      'firstName': publicRelationReviewModel.firstName,
      'familyName': publicRelationReviewModel.familyName,
      'comment': publicRelationReviewModel.comment,
      'rating': publicRelationReviewModel.rating,
      'featuresAr': publicRelationReviewModel.featuresAr.join('--'),
      'featuresEn': publicRelationReviewModel.featuresEn.join('--'),
      'createdAt': publicRelationReviewModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PublicRelationReviewModel> fromJsonList (List<dynamic> list) => list.map<PublicRelationReviewModel>((item) => PublicRelationReviewModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PublicRelationReviewModel> list) => list.map<Map<String, dynamic>>((item) => PublicRelationReviewModel.toMap(item)).toList();
}