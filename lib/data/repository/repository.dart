import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/exceptions.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/network/network_info.dart';
import 'package:fahem/data/data_source/remote/remote_data_source.dart';
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
import 'package:fahem/data/models/public_relations/public_relations_features/public_relation_feature_model.dart';
import 'package:fahem/data/models/settings/settings_model.dart';
import 'package:fahem/data/models/sliders/slider_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem/data/models/playlists/playlist_comments/playlist_comment_model.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/data/models/version/version_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/data/models/packages/package_model.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
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
import 'package:flutter/material.dart';

class Repository extends BaseRepository {
  final BaseRemoteDataSource _baseRemoteDataSource;
  final BaseNetworkInfo _baseNetworkInfo;

  Repository(this._baseRemoteDataSource, this._baseNetworkInfo);

  @override
  Future<Either<Failure, VersionModel>> getVersion() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getVersion();
        debugPrint('getVersion');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, EmploymentApplicationModel>> insertEmploymentApplication(InsertEmploymentApplicationParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertEmploymentApplication(parameters);
        debugPrint('insertEmploymentApplication');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<JobModel>>> getAvailableJobs() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAvailableJobs();
        debugPrint('getAvailableJobs: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LawyerModel>>> getAllLawyers() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLawyers();
        debugPrint('getAllLawyers: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LawyerCategoryModel>>> getAllLawyersCategories() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLawyersCategories();
        debugPrint('getAllLawyersCategories: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LawyerReviewModel>>> getAllLawyersReviews() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLawyersReviews();
        debugPrint('getAllLawyersReviews: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerReviewModel>> insertLawyerReview(InsertLawyerReviewParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertLawyerReview(parameters);
        debugPrint('insertLawyerReview');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LawyerFeatureModel>>> getAllLawyersFeatures() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLawyersFeatures();
        debugPrint('getAllLawyersFeatures: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LogModel>>> getLogsForUser(GetLogsForUserParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getLogsForUser(parameters);
        debugPrint('getLogsForUser: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LogModel>> insertLog(InsertLogParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertLog(parameters);
        debugPrint('insertLog');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLog(DeleteLogParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deleteLog(parameters);
        debugPrint('deleteLog');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PackageModel>>> getAllPackages() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPackages();
        debugPrint('getAllPackages: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PlaylistModel>>> getAllPlaylists() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPlaylists();
        debugPrint('getAllPlaylists: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PlaylistCommentModel>> insertPlaylistComment(InsertPlaylistCommentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertPlaylistComment(parameters);
        debugPrint('insertPlaylistComment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PlaylistCommentModel>> editPlaylistComment(EditPlaylistCommentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editPlaylistComment(parameters);
        debugPrint('editPlaylistComment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlaylistComment(DeletePlaylistCommentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deletePlaylistComment(parameters);
        debugPrint('deletePlaylistComment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PublicRelationModel>>> getAllPublicRelations() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPublicRelations();
        debugPrint('getAllPublicRelations: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PublicRelationCategoryModel>>> getAllPublicRelationsCategories() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPublicRelationsCategories();
        debugPrint('getAllPublicRelationsCategories: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PublicRelationReviewModel>>> getAllPublicRelationsReviews() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPublicRelationsReviews();
        debugPrint('getAllPublicRelationsReviews: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationReviewModel>> insertPublicRelationReview(InsertPublicRelationReviewParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertPublicRelationReview(parameters);
        debugPrint('insertPublicRelationReview');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PublicRelationFeatureModel>>> getAllPublicRelationsFeatures() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPublicRelationsFeatures();
        debugPrint('getAllPublicRelationsFeatures: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LegalAccountantModel>>> getAllLegalAccountants() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLegalAccountants();
        debugPrint('getAllLegalAccountants: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SliderModel>>> getAllSliders() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllSliders();
        debugPrint('getAllSliders: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LegalAccountantReviewModel>>> getAllLegalAccountantsReviews() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLegalAccountantsReviews();
        debugPrint('getAllLegalAccountantsReviews: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantReviewModel>> insertLegalAccountantReview(InsertLegalAccountantReviewParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertLegalAccountantReview(parameters);
        debugPrint('insertLegalAccountantReview');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LegalAccountantFeatureModel>>> getAllLegalAccountantsFeatures() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLegalAccountantsFeatures();
        debugPrint('getAllLegalAccountantsFeatures: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactionsForUser(GetTransactionsForUserParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getTransactionsForUser(parameters);
        debugPrint('getTransactionsForUser: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> toggleIsDoneInstantConsultation(ToggleIsDoneInstantConsultationParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.toggleIsDoneInstantConsultation(parameters);
        debugPrint('toggleIsDoneInstantConsultation');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> toggleIsViewed(ToggleIsViewedParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.toggleIsViewed(parameters);
        debugPrint('toggleIsViewed');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> insertTransaction(InsertTransactionParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertTransaction(parameters);
        debugPrint('insertTransaction');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(DeleteTransactionParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deleteTransaction(parameters);
        debugPrint('deleteTransaction');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<InstantConsultationCommentModel>>> getAllInstantConsultationsComments() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllInstantConsultationsComments();
        debugPrint('getAllInstantConsultationsComments: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserAccountModel?>> checkAndGetUserAccount(CheckAndGetUserAccountParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.checkAndGetUserAccount(parameters);
        debugPrint('checkAndGetUserAccount');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserAccountExist(IsUserAccountExistParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.isUserAccountExist(parameters);
        debugPrint('isUserAccountExist');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserAccountModel>> insertUserAccount(InsertUserAccountParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertUserAccount(parameters);
        debugPrint('insertUserAccount');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserAccountModel>> editUserAccount(EditUserAccountParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editUserAccount(parameters);
        debugPrint('editUserAccount');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount(DeleteUserAccountParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deleteUserAccount(parameters);
        debugPrint('deleteUserAccount');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserHaveWallet(IsUserHaveWalletParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.isUserHaveWallet(parameters);
        debugPrint('isUserHaveWallet');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, WalletModel?>> getWalletForUser(GetWalletParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getWalletForUser(parameters);
        debugPrint('getWalletForUser');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, WalletModel>> insertWallet(InsertWalletParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertWallet(parameters);
        debugPrint('insertWallet');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, WalletModel>> editWallet(EditWalletParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editWallet(parameters);
        debugPrint('editWallet');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile(UploadFileParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.uploadFile(parameters);
        debugPrint('uploadFile');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, SettingsModel>> getSettings() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getSettings();
        debugPrint('getSettings');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }


  @override
  Future<Either<Failure, List<SuggestedMessageModel>>> getSuggestedMessages() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getSuggestedMessages();
        debugPrint('getSuggestedMessages: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addChat(AddChatParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.addChat(parameters);
        debugPrint('addChat');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addMessage(AddMessageParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.addMessage(parameters);
        debugPrint('addMessage');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMessageMode(UpdateMessageModeParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.updateMessageMode(parameters);
        debugPrint('updateMessageMode');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }
}