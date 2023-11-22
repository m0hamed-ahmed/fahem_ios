class LogModel {
  final int logId;
  final int userAccountId;
  final String textAr;
  final String textEn;
  final DateTime createdAt;

  const LogModel({
    required this.logId,
    required this.userAccountId,
    required this.textAr,
    required this.textEn,
    required this.createdAt,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      logId: int.parse(json['logId'].toString()),
      userAccountId: int.parse(json['userAccountId'].toString()),
      textAr: json['textAr'],
      textEn: json['textEn'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LogModel logModel) {
    return {
      'logId': logModel.logId,
      'userAccountId': logModel.userAccountId,
      'textAr': logModel.textAr,
      'textEn': logModel.textEn,
      'createdAt': logModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LogModel> fromJsonList (List<dynamic> list) => list.map<LogModel>((item) => LogModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LogModel> list) => list.map<Map<String, dynamic>>((item) => LogModel.toMap(item)).toList();
}