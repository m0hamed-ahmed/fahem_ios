import 'dart:convert';
import 'dart:io';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dependency_injection.dart';
import 'package:fahem/core/utils/my_app.dart';
import 'package:fahem/core/utils/upload_file_provider.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/authentication/controllers/otp_provider.dart';
import 'package:fahem/presentation/features/authentication/controllers/sign_in_with_phone_provider.dart';
import 'package:fahem/presentation/features/authentication/controllers/sign_up_provider.dart';
import 'package:fahem/presentation/features/chat/controllers/chat_room_provider.dart';
import 'package:fahem/presentation/features/chat/controllers/suggested_messages_provider.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/controllers/debt_collection_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/controllers/debt_collection_provider.dart';
import 'package:fahem/presentation/features/fahem_services/establishing_companies/controllers/establishing_companies_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/establishing_companies/controllers/establishing_companies_provider.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/controllers/instant_consultation_form_provider.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/controllers/instant_consultation_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/controllers/instant_lawyers_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/controllers/instant_lawyers_provider.dart';
import 'package:fahem/presentation/features/fahem_services/investment_legal_advice/controllers/investment_legal_advice_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/investment_legal_advice/controllers/investment_legal_advice_provider.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/controllers/real_estate_legal_advice_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/controllers/real_estate_legal_advice_provider.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/controllers/secret_consultation_form_provider.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/controllers/secret_consultation_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/controllers/trademark_registration_and_intellectual_protection_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/controllers/trademark_registration_and_intellectual_protection_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/home_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/sliders_provider.dart';
import 'package:fahem/presentation/features/jobs/controllers/job_apply_provider.dart';
import 'package:fahem/presentation/features/jobs/controllers/job_details_provider.dart';
import 'package:fahem/presentation/features/jobs/controllers/jobs_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_features_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_reviews/controllers/lawyers_reviews_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/controllers/lawyers_categories_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_features_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/main/controllers/main_provider.dart';
import 'package:fahem/presentation/features/packages/controllers/packages_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/profile_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_features_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/controllers/public_relations_reviews_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/search/controllers/search_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlist_details_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlists_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/features/start/controllers/get_start_provider.dart';
import 'package:fahem/presentation/features/start/controllers/splash_provider.dart';
import 'package:fahem/presentation/features/start/controllers/version_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/instant_consultations_comments_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'presentation/features/profile/controllers/user_account_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if(Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD4ZtmU4k6jbaTZ0RwmxugkKXYNxwkdcdM",
        appId: "1:225748921499:ios:bbf8d19d024aca376a2a3e",
        messagingSenderId: "225748921499",
        projectId: "fahem-9ad2c",
      ),
    );
  }
  else {
    await Firebase.initializeApp();
  }
  await CacheHelper.init();
  DependencyInjection.init();
  await NotificationService.init();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  if(CacheHelper.getData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED) == null) {
    CacheHelper.setData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED, value: true);
  }

  await initializeDateFormatting().then((value) {
    runApp(
      Phoenix(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => getIt<JobApplyProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<JobsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyersProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyersFeaturesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyersCategoriesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyersReviewsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LogsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PackagesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PlaylistsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PlaylistDetailsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationsFeaturesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationsCategoriesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationsReviewsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantsFeaturesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantsReviewsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<SlidersProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<TransactionsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<InstantConsultationsCommentsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<SignUpProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<VersionProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<WalletProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<ProfileProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<SettingsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<UploadFileProvider>()),

            ChangeNotifierProvider(create: (context) => getIt<ChatRoomProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<SuggestedMessagesProvider>()),

            ChangeNotifierProvider(create: (context) => AppProvider(
              isEnglish: CacheHelper.getData(key: PREFERENCES_KEY_IS_ENGLISH) ?? false,
              version: packageInfo.version,
            )),
            ChangeNotifierProvider(create: (context) => HomeProvider()),
            ChangeNotifierProvider(create: (context) => SignInWithPhoneProvider()),
            ChangeNotifierProvider(create: (context) => OtpProvider()),
            ChangeNotifierProvider(create: (context) => SplashProvider()),
            ChangeNotifierProvider(create: (context) => GetStartProvider()),
            ChangeNotifierProvider(create: (context) => UserAccountProvider(
              userAccount: CacheHelper.getData(key: PREFERENCES_KEY_USER_ACCOUNT) == null ? null : UserAccountModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_USER_ACCOUNT))),
            )),
            ChangeNotifierProvider(create: (context) => MainProvider()),
            ChangeNotifierProvider(create: (context) => SearchProvider()),
            ChangeNotifierProvider(create: (context) => JobDetailsProvider()),
            ChangeNotifierProvider(create: (context) => InstantLawyersOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => InstantLawyersProvider()),
            ChangeNotifierProvider(create: (context) => InstantConsultationOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => InstantConsultationFormProvider()),
            ChangeNotifierProvider(create: (context) => SecretConsultationOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => SecretConsultationFormProvider()),
            ChangeNotifierProvider(create: (context) => EstablishingCompaniesOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => EstablishingCompaniesProvider()),
            ChangeNotifierProvider(create: (context) => RealEstateLegalAdviceOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => RealEstateLegalAdviceProvider()),
            ChangeNotifierProvider(create: (context) => InvestmentLegalAdviceOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => InvestmentLegalAdviceProvider()),
            ChangeNotifierProvider(create: (context) => TrademarkRegistrationAndIntellectualProtectionOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => TrademarkRegistrationAndIntellectualProtectionProvider()),
            ChangeNotifierProvider(create: (context) => DebtCollectionOnBoardingProvider()),
            ChangeNotifierProvider(create: (context) => DebtCollectionProvider()),
          ],
          child: MyApp(),
        ),
      ),
    );
  });
}