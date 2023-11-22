class VideoModel {
  final int videoId;
  final int playlistId;
  final String titleAr;
  final String titleEn;
  final String link;
  final String aboutVideoAr;
  final String aboutVideoEn;
  final DateTime createdAt;

  const VideoModel({
    required this.videoId,
    required this.playlistId,
    required this.titleAr,
    required this.titleEn,
    required this.link,
    required this.aboutVideoAr,
    required this.aboutVideoEn,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoId: int.parse(json['videoId'].toString()),
      playlistId: int.parse(json['playlistId'].toString()),
      titleAr: json['titleAr'],
      titleEn: json['titleEn'],
      link: json['link'],
      aboutVideoAr: json['aboutVideoAr'],
      aboutVideoEn: json['aboutVideoEn'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(VideoModel videoModel) {
    return {
      'videoId': videoModel.videoId,
      'playlistId': videoModel.playlistId,
      'titleAr': videoModel.titleAr,
      'titleEn': videoModel.titleEn,
      'link': videoModel.link,
      'aboutVideoAr': videoModel.aboutVideoAr,
      'aboutVideoEn': videoModel.aboutVideoEn,
      'createdAt': videoModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<VideoModel> fromJsonList (List<dynamic> list) => list.map<VideoModel>((item) => VideoModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<VideoModel> list) => list.map<Map<String, dynamic>>((item) => VideoModel.toMap(item)).toList();
}