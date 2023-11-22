import 'package:fahem/core/utils/enums.dart';

class MessageModel {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final MessageMode messageMode;
  final String timeStamp;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.messageMode,
    required this.timeStamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      text: json['text'],
      messageMode: MessageMode.toMessageMode(json['messageMode']),
      timeStamp: json['timeStamp'],
    );
  }

  static Map<String, dynamic> toMap(MessageModel messageModel) {
    return {
      'messageId': messageModel.messageId,
      'chatId': messageModel.chatId,
      'senderId': messageModel.senderId,
      'text': messageModel.text,
      'messageMode': messageModel.messageMode.name,
      'timeStamp': messageModel.timeStamp,
    };
  }

  static List<MessageModel> fromJsonList (List<dynamic> list) => list.map<MessageModel>((item) => MessageModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<MessageModel> list) => list.map<Map<String, dynamic>>((item) => MessageModel.toMap(item)).toList();
}