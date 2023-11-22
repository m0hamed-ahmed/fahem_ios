import 'package:fahem/core/utils/enums.dart';

class PublicRelationModel {
  final int publicRelationId;
  final String name;
  final String emailAddress;
  final String password;
  final String mainCategory;
  final List<String> categoriesIds;
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

  PublicRelationModel({
    required this.publicRelationId,
    required this.name,
    required this.emailAddress,
    required this.password,
    required this.mainCategory,
    required this.categoriesIds,
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

  factory PublicRelationModel.fromJson(Map<String, dynamic> json) {
    return PublicRelationModel(
      publicRelationId: int.parse(json['publicRelationId'].toString()),
      name: json['name'],
      emailAddress: json['emailAddress'],
      password: json['password'],
      mainCategory: json['mainCategory'],
      categoriesIds: json['categoriesIds'].toString().isEmpty ? [] : json['categoriesIds'].toString().split('--'),
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

  static Map<String, dynamic> toMap(PublicRelationModel publicRelationModel) {
    return {
      'publicRelationId': publicRelationModel.publicRelationId,
      'name': publicRelationModel.name,
      'emailAddress': publicRelationModel.emailAddress,
      'password': publicRelationModel.password,
      'mainCategory': publicRelationModel.mainCategory,
      'categoriesIds': publicRelationModel.categoriesIds.join('--'),
      'personalImage': publicRelationModel.personalImage,
      'jobTitle': publicRelationModel.jobTitle,
      'address': publicRelationModel.address,
      'information': publicRelationModel.information,
      'phoneNumber': publicRelationModel.phoneNumber,
      'consultationPrice': publicRelationModel.consultationPrice,
      'tasks': publicRelationModel.tasks.join('--'),
      'features': publicRelationModel.features.join('--'),
      'images': publicRelationModel.images.join('--'),
      'latitude': publicRelationModel.latitude,
      'longitude': publicRelationModel.longitude,
      'governorate': publicRelationModel.governorate,
      'accountStatus': publicRelationModel.accountStatus.name,
      'isVerified': publicRelationModel.isVerified,
      'isBookingByAppointment': publicRelationModel.isBookingByAppointment,
      'availablePeriods': publicRelationModel.availablePeriods.join('--'),
      'identificationImages': publicRelationModel.identificationImages.join('--'),
      'rating': publicRelationModel.rating,
      'createdAt': publicRelationModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<PublicRelationModel> fromJsonList (List<dynamic> list) => list.map<PublicRelationModel>((item) => PublicRelationModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<PublicRelationModel> list) => list.map<Map<String, dynamic>>((item) => PublicRelationModel.toMap(item)).toList();
}