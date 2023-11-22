class EmploymentApplicationModel {
  final int employmentApplicationId;
  final int userAccountId;
  final int jobId;
  final int targetId;
  final String targetName;
  final String name;
  final String phoneNumber;
  String cv;
  final DateTime createdAt;

  EmploymentApplicationModel({
    required this.employmentApplicationId,
    required this.userAccountId,
    required this.jobId,
    required this.targetId,
    required this.targetName,
    required this.name,
    required this.phoneNumber,
    required this.cv,
    required this.createdAt,
  });

  factory EmploymentApplicationModel.fromJson(Map<String, dynamic> json) {
    return EmploymentApplicationModel(
      employmentApplicationId: int.parse(json['employmentApplicationId'].toString()),
      userAccountId: int.parse(json['userAccountId'].toString()),
      jobId: int.parse(json['jobId'].toString()),
      targetId: int.parse(json['targetId'].toString()),
      targetName: json['targetName'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      cv: json['cv'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(EmploymentApplicationModel employmentApplicationModel) {
    return {
      'employmentApplicationId': employmentApplicationModel.employmentApplicationId,
      'userAccountId': employmentApplicationModel.userAccountId,
      'jobId': employmentApplicationModel.jobId,
      'targetId': employmentApplicationModel.targetId,
      'targetName': employmentApplicationModel.targetName,
      'name': employmentApplicationModel.name,
      'phoneNumber': employmentApplicationModel.phoneNumber,
      'cv': employmentApplicationModel.cv,
      'createdAt': employmentApplicationModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<EmploymentApplicationModel> fromJsonList (List<dynamic> list) => list.map<EmploymentApplicationModel>((item) => EmploymentApplicationModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<EmploymentApplicationModel> list) => list.map<Map<String, dynamic>>((item) => EmploymentApplicationModel.toMap(item)).toList();
}