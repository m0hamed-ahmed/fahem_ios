import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MainCategories {lawyers, publicRelations, legalAccountants}

enum JobDetailsMode {jobDetails, aboutCompany}

enum PlaylistsMode {aboutVideo, restOfTheVideos, comments}

enum ShowMessage {success, failure}

enum CommentStatus {active, pending, rejected}

enum PaymentsMethods {direct, wallet}

enum FahemServiceType {
  instantLawyer,
  instantConsultation,
  secretConsultation,
  debtCollection,
  establishingCompanies,
  realEstateLegalAdvice,
  investmentLegalAdvice,
  trademarkRegistrationAndIntellectualProtection,
}

enum GovernoratesMode {
  currentLocation, allGovernorates, specificGovernment;

  static GovernoratesMode toGovernoratesMode(String governoratesMode) {
    switch(governoratesMode) {
      case ConstantsManager.currentLocationEnum: return GovernoratesMode.currentLocation;
      case ConstantsManager.allGovernoratesEnum: return GovernoratesMode.allGovernorates;
      default: return GovernoratesMode.specificGovernment;
    }
  }
}

enum TransactionType {
  instantConsultation,
  secretConsultation,
  showLawyerNumber,
  showPublicRelationNumber,
  showLegalAccountantNumber,
  appointmentBookingWithLawyer,
  appointmentBookingWithPublicRelation,
  appointmentBookingWithLegalAccountant;

  static TransactionType toTransactionType(String transactionType) {
    switch(transactionType) {
      case ConstantsManager.instantConsultationEnum: return TransactionType.instantConsultation;
      case ConstantsManager.secretConsultationEnum: return TransactionType.secretConsultation;
      case ConstantsManager.showLawyerNumberEnum: return TransactionType.showLawyerNumber;
      case ConstantsManager.showPublicRelationNumberEnum: return TransactionType.showPublicRelationNumber;
      case ConstantsManager.showLegalAccountantNumberEnum: return TransactionType.showLegalAccountantNumber;
      case ConstantsManager.appointmentBookingWithLawyerEnum: return TransactionType.appointmentBookingWithLawyer;
      case ConstantsManager.appointmentBookingWithPublicRelationEnum: return TransactionType.appointmentBookingWithPublicRelation;
      case ConstantsManager.appointmentBookingWithLegalAccountantEnum: return TransactionType.appointmentBookingWithLegalAccountant;

      default: return TransactionType.instantConsultation;
    }
  }
}

enum Gender {
  male, female;

  static Gender toGender(String gender) {
    switch(gender) {
      case ConstantsManager.maleEnum: return Gender.male;
      default: return Gender.female;
    }
  }

  static String fromGender(BuildContext context, Gender gender) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    switch(gender) {
      case Gender.male: return Methods.getText(StringsManager.male, appProvider.isEnglish).toTitleCase();
      case Gender.female: return Methods.getText(StringsManager.female, appProvider.isEnglish).toTitleCase();
      default: return ConstantsManager.empty;
    }
  }
}

enum MessageMode {
  send, delete;

  static MessageMode toMessageMode(String messageMode) {
    switch(messageMode) {
      case ConstantsManager.deleteEnum: return MessageMode.delete;
      default: return MessageMode.send;
    }
  }
}

enum AccountStatus {
  pending, acceptable, unacceptable;

  static AccountStatus toAccountStatus(String accountStatus) {
    switch(accountStatus) {
      case ConstantsManager.pendingEnum: return AccountStatus.pending;
      case ConstantsManager.acceptableEnum: return AccountStatus.acceptable;
      default: return AccountStatus.unacceptable;
    }
  }
}

enum OrderBy {
  accountVerification,
  highestRated,
  lowestRated,
  newlyAdded,
  theOldest;
  // fromNearestToFarthest;

  static String fromOrderBy(BuildContext context, OrderBy orderBy) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    switch(orderBy) {
      case OrderBy.accountVerification: return Methods.getText(StringsManager.accountVerification, appProvider.isEnglish).toTitleCase();
      case OrderBy.highestRated: return Methods.getText(StringsManager.highestRated, appProvider.isEnglish).toTitleCase();
      case OrderBy.lowestRated: return Methods.getText(StringsManager.lowestRated, appProvider.isEnglish).toTitleCase();
      case OrderBy.newlyAdded: return Methods.getText(StringsManager.newlyAdded, appProvider.isEnglish).toTitleCase();
      case OrderBy.theOldest: return Methods.getText(StringsManager.theOldest, appProvider.isEnglish).toTitleCase();
      // case OrderBy.fromNearestToFarthest: return Methods.getText(StringsManager.fromNearestToFarthest, appProvider.isEnglish).toTitleCase();
      default: return ConstantsManager.empty;
    }
  }
}