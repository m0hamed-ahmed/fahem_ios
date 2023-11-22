import 'package:fahem/core/utils/enums.dart';

class LegalAccountantModel {
  final int legalAccountantId;
  final String name;
  final String emailAddress;
  final String password;
  final String mainCategory;
  String personalImage;
  final String jobTitle;
  final String address;
  final String information;
  final String phoneNumber;
  final int consultationPrice;
  final List<String> tasks;
  final List<String> features;
  final List<String> images;
  final double latitude;
  final double longitude;
  final String governorate;
  AccountStatus accountStatus;
  final bool isVerified;
  final bool isBookingByAppointment;
  final List<String> availablePeriods;
  final List<String> identificationImages;
  final double rating;
  final DateTime createdAt;

  LegalAccountantModel({
    required this.legalAccountantId,
    required this.name,
    required this.emailAddress,
    required this.password,
    required this.mainCategory,
    required this.personalImage,
    required this.jobTitle,
    required this.address,
    required this.information,
    required this.phoneNumber,
    required this.consultationPrice,
    required this.tasks,
    required this.features,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.governorate,
    required this.accountStatus,
    required this.isVerified,
    required this.isBookingByAppointment,
    required this.availablePeriods,
    required this.identificationImages,
    required this.rating,
    required this.createdAt,
  });

  factory LegalAccountantModel.fromJson(Map<String, dynamic> json) {
    return LegalAccountantModel(
      legalAccountantId: int.parse(json['legalAccountantId'].toString()),
      name: json['name'],
      emailAddress: json['emailAddress'],
      password: json['password'],
      mainCategory: json['mainCategory'],
      personalImage: json['personalImage'],
      jobTitle: json['jobTitle'],
      address: json['address'],
      information: json['information'],
      phoneNumber: json['phoneNumber'],
      consultationPrice: int.parse(json['consultationPrice'].toString()),
      tasks: json['tasks'].toString().isEmpty ? [] : json['tasks'].toString().split('--'),
      features: json['features'].toString().isEmpty ? [] : json['features'].toString().split('--'),
      images: json['images'].toString().isEmpty ? [] : json['images'].toString().split('--'),
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      governorate: json['governorate'],
      accountStatus: AccountStatus.toAccountStatus(json['accountStatus']),
      isVerified: json['isVerified'],
      isBookingByAppointment: json['isBookingByAppointment'],
      availablePeriods: json['availablePeriods'].toString().isEmpty ? [] : json['availablePeriods'].toString().split('--'),
      identificationImages: json['identificationImages'].toString().isEmpty ? [] : json['identificationImages'].toString().split('--'),
      rating: double.parse(json['rating'].toString()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LegalAccountantModel legalAccountantModel) {
    return {
      'legalAccountantId': legalAccountantModel.legalAccountantId,
      'name': legalAccountantModel.name,
      'emailAddress': legalAccountantModel.emailAddress,
      'password': legalAccountantModel.password,
      'mainCategory': legalAccountantModel.mainCategory,
      'personalImage': legalAccountantModel.personalImage,
      'jobTitle': legalAccountantModel.jobTitle,
      'address': legalAccountantModel.address,
      'information': legalAccountantModel.information,
      'phoneNumber': legalAccountantModel.phoneNumber,
      'consultationPrice': legalAccountantModel.consultationPrice,
      'tasks': legalAccountantModel.tasks.join('--'),
      'features': legalAccountantModel.features.join('--'),
      'images': legalAccountantModel.images.join('--'),
      'latitude': legalAccountantModel.latitude,
      'longitude': legalAccountantModel.longitude,
      'governorate': legalAccountantModel.governorate,
      'accountStatus': legalAccountantModel.accountStatus.name,
      'isVerified': legalAccountantModel.isVerified,
      'isBookingByAppointment': legalAccountantModel.isBookingByAppointment,
      'availablePeriods': legalAccountantModel.availablePeriods.join('--'),
      'identificationImages': legalAccountantModel.identificationImages.join('--'),
      'rating': legalAccountantModel.rating,
      'createdAt': legalAccountantModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LegalAccountantModel> fromJsonList (List<dynamic> list) => list.map<LegalAccountantModel>((item) => LegalAccountantModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LegalAccountantModel> list) => list.map<Map<String, dynamic>>((item) => LegalAccountantModel.toMap(item)).toList();
}