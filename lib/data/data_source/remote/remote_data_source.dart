import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fahem/core/error/exceptions.dart';
import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/data/models/chat/chat_model.dart';
import 'package:fahem/data/models/chat/message_model.dart';
import 'package:fahem/data/models/chat/suggested_message_model.dart';
import 'package:fahem/data/models/jobs/employment_applications/employment_application_model.dart';
import 'package:fahem/data/models/transactions/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/data/models/lawyers/lawyers_features/lawyer_feature_model.dart';
import 'package:fahem/data/models/lawyers/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem/data/models/lawyers/lawyers_categories/lawyer_category_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_features/legal_accountant_feature_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/data/models/playlists/playlist_comments/playlist_comment_model.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_features/public_relation_feature_model.dart';
import 'package:fahem/data/models/settings/settings_model.dart';
import 'package:fahem/data/models/sliders/slider_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem/data/models/version/version_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/data/models/packages/package_model.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/usecases/chat/add_chat_usecase.dart';
import 'package:fahem/domain/usecases/chat/add_message_usecase.dart';
import 'package:fahem/domain/usecases/chat/update_message_mode_usecase.dart';
import 'package:fahem/domain/usecases/jobs/employment_applications/insert_employment_application_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_reviews/insert_lawyer_review_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_reviews/insert_legal_accountant_review_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/delete_log_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/get_logs_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/insert_log_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/delete_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/edit_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/insert_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_reviews/insert_public_relation_review_usecase.dart';
import 'package:fahem/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/delete_transaction_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/toggle_is_done_instant_consultation_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/get_transactions_for_user_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/insert_transaction_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/toggle_is_viewed_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/check_and_get_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/delete_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/edit_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/insert_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/is_user_account_exist_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/edit_wallet_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/get_wallet_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/insert_wallet_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/is_user_have_wallet_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

abstract class BaseRemoteDataSource {
  Future<VersionModel> getVersion();
  Future<EmploymentApplicationModel> insertEmploymentApplication(InsertEmploymentApplicationParameters parameters);
  Future<List<JobModel>> getAvailableJobs();
  Future<List<LawyerModel>> getAllLawyers();
  Future<List<LawyerCategoryModel>> getAllLawyersCategories();
  Future<List<LawyerReviewModel>> getAllLawyersReviews();
  Future<LawyerReviewModel> insertLawyerReview(InsertLawyerReviewParameters parameters);
  Future<List<LawyerFeatureModel>> getAllLawyersFeatures();
  Future<List<LogModel>> getLogsForUser(GetLogsForUserParameters parameters);
  Future<LogModel> insertLog(InsertLogParameters parameters);
  Future<void> deleteLog(DeleteLogParameters parameters);
  Future<List<PackageModel>> getAllPackages();
  Future<List<PlaylistModel>> getAllPlaylists();
  Future<PlaylistCommentModel> insertPlaylistComment(InsertPlaylistCommentParameters parameters);
  Future<PlaylistCommentModel> editPlaylistComment(EditPlaylistCommentParameters parameters);
  Future<void> deletePlaylistComment(DeletePlaylistCommentParameters parameters);
  Future<List<PublicRelationModel>> getAllPublicRelations();
  Future<List<PublicRelationCategoryModel>> getAllPublicRelationsCategories();
  Future<List<PublicRelationReviewModel>> getAllPublicRelationsReviews();
  Future<PublicRelationReviewModel> insertPublicRelationReview(InsertPublicRelationReviewParameters parameters);
  Future<List<PublicRelationFeatureModel>> getAllPublicRelationsFeatures();
  Future<List<LegalAccountantModel>> getAllLegalAccountants();
  Future<List<SliderModel>> getAllSliders();
  Future<List<LegalAccountantReviewModel>> getAllLegalAccountantsReviews();
  Future<LegalAccountantReviewModel> insertLegalAccountantReview(InsertLegalAccountantReviewParameters parameters);
  Future<List<LegalAccountantFeatureModel>> getAllLegalAccountantsFeatures();
  Future<List<TransactionModel>> getTransactionsForUser(GetTransactionsForUserParameters parameters);
  Future<TransactionModel> insertTransaction(InsertTransactionParameters parameters);
  Future<void> deleteTransaction(DeleteTransactionParameters parameters);
  Future<List<InstantConsultationCommentModel>> getAllInstantConsultationsComments();
  Future<TransactionModel> toggleIsDoneInstantConsultation(ToggleIsDoneInstantConsultationParameters parameters);
  Future<TransactionModel> toggleIsViewed(ToggleIsViewedParameters parameters);
  Future<UserAccountModel?> checkAndGetUserAccount(CheckAndGetUserAccountParameters parameters);
  Future<bool> isUserAccountExist(IsUserAccountExistParameters parameters);
  Future<UserAccountModel> insertUserAccount(InsertUserAccountParameters parameters);
  Future<UserAccountModel> editUserAccount(EditUserAccountParameters parameters);
  Future<void> deleteUserAccount(DeleteUserAccountParameters parameters);
  Future<bool> isUserHaveWallet(IsUserHaveWalletParameters parameters);
  Future<WalletModel?> getWalletForUser(GetWalletParameters parameters);
  Future<WalletModel> insertWallet(InsertWalletParameters parameters);
  Future<WalletModel> editWallet(EditWalletParameters parameters);
  Future<SettingsModel> getSettings();
  Future<String> uploadFile(UploadFileParameters parameters);

