import 'package:fahem/core/utils/enums.dart';

class UserAccountModel {
  final int userAccountId;
  final String phoneNumber;
  final String firstName;
  final String familyName;
  final Gender gender;
  final DateTime birthDate;
  final String? emailAddress;
  final String? reasonForRegistration;
  final DateTime createdAt;

  const UserAccountModel({
    required this.userAccountId,
    required this.phoneNumber,
    required this.firstName,
    required this.familyName,
    required this.gender,
    required this.birthDate,
    required this.emailAddress,
    required this.reasonForRegistration,
    required this.createdAt,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
      userAccountId: int.parse(json['userAccountId'].toString()),
      phoneNumber: json['phoneNumber'],
      firstName: json['firstName'],
      familyName: json['familyName'],
      gender: Gender.toGender(json['gender']),
      birthDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json['birthDate'])),
      emailAddress: json['emailAddress'],
      reasonForRegistration: json['reasonForRegistration'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(UserAccountModel userAccountModel) {
    return {
      'userAccountId': userAccountModel.userAccountId,
      'phoneNumber': userAccountModel.phoneNumber,
      'firstName': userAccountModel.firstName,
      'familyName': userAccountModel.familyName,
      'gender': userAccountModel.gender.name,
      'birthDate': userAccountModel.birthDate.millisecondsSinceEpoch.toString(),
      'emailAddress': userAccountModel.emailAddress,
      'reasonForRegistration': userAccountModel.reasonForRegistration,
      'createdAt': userAccountModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<UserAccountModel> fromJsonList (List<dynamic> list) => list.map<UserAccountModel>((item) => UserAccountModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<UserAccountModel> list) => list.map<Map<String, dynamic>>((item) => UserAccountModel.toMap(item)).toList();
}