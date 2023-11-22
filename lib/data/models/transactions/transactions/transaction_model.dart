import 'package:fahem/core/utils/enums.dart';

class TransactionModel {
  final int transactionId;
  final int targetId;
  final int userAccountId;
  final String name;
  final String phoneNumber;
  final String? emailAddress;
  final String textAr;
  final String textEn;
  final String? bookingDateTimeStamp;
  final TransactionType transactionType;
  final bool? isDoneInstantConsultation;
  final bool isViewed;
  final DateTime createdAt;

  const TransactionModel({
    required this.transactionId,
    required this.targetId,
    required this.userAccountId,
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.textAr,
    required this.textEn,
    this.bookingDateTimeStamp,
    required this.transactionType,
    this.isDoneInstantConsultation,
    required this.isViewed,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: int.parse(json['transactionId'].toString()),
      targetId: int.parse(json['targetId'].toString()),
      userAccountId: int.parse(json['userAccountId'].toString()),
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      emailAddress: json['emailAddress'],
      textAr: json['textAr'],
      textEn: json['textEn'],
      bookingDateTimeStamp: json['bookingDateTimeStamp'],
      transactionType: TransactionType.toTransactionType(json['transactionType']),
      isDoneInstantConsultation: json['isDoneInstantConsultation'],
      isViewed: json['isViewed'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(TransactionModel transactionModel) {
    return {
      'transactionId': transactionModel.transactionId,
      'targetId': transactionModel.targetId,
      'userAccountId': transactionModel.userAccountId,
      'name': transactionModel.name,
      'phoneNumber': transactionModel.phoneNumber,
      'emailAddress': transactionModel.emailAddress,
      'textAr': transactionModel.textAr,
      'textEn': transactionModel.textEn,
      'bookingDateTimeStamp': transactionModel.bookingDateTimeStamp,
      'transactionType': transactionModel.transactionType.name,
      'isDoneInstantConsultation': transactionModel.isDoneInstantConsultation,
      'isViewed': transactionModel.isViewed,
      'createdAt': transactionModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<TransactionModel> fromJsonList (List<dynamic> list) => list.map<TransactionModel>((item) => TransactionModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<TransactionModel> list) => list.map<Map<String, dynamic>>((item) => TransactionModel.toMap(item)).toList();
}