class JobModel {
  final int jobId;
  final int targetId;
  final String targetName;
  String image;
  final String jobTitle;
  final String companyName;
  final String aboutCompany;
  final int minSalary;
  final int maxSalary;
  final String jobLocation;
  final List<String> features;
  final String details;
  final bool isAvailable;
  final DateTime createdAt;

  JobModel({
    required this.jobId,
    required this.targetId,
    required this.targetName,
    required this.image,
    required this.jobTitle,
    required this.companyName,
    required this.aboutCompany,
    required this.minSalary,
    required this.maxSalary,
    required this.jobLocation,
    required this.features,
    required this.details,
    required this.isAvailable,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobId: int.parse(json['jobId'].toString()),
      targetId: int.parse(json['targetId'].toString()),
      targetName: json['targetName'],
      image: json['image'],
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
      aboutCompany: json['aboutCompany'],
      minSalary: int.parse(json['minSalary'].toString()),
      maxSalary: int.parse(json['maxSalary'].toString()),
      jobLocation: json['jobLocation'],
      features: json['features'].toString().isEmpty ? [] : json['features'].toString().split('--'),
      details: json['details'],
      isAvailable: json['isAvailable'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(JobModel jobModel) {
    return {
      'jobId': jobModel.jobId,
      'targetId': jobModel.targetId,
      'targetName': jobModel.targetName,
      'image': jobModel.image,
      'jobTitle': jobModel.jobTitle,
      'companyName': jobModel.companyName,
      'aboutCompany': jobModel.aboutCompany,
      'minSalary': jobModel.minSalary,
      'maxSalary': jobModel.maxSalary,
      'jobLocation': jobModel.jobLocation,
      'features': jobModel.features.join('--'),
      'details': jobModel.details,
      'isAvailable': jobModel.isAvailable,
      'createdAt': jobModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<JobModel> fromJsonList (List<dynamic> list) => list.map<JobModel>((item) => JobModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<JobModel> list) => list.map<Map<String, dynamic>>((item) => JobModel.toMap(item)).toList();
}