import 'package:fahem/data/models/playlists/playlist_comments/playlist_comment_model.dart';
import 'package:fahem/data/models/playlists/videos/video_model.dart';

class PlaylistModel {
  final int playlistId;
  final String image;
  final String playlistNameAr;
  final String playlistNameEn;
  final List<VideoModel> videos;
  final List<PlaylistCommentModel> playlistComments;
  final DateTime createdAt;

  const PlaylistModel({
    required this.playlistId,
    required this.image,
    required this.playlistNameAr,
    required this.playlistNameEn,
    required this.videos,
    required this.playlistComments,
    required this.createdAt,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      playlistId: int.parse(json['playlistId'].toString()),
      image: json['image'],
      playlistNameAr: json['playlistNameAr'],
      playlistNameEn: json['playlistNameEn'],
      videos: VideoModel.fromJsonList(json['videos']),
      playlistComments: PlaylistCommentModel.fromJsonList(json['playlistComments']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(PlaylistModel playlistModel) {
    return {
      'playlistId': playlistModel.playlistId,
      'image': playlistModel.image,
      'playlistNameAr': playlistModel.playlistNameAr,
      'playlistNameEn': playlistModel.playlistNameEn,
      'videos': VideoModel.toMapList(playlistModel.videos),
      'playlistComments': PlaylistCommentModel.toMapList(playlistModel.playlistComments),
      'createdAt': playlistModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PlaylistModel> fromJsonList (List<dynamic> list) => list.map<PlaylistModel>((item) => PlaylistModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PlaylistModel> list) => list.map<Map<String, dynamic>>((item) => PlaylistModel.toMap(item)).toList();
}