  // Firebase
  Future<List<SuggestedMessageModel>> getSuggestedMessages();
  Future<void> addChat(AddChatParameters parameters);
  Future<void> addMessage(AddMessageParameters parameters);
  Future<void> updateMessageMode(UpdateMessageModeParameters parameters);
}

class RemoteDataSource extends BaseRemoteDataSource {

  @override
  Future<VersionModel> getVersion() async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.appField: 'fahem',
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getVersionEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return VersionModel.fromJson(jsonData['version']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getVersion: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getVersion: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<EmploymentApplicationModel> insertEmploymentApplication(InsertEmploymentApplicationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.employmentApplicationModel.userAccountId.toString(),
        ApiConstants.jobIdField: parameters.employmentApplicationModel.jobId.toString(),
        ApiConstants.targetIdField: parameters.employmentApplicationModel.targetId.toString(),
        ApiConstants.targetNameField: parameters.employmentApplicationModel.targetName.toString(),
        ApiConstants.nameField: parameters.employmentApplicationModel.name.toString(),
        ApiConstants.phoneNumberField: parameters.employmentApplicationModel.phoneNumber.toString(),
        ApiConstants.cvField: parameters.employmentApplicationModel.cv.toString(),
        ApiConstants.createdAtField: parameters.employmentApplicationModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertEmploymentApplicationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return EmploymentApplicationModel.fromJson(jsonData['employmentApplication']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertEmploymentApplication: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertEmploymentApplication: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<JobModel>> getAvailableJobs() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAvailableJobsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return JobModel.fromJsonList(jsonData['jobs']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAvailableJobs: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAvailableJobs: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LawyerModel>> getAllLawyers() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLawyersEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJsonList(jsonData['lawyers']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLawyers: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLawyers: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LawyerCategoryModel>> getAllLawyersCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLawyersCategoriesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerCategoryModel.fromJsonList(jsonData['lawyersCategories']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLawyersCategories: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLawyersCategories: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LawyerReviewModel>> getAllLawyersReviews() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLawyersReviewsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerReviewModel.fromJsonList(jsonData['lawyersReviews']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLawyersReviews: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLawyersReviews: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerReviewModel> insertLawyerReview(InsertLawyerReviewParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerReviewModel.lawyerId.toString(),
        ApiConstants.userAccountIdField: parameters.lawyerReviewModel.userAccountId.toString(),
        ApiConstants.firstNameField: parameters.lawyerReviewModel.firstName.toString(),
        ApiConstants.familyNameField: parameters.lawyerReviewModel.familyName.toString(),
        ApiConstants.commentField: parameters.lawyerReviewModel.comment.toString(),
        ApiConstants.ratingField: parameters.lawyerReviewModel.rating.toString(),
        ApiConstants.featuresArField: parameters.lawyerReviewModel.featuresAr.join('--'),
        ApiConstants.featuresEnField: parameters.lawyerReviewModel.featuresEn.join('--'),
        ApiConstants.createdAtField: parameters.lawyerReviewModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertLawyerReviewEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerReviewModel.fromJson(jsonData['lawyerReview']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertLawyerReview: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertLawyerReview: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LawyerFeatureModel>> getAllLawyersFeatures() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLawyersFeaturesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerFeatureModel.fromJsonList(jsonData['lawyersFeatures']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLawyersFeatures: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLawyersFeatures: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LogModel>> getLogsForUser(GetLogsForUserParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getLogsForUserEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LogModel.fromJsonList(jsonData['logs']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getLogsForUser: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getLogsForUser: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LogModel> insertLog(InsertLogParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.logModel.userAccountId.toString(),
        ApiConstants.textArField: parameters.logModel.textAr.toString(),
        ApiConstants.textEnField: parameters.logModel.textEn.toString(),
        ApiConstants.createdAtField: parameters.logModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertLogEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LogModel.fromJson(jsonData['log']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertLog: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertLog: ${error..toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deleteLog(DeleteLogParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.logIdField: parameters.logModel.logId.toString(),
        ApiConstants.userAccountIdField: parameters.logModel.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deleteLogEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deleteLog: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deleteLog: ${error..toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PackageModel>> getAllPackages() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPackagesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PackageModel.fromJsonList(jsonData['packages']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPackages: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPackages: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PlaylistModel>> getAllPlaylists() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPlaylistsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PlaylistModel.fromJsonList(jsonData['playlists']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPlaylists: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPlaylists: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PlaylistCommentModel> insertPlaylistComment(InsertPlaylistCommentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.playlistIdField: parameters.playlistCommentModel.playlistId.toString(),
        ApiConstants.userAccountIdField: parameters.playlistCommentModel.userAccountId.toString(),
        ApiConstants.firstNameField: parameters.playlistCommentModel.firstName.toString(),
        ApiConstants.familyNameField: parameters.playlistCommentModel.familyName.toString(),
        ApiConstants.commentField: parameters.playlistCommentModel.comment.toString(),
        ApiConstants.createdAtField: parameters.playlistCommentModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertPlaylistCommentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PlaylistCommentModel.fromJson(jsonData['playlistComment']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertPlaylistComment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertPlaylistComment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PlaylistCommentModel> editPlaylistComment(EditPlaylistCommentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.playlistCommentIdField: parameters.playlistCommentModel.playlistCommentId.toString(),
        ApiConstants.playlistIdField: parameters.playlistCommentModel.playlistId.toString(),
        ApiConstants.userAccountIdField: parameters.playlistCommentModel.userAccountId.toString(),
        ApiConstants.commentField: parameters.playlistCommentModel.comment.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editPlaylistCommentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PlaylistCommentModel.fromJson(jsonData['playlistComment']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editPlaylistComment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editPlaylistComment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deletePlaylistComment(DeletePlaylistCommentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.playlistCommentIdField: parameters.playlistCommentModel.playlistCommentId.toString(),
        ApiConstants.playlistIdField: parameters.playlistCommentModel.playlistId.toString(),
        ApiConstants.userAccountIdField: parameters.playlistCommentModel.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deletePlaylistCommentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deletePlaylistComment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deletePlaylistComment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PublicRelationModel>> getAllPublicRelations() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPublicRelationsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJsonList(jsonData['publicRelations']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPublicRelations: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPublicRelations: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PublicRelationCategoryModel>> getAllPublicRelationsCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPublicRelationsCategoriesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationCategoryModel.fromJsonList(jsonData['publicRelationsCategories']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPublicRelationsCategories: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPublicRelationsCategories: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PublicRelationReviewModel>> getAllPublicRelationsReviews() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPublicRelationsReviewsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationReviewModel.fromJsonList(jsonData['publicRelationsReviews']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPublicRelationsReviews: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPublicRelationsReviews: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationReviewModel> insertPublicRelationReview(InsertPublicRelationReviewParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationReviewModel.publicRelationId.toString(),
        ApiConstants.userAccountIdField: parameters.publicRelationReviewModel.userAccountId.toString(),
        ApiConstants.firstNameField: parameters.publicRelationReviewModel.firstName.toString(),
        ApiConstants.familyNameField: parameters.publicRelationReviewModel.familyName.toString(),
        ApiConstants.commentField: parameters.publicRelationReviewModel.comment.toString(),
        ApiConstants.ratingField: parameters.publicRelationReviewModel.rating.toString(),
        ApiConstants.featuresArField: parameters.publicRelationReviewModel.featuresAr.join('--'),
        ApiConstants.featuresEnField: parameters.publicRelationReviewModel.featuresEn.join('--'),
        ApiConstants.createdAtField: parameters.publicRelationReviewModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertPublicRelationReviewEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationReviewModel.fromJson(jsonData['publicRelationReview']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertPublicRelationReview: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertPublicRelationReview: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PublicRelationFeatureModel>> getAllPublicRelationsFeatures() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPublicRelationsFeaturesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationFeatureModel.fromJsonList(jsonData['publicRelationsFeatures']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPublicRelationsFeatures: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPublicRelationsFeatures: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LegalAccountantModel>> getAllLegalAccountants() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLegalAccountantsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJsonList(jsonData['legalAccountants']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLegalAccountants: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLegalAccountants: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<SliderModel>> getAllSliders() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllSlidersEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return SliderModel.fromJsonList(jsonData['sliders']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllSliders: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllSliders: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LegalAccountantReviewModel>> getAllLegalAccountantsReviews() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLegalAccountantsReviewsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantReviewModel.fromJsonList(jsonData['legalAccountantsReviews']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLegalAccountantsReviews: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLegalAccountantsReviews: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantReviewModel> insertLegalAccountantReview(InsertLegalAccountantReviewParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantReviewModel.legalAccountantId.toString(),
        ApiConstants.userAccountIdField: parameters.legalAccountantReviewModel.userAccountId.toString(),
        ApiConstants.firstNameField: parameters.legalAccountantReviewModel.firstName.toString(),
        ApiConstants.familyNameField: parameters.legalAccountantReviewModel.familyName.toString(),
        ApiConstants.commentField: parameters.legalAccountantReviewModel.comment.toString(),
        ApiConstants.ratingField: parameters.legalAccountantReviewModel.rating.toString(),
        ApiConstants.featuresArField: parameters.legalAccountantReviewModel.featuresAr.join('--'),
        ApiConstants.featuresEnField: parameters.legalAccountantReviewModel.featuresEn.join('--'),
        ApiConstants.createdAtField: parameters.legalAccountantReviewModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertLegalAccountantReviewEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantReviewModel.fromJson(jsonData['legalAccountantReview']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertLegalAccountantReview: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertLegalAccountantReview: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LegalAccountantFeatureModel>> getAllLegalAccountantsFeatures() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLegalAccountantsFeaturesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantFeatureModel.fromJsonList(jsonData['legalAccountantsFeatures']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLegalAccountantsFeatures: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLegalAccountantsFeatures: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsForUser(GetTransactionsForUserParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getTransactionsForUserEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJsonList(jsonData['transactions']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getTransactionsForUser: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getTransactionsForUser: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<TransactionModel> insertTransaction(InsertTransactionParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.targetIdField: parameters.transactionModel.targetId.toString(),
        ApiConstants.userAccountIdField: parameters.transactionModel.userAccountId.toString(),
        ApiConstants.nameField: parameters.transactionModel.name.toString(),
        ApiConstants.phoneNumberField: parameters.transactionModel.phoneNumber.toString(),
        ApiConstants.emailAddressField: parameters.transactionModel.emailAddress.toString(),
        ApiConstants.textArField: parameters.transactionModel.textAr.toString(),
        ApiConstants.textEnField: parameters.transactionModel.textEn.toString(),
        ApiConstants.bookingDateTimeStampField: parameters.transactionModel.bookingDateTimeStamp.toString(),
        ApiConstants.transactionTypeField: parameters.transactionModel.transactionType.name.toString(),
        ApiConstants.createdAtField: parameters.transactionModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertTransactionEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJson(jsonData['transaction']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertTransaction: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertTransaction: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deleteTransaction(DeleteTransactionParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.transactionIdField: parameters.transactionModel.transactionId.toString(),
        ApiConstants.userAccountIdField: parameters.transactionModel.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deleteTransactionEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deleteTransaction: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deleteTransaction: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<InstantConsultationCommentModel>> getAllInstantConsultationsComments() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllInstantConsultationsCommentsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return InstantConsultationCommentModel.fromJsonList(jsonData['instantConsultationsComments']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllInstantConsultationsComments: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllInstantConsultationsComments: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<TransactionModel> toggleIsDoneInstantConsultation(ToggleIsDoneInstantConsultationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.transactionIdField: parameters.transactionId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.toggleIsDoneInstantConsultationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJson(jsonData['transaction']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('toggleIsDoneInstantConsultation: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('toggleIsDoneInstantConsultation: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<TransactionModel> toggleIsViewed(ToggleIsViewedParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.transactionIdField: parameters.transactionId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.toggleIsViewedEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJson(jsonData['transaction']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('toggleIsViewed: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('toggleIsViewed: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<UserAccountModel?> checkAndGetUserAccount(CheckAndGetUserAccountParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.phoneNumberField: parameters.phoneNumber.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.checkAndGetUserAccountEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['userAccount'] == null ? null : UserAccountModel.fromJson(jsonData['userAccount']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('checkAndGetUserAccount: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('checkAndGetUserAccount: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<bool> isUserAccountExist(IsUserAccountExistParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.isUserAccountExistEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['isAccountExist'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('isUserAccountExist: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('isUserAccountExist: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<UserAccountModel> insertUserAccount(InsertUserAccountParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.phoneNumberField: parameters.userAccountModel.phoneNumber.toString(),
        ApiConstants.firstNameField: parameters.userAccountModel.firstName.toString(),
        ApiConstants.familyNameField: parameters.userAccountModel.familyName.toString(),
        ApiConstants.emailAddressField: parameters.userAccountModel.emailAddress.toString(),
        ApiConstants.reasonForRegistrationField: parameters.userAccountModel.reasonForRegistration.toString(),
        ApiConstants.genderField: parameters.userAccountModel.gender.name,
        ApiConstants.birthDateField: parameters.userAccountModel.birthDate.millisecondsSinceEpoch.toString(),
        ApiConstants.createdAtField: parameters.userAccountModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertUserAccountEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return UserAccountModel.fromJson(jsonData['userAccount']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertUserAccount: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertUserAccount: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<UserAccountModel> editUserAccount(EditUserAccountParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountModel.userAccountId.toString(),
        ApiConstants.phoneNumberField: parameters.userAccountModel.phoneNumber.toString(),
        ApiConstants.firstNameField: parameters.userAccountModel.firstName.toString(),
        ApiConstants.familyNameField: parameters.userAccountModel.familyName.toString(),
        ApiConstants.emailAddressField: parameters.userAccountModel.emailAddress.toString(),
        ApiConstants.reasonForRegistrationField: parameters.userAccountModel.reasonForRegistration.toString(),
        ApiConstants.genderField: parameters.userAccountModel.gender.name,
        ApiConstants.birthDateField: parameters.userAccountModel.birthDate.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editUserAccountEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return UserAccountModel.fromJson(jsonData['userAccount']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editUserAccount: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editUserAccount: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deleteUserAccount(DeleteUserAccountParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deleteUserAccountEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deleteUserAccount: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deleteUserAccount: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<bool> isUserHaveWallet(IsUserHaveWalletParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.isUserHaveWalletEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['isWalletExist'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('isUserHaveWallet: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('isUserHaveWallet: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<WalletModel?> getWalletForUser(GetWalletParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.userAccountId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getWalletForUserEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['wallet'] == null ? null : WalletModel.fromJson(jsonData['wallet']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getWalletForUser: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getWalletForUser: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<WalletModel> insertWallet(InsertWalletParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.userAccountIdField: parameters.walletModel.userAccountId.toString(),
        ApiConstants.balanceField: parameters.walletModel.balance.toString(),
        ApiConstants.createdAtField: parameters.walletModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertWalletEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return WalletModel.fromJson(jsonData['wallet']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertWallet: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertWallet: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<WalletModel> editWallet(EditWalletParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.walletIdField: parameters.walletModel.walletId.toString(),
        ApiConstants.userAccountIdField: parameters.walletModel.userAccountId.toString(),
        ApiConstants.balanceField: parameters.walletModel.balance.toString(),
        ApiConstants.packageIdField: parameters.walletModel.packageId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editWalletEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return WalletModel.fromJson(jsonData['wallet']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editWallet: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editWallet: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<SettingsModel> getSettings() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getSettingsEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return SettingsModel.fromJson(jsonData['settings']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getSettings: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getSettings: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<String> uploadFile(UploadFileParameters parameters) async {
    try {
      http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(ApiConstants.uploadFileEndPoint));
      request.fields[ApiConstants.directoryField] = parameters.directory;
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(ApiConstants.fileField, parameters.file.path, contentType: MediaType('image', parameters.file.path.split('.').last));
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(String.fromCharCodes(await response.stream.toBytes()));
        if(jsonData['status']) {
          return jsonData['file'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('uploadFile: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('uploadFile: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  // Firebase
  @override
  Future<List<SuggestedMessageModel>> getSuggestedMessages() async {
    try {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance
          .collection(FirebaseConstants.suggestedMessagesCollection)
          .orderBy(FirebaseConstants.sortNumberField)
          .get();
      return response.docs.map((element) => SuggestedMessageModel.fromJson(element.data())).toList();
    }
    on FirebaseException catch (error) {
      throw ServerException(messageAr: error.message??'', messageEn: error.message??'');
    }
    catch(error) {
      debugPrint('getSuggestedMessages: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> addChat(AddChatParameters parameters) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.chatsCollection)
          .doc((parameters.chatModel.chatId))
          .set(ChatModel.toMap(parameters.chatModel));
    }
    on FirebaseAuthException catch (error) {
      throw ServerException(messageAr: error.message??'', messageEn: error.message??'');
    }
    on FirebaseException catch (error) {
      throw ServerException(messageAr: error.message??'', messageEn: error.message??'');
    }
    catch(error) {
      debugPrint('addChat: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> addMessage(AddMessageParameters parameters) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.chatsCollection)
          .doc(parameters.messageModel.chatId)
          .collection(FirebaseConstants.messagesSubCollection)
          .doc(parameters.messageModel.messageId)
          .set(MessageModel.toMap(parameters.messageModel));
    }
    on FirebaseAuthException catch (error) {
      throw ServerException(messageAr: error.message??'', messageEn: error.message??'');
    }
    on FirebaseException catch (error) {
      throw ServerException(messageAr: error.message??'', messageEn: error.message??'');
    }
    catch(error) {
      debugPrint('addMessage: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> updateMessageMode(UpdateMessageModeParameters parameters) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.chatsCollection)
          .doc(parameters.senderId)
          .collection(FirebaseConstants.messagesSubCollection)
          .doc(parameters.messageId)
          .update({FirebaseConstants.messageModeField: parameters.messageMode.name});
    }
    on FirebaseException catch (error) {
      throw ServerException(messageAr: error.message??'', messageEn: error.message??'');
    }
    catch(error) {
      debugPrint('updateMessageMode: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }
}