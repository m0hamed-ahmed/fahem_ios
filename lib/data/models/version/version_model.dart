class VersionModel {
  final String version;
  final bool isMustUpdate;
  final bool isReview;

  VersionModel({
    required this.version,
    required this.isMustUpdate,
    required this.isReview,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      version: json['version'],
      isMustUpdate: json['isMustUpdate'],
      isReview: json['isReview'],
    );
  }

  static Map<String, dynamic> toMap(VersionModel versionModel) {
    return {
      'version': versionModel.version,
      'isMustUpdate': versionModel.isMustUpdate,
      'isReview': versionModel.isReview,
    };
  }
}