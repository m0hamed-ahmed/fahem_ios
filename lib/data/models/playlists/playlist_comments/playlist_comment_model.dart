class PlaylistCommentModel {
  final int playlistCommentId;
  final int playlistId;
  final int userAccountId;
  final String firstName;
  final String familyName;
  final String comment;
  final DateTime createdAt;

  const PlaylistCommentModel({
    required this.playlistCommentId,
    required this.playlistId,
    required this.userAccountId,
    required this.firstName,
    required this.familyName,
    required this.comment,
    required this.createdAt,
  });

  factory PlaylistCommentModel.fromJson(Map<String, dynamic> json) {
    return PlaylistCommentModel(
      playlistCommentId: int.parse(json['playlistCommentId'].toString()),
      playlistId: int.parse(json['playlistId'].toString()),
      userAccountId: int.parse(json['userAccountId'].toString()),
      firstName: json['firstName'],
      familyName: json['familyName'],
      comment: json['comment'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(PlaylistCommentModel playlistCommentModel) {
    return {
      'playlistCommentId': playlistCommentModel.playlistCommentId,
      'playlistId': playlistCommentModel.playlistId,
      'userAccountId': playlistCommentModel.userAccountId,
      'firstName': playlistCommentModel.firstName,
      'familyName': playlistCommentModel.familyName,
      'comment': playlistCommentModel.comment,
      'createdAt': playlistCommentModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PlaylistCommentModel> fromJsonList (List<dynamic> list) => list.map<PlaylistCommentModel>((item) => PlaylistCommentModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PlaylistCommentModel> list) => list.map<Map<String, dynamic>>((item) => PlaylistCommentModel.toMap(item)).toList();
}