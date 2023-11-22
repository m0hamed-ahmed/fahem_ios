import 'package:fahem/core/utils/enums.dart';

class SearchModel {
  final int? lawyerId;
  final int? publicRelationId;
  final int? legalAccountantId;
  final String name;
  final String emailAddress;
  final String password;
  final String mainCategory;
  final List<String>? categoriesIds;
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
  final AccountStatus accountStatus;
  final bool isVerified;
  final bool isBookingByAppointment;
  final List<String> identificationImages;
  final bool? isSubscriberToInstantLawyerService;
  final bool? isSubscriberToInstantConsultationService;
  final bool? isSubscriberToSecretConsultationService;
  final bool? isSubscriberToEstablishingCompaniesService;
  final bool? isSubscriberToRealEstateLegalAdviceService;
  final bool? isSubscriberToInvestmentLegalAdviceService;
  final bool? isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ;
  final bool? isSubscriberToDebtCollectionService;
  final double rating;
  final DateTime createdAt;

  SearchModel({
    this.lawyerId,
    this.publicRelationId,
    this.legalAccountantId,
    required this.name,
    required this.emailAddress,
    required this.password,
    required this.mainCategory,
    this.categoriesIds,
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
    required this.identificationImages,
    this.isSubscriberToInstantLawyerService,
    this.isSubscriberToInstantConsultationService,
    this.isSubscriberToSecretConsultationService,
    this.isSubscriberToEstablishingCompaniesService,
    this.isSubscriberToRealEstateLegalAdviceService,
    this.isSubscriberToInvestmentLegalAdviceService,
    this.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ,
    this.isSubscriberToDebtCollectionService,
    required this.rating,
    required this.createdAt,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      lawyerId: json.containsKey('lawyerId') ? int.parse(json['lawyerId'].toString()) : null,
      publicRelationId: json.containsKey('publicRelationId') ? int.parse(json['publicRelationId'].toString()) : null,
      legalAccountantId: json.containsKey('legalAccountantId') ? int.parse(json['legalAccountantId'].toString()) : null,
      name: json['name'],
      emailAddress: json['emailAddress'],
      password: json['password'],
      mainCategory: json['mainCategory'],
      categoriesIds: json.containsKey('categoriesIds') ? json['categoriesIds'].toString().split('--') : null,
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
      isVerified: json['isVerified'],
      isBookingByAppointment: json['isBookingByAppointment'],
      identificationImages: json['identificationImages'].toString().isEmpty ? [] : json['identificationImages'].toString().split('--'),
      isSubscriberToInstantLawyerService: json.containsKey('isSubscriberToInstantLawyerService') ? json['isSubscriberToInstantLawyerService'] : null,
      isSubscriberToInstantConsultationService: json.containsKey('isSubscriberToInstantConsultationService') ? json['isSubscriberToInstantConsultationService'] : null,
      isSubscriberToSecretConsultationService: json.containsKey('isSubscriberToSecretConsultationService') ? json['isSubscriberToSecretConsultationService'] : null,
      isSubscriberToEstablishingCompaniesService: json.containsKey('isSubscriberToEstablishingCompaniesService') ? json['isSubscriberToEstablishingCompaniesService'] : null,
      isSubscriberToRealEstateLegalAdviceService: json.containsKey('isSubscriberToRealEstateLegalAdviceService') ? json['isSubscriberToRealEstateLegalAdviceService'] : null,
      isSubscriberToInvestmentLegalAdviceService: json.containsKey('isSubscriberToInvestmentLegalAdviceService') ? json['isSubscriberToInvestmentLegalAdviceService'] : null,
      isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ: json.containsKey('isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ') ? json['isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ'] : null,
      isSubscriberToDebtCollectionService: json.containsKey('isSubscriberToDebtCollectionService') ? json['isSubscriberToDebtCollectionService'] : null,
      rating: double.parse(json['rating'].toString()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(SearchModel searchModel) {
    return {
      'lawyerId': searchModel.lawyerId,
      'publicRelationId': searchModel.publicRelationId,
      'legalAccountantId': searchModel.legalAccountantId,
      'name': searchModel.name,
      'emailAddress': searchModel.emailAddress,
      'password': searchModel.password,
      'mainCategory': searchModel.mainCategory,
      'categoriesIds': searchModel.categoriesIds == null ? null : searchModel.categoriesIds!.join('--'),
      'personalImage': searchModel.personalImage,
      'jobTitle': searchModel.jobTitle,
      'address': searchModel.address,
      'information': searchModel.information,
      'phoneNumber': searchModel.phoneNumber,
      'consultationPrice': searchModel.consultationPrice,
      'tasks': searchModel.tasks.join('--'),
      'features': searchModel.features.join('--'),
      'images': searchModel.images.join('--'),
      'latitude': searchModel.latitude,
      'longitude': searchModel.longitude,
      'governorate': searchModel.governorate,
      'accountStatus': searchModel.accountStatus.name,
      'isVerified': searchModel.isVerified,
      'isBookingByAppointment': searchModel.isBookingByAppointment,
      'identificationImages': searchModel.identificationImages.join('--'),
      'isSubscriberToInstantLawyerService': searchModel.isSubscriberToInstantLawyerService,
      'isSubscriberToInstantConsultationService': searchModel.isSubscriberToInstantConsultationService,
      'isSubscriberToSecretConsultationService': searchModel.isSubscriberToSecretConsultationService,
      'isSubscriberToEstablishingCompaniesService': searchModel.isSubscriberToEstablishingCompaniesService,
      'isSubscriberToRealEstateLegalAdviceService': searchModel.isSubscriberToRealEstateLegalAdviceService,
      'isSubscriberToInvestmentLegalAdviceService': searchModel.isSubscriberToInvestmentLegalAdviceService,
      'isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ': searchModel.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ,
      'isSubscriberToDebtCollectionService': searchModel.isSubscriberToDebtCollectionService,
      'rating': searchModel.rating,
      'createdAt': searchModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<SearchModel> fromJsonList (List<dynamic> list) => list.map<SearchModel>((item) => SearchModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<SearchModel> list) => list.map<Map<String, dynamic>>((item) => SearchModel.toMap(item)).toList();
}