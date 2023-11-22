class SuggestedMessageModel {
  final String suggestedMessageId;
  final String message;
  final String answer;
  final int sortNumber;
  String timeStamp;

  SuggestedMessageModel({
    required this.suggestedMessageId,
    required this.message,
    required this.answer,
    required this.sortNumber,
    required this.timeStamp,
  });

  factory SuggestedMessageModel.fromJson(Map<String, dynamic> json) {
    return SuggestedMessageModel(
      suggestedMessageId: json['suggestedMessageId'],
      message: json['message'],
      answer: json['answer'],
      sortNumber: json['sortNumber'],
      timeStamp: json['timeStamp'],
    );
  }

  static Map<String, dynamic> toMap(SuggestedMessageModel suggestedMessageModel) {
    return {
      'suggestedMessageId': suggestedMessageModel.suggestedMessageId,
      'message': suggestedMessageModel.message,
      'answer': suggestedMessageModel.answer,
      'sortNumber': suggestedMessageModel.sortNumber,
      'timeStamp': suggestedMessageModel.timeStamp,
    };
  }

  static List<SuggestedMessageModel> fromJsonList (List<dynamic> list) => list.map<SuggestedMessageModel>((item) => SuggestedMessageModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<SuggestedMessageModel> list) => list.map<Map<String, dynamic>>((item) => SuggestedMessageModel.toMap(item)).toList();
}