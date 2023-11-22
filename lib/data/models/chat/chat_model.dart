class ChatModel {
  final String chatId;
  final String name;
  final String lastMessage;
  final String timeStamp;

  ChatModel({
    required this.chatId,
    required this.name,
    required this.lastMessage,
    required this.timeStamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      timeStamp: json['timeStamp'],
    );
  }

  static Map<String, dynamic> toMap(ChatModel chatModel) {
    return {
      'chatId': chatModel.chatId,
      'name': chatModel.name,
      'lastMessage': chatModel.lastMessage,
      'timeStamp': chatModel.timeStamp,
    };
  }

  static List<ChatModel> fromJsonList (List<dynamic> list) => list.map<ChatModel>((item) => ChatModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<ChatModel> list) => list.map<Map<String, dynamic>>((item) => ChatModel.toMap(item)).toList();
}