import 'package:fahem/core/network/network_info.dart';
import 'package:fahem/core/utils/upload_file_provider.dart';
import 'package:fahem/data/data_source/remote/remote_data_source.dart';
import 'package:fahem/data/repository/repository.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/chat/add_chat_usecase.dart';
import 'package:fahem/domain/usecases/chat/add_message_usecase.dart';
import 'package:fahem/domain/usecases/chat/get_suggested_messages_usecase.dart';
import 'package:fahem/domain/usecases/chat/update_message_mode_usecase.dart';
import 'package:fahem/domain/usecases/transactions/instant_consultations_comments/get_all_instant_consultations_comments_usecase.dart';
import 'package:fahem/domain/usecases/jobs/jobs/get_available_jobs_usecase.dart';
import 'package:fahem/domain/usecases/jobs/employment_applications/insert_employment_application_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_features/get_all_lawyers_features_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_reviews/get_all_lawyers_reviews_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers/get_all_lawyers_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_categories/get_all_lawyers_categories_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_reviews/insert_lawyer_review_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants/get_all_legal_accountants_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_features/get_all_legal_accountants_features_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_reviews/get_all_legal_accountants_reviews_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_reviews/insert_legal_accountant_review_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/delete_log_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/get_logs_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/insert_log_usecase.dart';
import 'package:fahem/domain/usecases/packages/get_all_packages_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/delete_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/edit_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_features/get_all_public_relations_features_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_reviews/get_all_public_relations_reviews_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/get_all_public_relations_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_categories/get_all_public_relations_categories_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlists/get_all_playlists_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/insert_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_reviews/insert_public_relation_review_usecase.dart';
import 'package:fahem/domain/usecases/settings/get_settings_usecase.dart';
import 'package:fahem/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem/domain/usecases/sliders/get_all_sliders_usecase.dart';
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
import 'package:fahem/domain/usecases/version/get_version_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/edit_wallet_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/get_wallet_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/insert_wallet_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/is_user_have_wallet_usecase.dart';
import 'package:fahem/presentation/features/authentication/controllers/sign_up_provider.dart';
import 'package:fahem/presentation/features/chat/controllers/chat_room_provider.dart';
import 'package:fahem/presentation/features/chat/controllers/suggested_messages_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/sliders_provider.dart';
import 'package:fahem/presentation/features/jobs/controllers/job_apply_provider.dart';
import 'package:fahem/presentation/features/jobs/controllers/jobs_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_features_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_reviews/controllers/lawyers_reviews_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/controllers/lawyers_categories_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_features_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/packages/controllers/packages_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/profile_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_features_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/controllers/public_relations_reviews_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlist_details_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlists_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/features/start/controllers/version_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/instant_consultations_comments_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
   static void init() {

    // Core
    getIt.registerLazySingleton<BaseNetworkInfo>(() => NetworkInfo(InternetConnectionChecker()));

    // Provider
    getIt.registerFactory(() => VersionProvider(getIt()));
    getIt.registerFactory(() => JobApplyProvider(getIt()));
    getIt.registerFactory(() => JobsProvider(getIt()));
    getIt.registerFactory(() => LawyersProvider(getIt()));
    getIt.registerFactory(() => LawyersFeaturesProvider(getIt()));
    getIt.registerFactory(() => LawyersCategoriesProvider(getIt()));
    getIt.registerFactory(() => LawyersReviewsProvider(getIt(), getIt()));
    getIt.registerFactory(() => LogsProvider(getIt(), getIt(), getIt()));
    getIt.registerFactory(() => PackagesProvider(getIt()));
    getIt.registerFactory(() => PlaylistsProvider(getIt()));
    getIt.registerFactory(() => PlaylistDetailsProvider(getIt(), getIt(), getIt()));
    getIt.registerFactory(() => PublicRelationsProvider(getIt()));
    getIt.registerFactory(() => PublicRelationsFeaturesProvider(getIt()));
    getIt.registerFactory(() => PublicRelationsCategoriesProvider(getIt()));
    getIt.registerFactory(() => PublicRelationsReviewsProvider(getIt(), getIt()));
    getIt.registerFactory(() => LegalAccountantsProvider(getIt()));
    getIt.registerFactory(() => LegalAccountantsFeaturesProvider(getIt()));
    getIt.registerFactory(() => LegalAccountantsReviewsProvider(getIt(), getIt()));
    getIt.registerFactory(() => SlidersProvider(getIt()));
    getIt.registerFactory(() => TransactionsProvider(getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => InstantConsultationsCommentsProvider(getIt()));
    getIt.registerFactory(() => SignUpProvider(getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => WalletProvider(getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => ProfileProvider(getIt(), getIt()));
    getIt.registerFactory(() => SettingsProvider(getIt()));
    getIt.registerFactory(() => UploadFileProvider(getIt()));

    getIt.registerFactory(() => ChatRoomProvider(getIt(), getIt(), getIt()));
    getIt.registerFactory(() => SuggestedMessagesProvider(getIt()));

    // Usecase
    getIt.registerLazySingleton<GetVersionUseCase>(() => GetVersionUseCase(getIt()));
    getIt.registerLazySingleton<InsertEmploymentApplicationUseCase>(() => InsertEmploymentApplicationUseCase(getIt()));
    getIt.registerLazySingleton<GetAvailableJobsUseCase>(() => GetAvailableJobsUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLawyersUseCase>(() => GetAllLawyersUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLawyersFeaturesUseCase>(() => GetAllLawyersFeaturesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLawyersCategoriesUseCase>(() => GetAllLawyersCategoriesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLawyersReviewsUseCase>(() => GetAllLawyersReviewsUseCase(getIt()));
    getIt.registerLazySingleton<InsertLawyerReviewUseCase>(() => InsertLawyerReviewUseCase(getIt()));
    getIt.registerLazySingleton<GetLogsForUserUseCase>(() => GetLogsForUserUseCase(getIt()));
    getIt.registerLazySingleton<InsertLogUseCase>(() => InsertLogUseCase(getIt()));
    getIt.registerLazySingleton<DeleteLogUseCase>(() => DeleteLogUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPackagesUseCase>(() => GetAllPackagesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPlaylistsUseCase>(() => GetAllPlaylistsUseCase(getIt()));
    getIt.registerLazySingleton<InsertPlaylistCommentUseCase>(() => InsertPlaylistCommentUseCase(getIt()));
    getIt.registerLazySingleton<EditPlaylistCommentUseCase>(() => EditPlaylistCommentUseCase(getIt()));
    getIt.registerLazySingleton<DeletePlaylistCommentUseCase>(() => DeletePlaylistCommentUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPublicRelationsUseCase>(() => GetAllPublicRelationsUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPublicRelationsFeaturesUseCase>(() => GetAllPublicRelationsFeaturesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPublicRelationsCategoriesUseCase>(() => GetAllPublicRelationsCategoriesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPublicRelationsReviewsUseCase>(() => GetAllPublicRelationsReviewsUseCase(getIt()));
    getIt.registerLazySingleton<InsertPublicRelationReviewUseCase>(() => InsertPublicRelationReviewUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLegalAccountantsUseCase>(() => GetAllLegalAccountantsUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLegalAccountantsFeaturesUseCase>(() => GetAllLegalAccountantsFeaturesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLegalAccountantsReviewsUseCase>(() => GetAllLegalAccountantsReviewsUseCase(getIt()));
    getIt.registerLazySingleton<InsertLegalAccountantReviewUseCase>(() => InsertLegalAccountantReviewUseCase(getIt()));
    getIt.registerLazySingleton<GetAllSlidersUseCase>(() => GetAllSlidersUseCase(getIt()));
    getIt.registerLazySingleton<GetTransactionsForUserUseCase>(() => GetTransactionsForUserUseCase(getIt()));
    getIt.registerLazySingleton<InsertTransactionUseCase>(() => InsertTransactionUseCase(getIt()));
    getIt.registerLazySingleton<DeleteTransactionUseCase>(() => DeleteTransactionUseCase(getIt()));
    getIt.registerLazySingleton<ToggleIsDoneInstantConsultationUseCase>(() => ToggleIsDoneInstantConsultationUseCase(getIt()));
    getIt.registerLazySingleton<ToggleIsViewedUseCase>(() => ToggleIsViewedUseCase(getIt()));
    getIt.registerLazySingleton<GetAllInstantConsultationsCommentsUseCase>(() => GetAllInstantConsultationsCommentsUseCase(getIt()));
    getIt.registerLazySingleton<CheckAndGetUserAccountUseCase>(() => CheckAndGetUserAccountUseCase(getIt()));
    getIt.registerLazySingleton<IsUserAccountExistUseCase>(() => IsUserAccountExistUseCase(getIt()));
    getIt.registerLazySingleton<InsertUserAccountUseCase>(() => InsertUserAccountUseCase(getIt()));
    getIt.registerLazySingleton<EditUserAccountUseCase>(() => EditUserAccountUseCase(getIt()));
    getIt.registerLazySingleton<DeleteUserAccountUseCase>(() => DeleteUserAccountUseCase(getIt()));
    getIt.registerLazySingleton<GetWalletForUserUseCase>(() => GetWalletForUserUseCase(getIt()));
    getIt.registerLazySingleton<InsertWalletUseCase>(() => InsertWalletUseCase(getIt()));
    getIt.registerLazySingleton<EditWalletUseCase>(() => EditWalletUseCase(getIt()));
    getIt.registerLazySingleton<IsUserHaveWalletUseCase>(() => IsUserHaveWalletUseCase(getIt()));
    getIt.registerLazySingleton<GetSettingsUseCase>(() => GetSettingsUseCase(getIt()));
    getIt.registerLazySingleton<UploadFileUseCase>(() => UploadFileUseCase(getIt()));

    getIt.registerLazySingleton<AddChatUseCase>(() => AddChatUseCase(getIt()));
    getIt.registerLazySingleton<AddMessageUseCase>(() => AddMessageUseCase(getIt()));
    getIt.registerLazySingleton<UpdateMessageModeUseCase>(() => UpdateMessageModeUseCase(getIt()));
    getIt.registerLazySingleton<GetSuggestedMessagesUseCase>(() => GetSuggestedMessagesUseCase(getIt()));

    // Repository
    getIt.registerLazySingleton<BaseRepository>(() => Repository(getIt(), getIt()));

    // Data Source
    getIt.registerLazySingleton<BaseRemoteDataSource>(() => RemoteDataSource());
  }
}