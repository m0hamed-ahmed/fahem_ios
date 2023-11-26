class ApiConstants {

  static const String baseUrl = "https://wazfnee.com/fahem-api/";
  // static const String baseUrl = "http://192.168.1.3/projects/fahem-api/";

  // End Points
  static const String getVersionEndPoint = "${baseUrl}version/get_version.php";
  static const String insertEmploymentApplicationEndPoint = "${baseUrl}jobs/employment_applications/insert_employment_application.php";
  static const String getAvailableJobsEndPoint = "${baseUrl}jobs/jobs/get_available_jobs.php";
  static const String getAllLawyersEndPoint = "${baseUrl}lawyers/lawyers/get_active_lawyers.php";
  static const String getAllLawyersCategoriesEndPoint = "${baseUrl}lawyers/lawyers_categories/get_all_lawyers_categories.php";
  static const String getAllLawyersReviewsEndPoint = "${baseUrl}lawyers/lawyers_reviews/get_all_lawyers_reviews.php";
  static const String insertLawyerReviewEndPoint = "${baseUrl}lawyers/lawyers_reviews/insert_lawyer_review.php";
  static const String getAllLawyersFeaturesEndPoint = "${baseUrl}lawyers/lawyers_features/get_all_lawyers_features.php";
  static const String getAllLegalAccountantsEndPoint = "${baseUrl}legal_accountants/legal_accountants/get_active_legal_accountants.php";
  static const String getAllLegalAccountantsReviewsEndPoint = "${baseUrl}legal_accountants/legal_accountants_reviews/get_all_legal_accountants_reviews.php";
  static const String insertLegalAccountantReviewEndPoint = "${baseUrl}legal_accountants/legal_accountants_reviews/insert_legal_accountant_review.php";
  static const String getAllLegalAccountantsFeaturesEndPoint = "${baseUrl}legal_accountants/legal_accountants_features/get_all_legal_accountants_features.php";
  static const String getAllPackagesEndPoint = "${baseUrl}packages/get_all_packages.php";
  static const String getAllPlaylistsEndPoint = "${baseUrl}playlists/playlists/get_all_playlists.php";
  static const String insertPlaylistCommentEndPoint = "${baseUrl}playlists/playlist_comments/insert_playlist_comment.php";
  static const String editPlaylistCommentEndPoint = "${baseUrl}playlists/playlist_comments/edit_playlist_comment.php"; // wait
  static const String deletePlaylistCommentEndPoint = "${baseUrl}playlists/playlist_comments/delete_playlist_comment.php"; // wait
  static const String getAllPublicRelationsEndPoint = "${baseUrl}public_relations/public_relations/get_active_public_relations.php";
  static const String getAllPublicRelationsCategoriesEndPoint = "${baseUrl}public_relations/public_relations_categories/get_all_public_relations_categories.php";
  static const String getAllPublicRelationsReviewsEndPoint = "${baseUrl}public_relations/public_relations_reviews/get_all_public_relations_reviews.php";
  static const String insertPublicRelationReviewEndPoint = "${baseUrl}public_relations/public_relations_reviews/insert_public_relation_review.php";
  static const String getAllPublicRelationsFeaturesEndPoint = "${baseUrl}public_relations/public_relations_features/get_all_public_relations_features.php";
  static const String getSettingsEndPoint = "${baseUrl}settings/get_settings.php";
  static const String getAllSlidersEndPoint = "${baseUrl}sliders/get_all_sliders.php";
  static const String getAllInstantConsultationsCommentsEndPoint = "${baseUrl}transactions/instant_consultations_comments/get_all_instant_consultations_comments.php";
  static const String getTransactionsForUserEndPoint = "${baseUrl}transactions/transactions/get_transactions_for_user.php";
  static const String insertTransactionEndPoint = "${baseUrl}transactions/transactions/insert_transaction.php";
  static const String deleteTransactionEndPoint = "${baseUrl}transactions/transactions/delete_transaction.php"; // wait
  static const String toggleIsDoneInstantConsultationEndPoint = "${baseUrl}transactions/instant_consultations/toggle_is_done_instant_consultation.php";
  static const String toggleIsViewedEndPoint = "${baseUrl}transactions/transactions/toggle_is_viewed.php";
  static const String checkAndGetUserAccountEndPoint = "${baseUrl}users/users_accounts/check_and_get_user_account.php";
  static const String isUserAccountExistEndPoint = "${baseUrl}users/users_accounts/is_user_account_exist.php"; // wait
  static const String insertUserAccountEndPoint = "${baseUrl}users/users_accounts/insert_user_account.php";
  static const String editUserAccountEndPoint = "${baseUrl}users/users_accounts/edit_user_account.php"; // wait
  static const String deleteUserAccountEndPoint = "${baseUrl}users/users_accounts/delete_user_account.php"; // wait
  static const String getLogsForUserEndPoint = "${baseUrl}users/logs/get_logs_for_user.php";
  static const String insertLogEndPoint = "${baseUrl}users/logs/insert_log.php";
  static const String deleteLogEndPoint = "${baseUrl}users/logs/delete_log.php"; // wait
  static const String isUserHaveWalletEndPoint = "${baseUrl}users/wallets/is_user_have_wallet.php"; // wait
  static const String getWalletForUserEndPoint = "${baseUrl}users/wallets/get_wallet_for_user.php";
  static const String insertWalletEndPoint = "${baseUrl}users/wallets/insert_wallet.php";
  static const String editWalletEndPoint = "${baseUrl}users/wallets/edit_wallet.php";
  static const String uploadFileEndPoint = "${baseUrl}upload_file.php";

  // Fields
  static const String userAccountIdField = 'userAccountId';
  static const String jobIdField = 'jobId';
  static const String playlistIdField = 'playlistId';
  static const String playlistCommentIdField = 'playlistCommentId';
  static const String lawyerIdField = 'lawyerId';
  static const String publicRelationIdField = 'publicRelationId';
  static const String legalAccountantIdField = 'legalAccountantId';
  static const String targetIdField = 'targetId';
  static const String logIdField = 'logId';
  static const String appField = 'app';
  static const String targetNameField = 'targetName';
  static const String transactionIdField = 'transactionId';
  static const String bestLawyerIdField = 'bestLawyerId';
  static const String walletIdField = 'walletId';
  static const String packageIdField = 'packageId';
  static const String phoneNumberField = 'phoneNumber';
  static const String firstNameField = 'firstName';
  static const String familyNameField = 'familyName';
  static const String emailAddressField = 'emailAddress';
  static const String textArField = 'textAr';
  static const String textEnField = 'textEn';
  static const String bookingDateTimeStampField = 'bookingDateTimeStamp';
  static const String reasonForRegistrationField = 'reasonForRegistration';
  static const String genderField = 'gender';
  static const String birthDateField = 'birthDate';
  static const String balanceField = 'balance';
  static const String nameField = 'name';
  static const String cvField = 'cv';
  static const String commentField = 'comment';
  static const String ratingField = 'rating';
  static const String featuresArField = 'featuresAr';
  static const String featuresEnField = 'featuresEn';
  static const String transactionTypeField = 'transactionType';
  static const String isDoneInstantConsultationField = 'isDoneInstantConsultation';
  static const String isViewedField = 'isViewed';
  static const String createdAtField = 'createdAt';
  static const String fileField = "file";
  static const String directoryField = "directory";

  // Images Directory
  static const String playlistsDirectory = "playlists";
  static const String slidersDirectory = "sliders";
  static const String jobsDirectory = "jobs";
  static const String employmentApplicationsDirectory = "employment_applications";
  static const String lawyersCategoriesDirectory = "lawyers_categories";
  static const String lawyersDirectory = "lawyers";
  static const String lawyersGalleryDirectory = "lawyers_gallery";
  static const String publicRelationsCategoriesDirectory = "public_relations_categories";
  static const String publicRelationsDirectory = "public_relations";
  static const String publicRelationsGalleryDirectory = "public_relations_gallery";
  static const String legalAccountantsDirectory = "legal_accountants";
  static const String legalAccountantsGalleryDirectory = "legal_accountants_gallery";

  // File URL
  static String fileUrl({required String fileName}) => '${baseUrl}upload/$fileName';
}