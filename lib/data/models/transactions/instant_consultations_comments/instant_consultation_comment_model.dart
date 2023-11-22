import 'package:fahem/core/utils/enums.dart';

class InstantConsultationCommentModel {
  final int instantConsultationCommentId;
  final int transactionId;
  final int lawyerId;
  final String comment;
  final CommentStatus commentStatus;
  final DateTime createdAt;

  const InstantConsultationCommentModel({
    required this.instantConsultationCommentId,
    required this.transactionId,
    required this.lawyerId,
    required this.comment,
    required this.commentStatus,
    required this.createdAt,
  });

  factory InstantConsultationCommentModel.fromJson(Map<String, dynamic> json) {
    return InstantConsultationCommentModel(
      instantConsultationCommentId: int.parse(json['instantConsultationCommentId'].toString()),
      transactionId: int.parse(json['transactionId'].toString()),
      lawyerId: int.parse(json['lawyerId'].toString()),
      comment: json['comment'],
      commentStatus: CommentStatus.values.firstWhere((element) => element.name == json['commentStatus']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(InstantConsultationCommentModel instantConsultationCommentModel) {
    return {
      'instantConsultationCommentId': instantConsultationCommentModel.instantConsultationCommentId,
      'transactionId': instantConsultationCommentModel.transactionId,
      'lawyerId': instantConsultationCommentModel.lawyerId,
      'comment': instantConsultationCommentModel.comment,
      'commentStatus': instantConsultationCommentModel.commentStatus.name,
      'createdAt': instantConsultationCommentModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<InstantConsultationCommentModel> fromJsonList (List<dynamic> list) => list.map<InstantConsultationCommentModel>((item) => InstantConsultationCommentModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<InstantConsultationCommentModel> list) => list.map<Map<String, dynamic>>((item) => InstantConsultationCommentModel.toMap(item)).toList();
}