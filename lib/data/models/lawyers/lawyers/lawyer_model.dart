import 'package:fahem/core/utils/enums.dart';

class LawyerModel {
  final int lawyerId;
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
  final bool isBookingByAppointment;
  final List<String> availablePeriods;
  final List<String> identificationImages;
  final bool isVerified;
  final bool isSubscriberToInstantLawyerService;
  final bool isSubscriberToInstantConsultationService;
  final bool isSubscriberToSecretConsultationService;
  final bool isSubscriberToEstablishingCompaniesService;
  final bool isSubscriberToRealEstateLegalAdviceService;
  final bool isSubscriberToInvestmentLegalAdviceService;
  final bool isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ;
  final bool isSubscriberToDebtCollectionService;
  final double rating;
  final DateTime createdAt;

  LawyerModel({
    required this.lawyerId,
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
    required this.isBookingByAppointment,
    required this.availablePeriods,
    required this.identificationImages,
    required this.isVerified,
    required this.isSubscriberToInstantLawyerService,
    required this.isSubscriberToInstantConsultationService,
    required this.isSubscriberToSecretConsultationService,
    required this.isSubscriberToEstablishingCompaniesService,
    required this.isSubscriberToRealEstateLegalAdviceService,
    required this.isSubscriberToInvestmentLegalAdviceService,
    required this.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ,
    required this.isSubscriberToDebtCollectionService,
    required this.rating,
    required this.createdAt,
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      lawyerId: int.parse(json['lawyerId'].toString()),
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
      consultationPrice:int.parse( json['consultationPrice'].toString()),
      tasks: json['tasks'].toString().isEmpty ? [] : json['tasks'].toString().split('--'),
      features: json['features'].toString().isEmpty ? [] : json['features'].toString().split('--'),
      images: json['images'].toString().isEmpty ? [] : json['images'].toString().split('--'),
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      governorate: json['governorate'],
      accountStatus: AccountStatus.toAccountStatus(json['accountStatus']),
      isBookingByAppointment: json['isBookingByAppointment'],
      availablePeriods: json['availablePeriods'].toString().isEmpty ? [] : json['availablePeriods'].toString().split('--'),
      identificationImages: json['identificationImages'].toString().isEmpty ? [] : json['identificationImages'].toString().split('--'),
      isVerified: json['isVerified'],
      isSubscriberToInstantLawyerService: json['isSubscriberToInstantLawyerService'],
      isSubscriberToInstantConsultationService: json['isSubscriberToInstantConsultationService'],
      isSubscriberToSecretConsultationService: json['isSubscriberToSecretConsultationService'],
      isSubscriberToEstablishingCompaniesService: json['isSubscriberToEstablishingCompaniesService'],
      isSubscriberToRealEstateLegalAdviceService: json['isSubscriberToRealEstateLegalAdviceService'],
      isSubscriberToInvestmentLegalAdviceService: json['isSubscriberToInvestmentLegalAdviceService'],
      isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ: json['isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ'],
      isSubscriberToDebtCollectionService: json['isSubscriberToDebtCollectionService'],
      rating: double.parse(json['rating'].toString()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(LawyerModel lawyerModel) {
    return {
      'lawyerId': lawyerModel.lawyerId,
      'name': lawyerModel.name,
      'emailAddress': lawyerModel.emailAddress,
      'password': lawyerModel.password,
      'mainCategory': lawyerModel.mainCategory,
      'categoriesIds': lawyerModel.categoriesIds.join('--'),
      'personalImage': lawyerModel.personalImage,
      'jobTitle': lawyerModel.jobTitle,
      'address': lawyerModel.address,
      'information': lawyerModel.information,
      'phoneNumber': lawyerModel.phoneNumber,
      'consultationPrice': lawyerModel.consultationPrice,
      'tasks': lawyerModel.tasks.join('--'),
      'features': lawyerModel.features.join('--'),
      'images': lawyerModel.images.join('--'),
      'latitude': lawyerModel.latitude,
      'longitude': lawyerModel.longitude,
      'governorate': lawyerModel.governorate,
      'accountStatus': lawyerModel.accountStatus.name,
      'isBookingByAppointment': lawyerModel.isBookingByAppointment,
      'availablePeriods': lawyerModel.availablePeriods.join('--'),
      'identificationImages': lawyerModel.identificationImages.join('--'),
      'isVerified': lawyerModel.isVerified,
      'isSubscriberToInstantLawyerService': lawyerModel.isSubscriberToInstantLawyerService,
      'isSubscriberToInstantConsultationService': lawyerModel.isSubscriberToInstantConsultationService,
      'isSubscriberToSecretConsultationService': lawyerModel.isSubscriberToSecretConsultationService,
      'isSubscriberToEstablishingCompaniesService': lawyerModel.isSubscriberToEstablishingCompaniesService,
      'isSubscriberToRealEstateLegalAdviceService': lawyerModel.isSubscriberToRealEstateLegalAdviceService,
      'isSubscriberToInvestmentLegalAdviceService': lawyerModel.isSubscriberToInvestmentLegalAdviceService,
      'isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ': lawyerModel.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ,
      'isSubscriberToDebtCollectionService': lawyerModel.isSubscriberToDebtCollectionService,
      'rating': lawyerModel.rating,
      'createdAt': lawyerModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<LawyerModel> fromJsonList (List<dynamic> list) => list.map<LawyerModel>((item) => LawyerModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<LawyerModel> list) => list.map<Map<String, dynamic>>((item) => LawyerModel.toMap(item)).toList();
}