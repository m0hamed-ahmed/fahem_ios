import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/presentation/features/chat/screens/chat_room_screen.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/screens/debt_collection_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/screens/debt_collection_screen.dart';
import 'package:fahem/presentation/features/fahem_services/establishing_companies/screens/establishing_companies_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/establishing_companies/screens/establishing_companies_screen.dart';
import 'package:fahem/presentation/features/fahem_services/fahem_services/screens/fahem_services_screen.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/screens/instant_consultation_form_screen.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/screens/instant_consultation_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/screens/instant_lawyers_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/screens/instant_lawyers_screen.dart';
import 'package:fahem/presentation/features/fahem_services/investment_legal_advice/screens/investment_legal_advice_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/investment_legal_advice/screens/investment_legal_advice_screen.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/screens/real_estate_legal_advice_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/screens/real_estate_legal_advice_screen.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/screens/secret_consultation_form_screen.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/screens/secret_consultation_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/screens/trademark_registration_and_intellectual_protection_on_boarding_screen.dart';
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/screens/trademark_registration_and_intellectual_protection_screen.dart';
import 'package:fahem/presentation/features/authentication/screens/sign_in_with_phone_number_screen.dart';
import 'package:fahem/presentation/features/authentication/screens/otp_screen.dart';
import 'package:fahem/presentation/features/authentication/screens/sign_up_screen.dart';
import 'package:fahem/presentation/features/jobs/screens/job_apply_screen.dart';
import 'package:fahem/presentation/features/jobs/screens/job_details_screen.dart';
import 'package:fahem/presentation/features/jobs/screens/jobs_screen.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/screens/lawyer_details_screen.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/screens/lawyers_screen.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/screens/lawyers_categories_screen.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_reviews/screens/lawyer_reviews_screen.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/screens/legal_accountant_reviews_screen.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/screens/legal_accountant_details_screen.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/screens/legal_accountants_screen.dart';
import 'package:fahem/presentation/features/main/screens/main_screen.dart';
import 'package:fahem/presentation/features/packages/screens/packages_screen.dart';
import 'package:fahem/presentation/features/profile/screens/profile_screen.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/screens/public_relation_reviews_screen.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/screens/public_relation_details_screen.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/screens/public_relations_screen.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/screens/public_relations_categories_screen.dart';
import 'package:fahem/presentation/features/playlists/screens/playlist_details_screen.dart';
import 'package:fahem/presentation/features/playlists/screens/playlists_screens.dart';
import 'package:fahem/presentation/features/show_full_image/screens/show_full_image_screen.dart';
import 'package:fahem/presentation/features/start/screens/get_start_screen.dart';
import 'package:fahem/presentation/features/start/screens/splash_screen.dart';
import 'package:fahem/presentation/features/terms_of_use_and_privacy_policy/privacy_policy/screens/privacy_policy_screen.dart';
import 'package:fahem/presentation/features/terms_of_use_and_privacy_policy/terms_of_use/screens/terms_of_use_screen.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/screens/return_to_the_transaction_screen.dart';
import 'package:flutter/material.dart';

class Routes {

  // Start
  static const String getStartRoute = '/getStartRoute';
  static const String splashRoute = '/splashRoute';

  // Authentication
  static const String signInWithPhoneNumberRoute = '/signInWithPhoneNumberRoute';
  static const String otpRoute = '/otpRoute';
  static const String signUpRoute = '/signUpRoute';

  // Terms Of Use And Privacy Policy
  static const String termsOfUseRoute = '/termsOfUseRoute';
  static const String privacyPolicyRoute = '/privacyPolicyRoute';

  // Main
  static const String mainRoute = '/mainRoute';

  // Lawyers
  static const String lawyersCategoriesRoute = '/lawyersCategoriesRoute';
  static const String lawyersRoute = '/lawyersRoute';
  static const String lawyerDetailsRoute = '/LawyerDetailsRoute';
  static const String lawyerReviewsRoute = '/lawyerReviewsRoute';

  // Public Relations
  static const String publicRelationsCategoriesRoute = '/publicRelationsCategoriesRoute';
  static const String publicRelationsRoute = '/publicRelationsRoute';
  static const String publicRelationDetailsRoute = '/publicRelationDetailsRoute';
  static const String publicRelationReviewsRoute = '/publicRelationReviewsRoute';

  // Legal Accounts
  static const String legalAccountantsRoute = '/legalAccountantsRoute';
  static const String legalAccountantDetailsRoute = '/legalAccountantDetailsRoute';
  static const String legalAccountantReviewsRoute = '/legalAccountantReviewsRoute';

  // Fahem Services
  static const String fahemServicesRoute = '/fahemServicesRoute';

  // Instant Lawyers
  static const String instantLawyersOnBoardingRoute = '/instantLawyersOnBoardingRoute';
  static const String instantLawyersRoute = '/instantLawyersRoute';

  // Instant Consultation
  static const String instantConsultationOnBoardingRoute = '/instantConsultationOnBoardingRoute';
  static const String instantConsultationFormRoute = '/instantConsultationFormRoute';

  // Secret Consultation
  static const String secretConsultationOnBoardingRoute = '/secretConsultationOnBoardingRoute';
  static const String secretConsultationFormRoute = '/secretConsultationFormRoute';

  // Establishing Companies
  static const String establishingCompaniesOnBoardingRoute = '/establishingCompaniesOnBoardingRoute';
  static const String establishingCompaniesRoute = '/establishingCompaniesRoute';

  // Real Estate Legal Advice
  static const String realEstateLegalAdviceOnBoardingRoute = '/realEstateLegalAdviceOnBoardingRoute';
  static const String realEstateLegalAdviceRoute = '/realEstateLegalAdviceRoute';

  // Investment Legal Advice
  static const String investmentLegalAdviceOnBoardingRoute = '/investmentLegalAdviceOnBoardingRoute';
  static const String investmentLegalAdviceRoute = '/investmentLegalAdviceRoute';

  // Trademark Registration And Intellectual Protection
  static const String trademarkRegistrationAndIntellectualProtectionOnBoardingRoute = '/trademarkRegistrationAndIntellectualProtectionOnBoardingRoute';
  static const String trademarkRegistrationAndIntellectualProtectionRoute = '/trademarkRegistrationAndIntellectualProtectionRoute';

  // Debt Collection
  static const String debtCollectionOnBoardingRoute = '/debtCollectionOnBoardingRoute';
  static const String debtCollectionRoute = '/debtCollectionRoute';

  // Jobs
  static const String jobsRoute = '/jobsRoute';
  static const String jobDetailsRoute = '/jobDetailsRoute';
  static const String jobApplyRoute = '/jobApplyRoute';

  // Playlists
  static const String playlistsRoute = '/playlistsRoute';
  static const String playlistDetailsRoute = '/playlistDetailsRoute';

  // Return To The Transaction
  static const String returnToTheTransactionRoute = '/returnToTheTransactionRoute';

  // Packages
  static const String packagesRoute = '/packagesRoute';

  // Chat
  static const String chatRoomRoute = '/chatRoomRoute';

  // Profile
  static const String profileRoute = '/profileRoute';

  // Show Full Image
  static const String showFullImageRoute = '/showFullImageRoute';
}

PageRouteBuilder onGenerateRoute (routeSettings) {
  bool isFirstOpenApp = CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_APP) ?? true;

  return PageRouteBuilder(
    settings: routeSettings,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return routeSettings.name == Routes.showFullImageRoute ? ShowFullImageScreen(
        image: routeSettings.arguments[ConstantsManager.imageArgument],
        directory: routeSettings.arguments[ConstantsManager.directoryArgument],
      ) : _slideTransition(animation: animation, child: child);
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      switch (routeSettings.name) {

        // Authentication
        case Routes.signInWithPhoneNumberRoute: return const SignInWithPhoneNumberScreen();
        case Routes.otpRoute: return OtpScreen(verificationId: routeSettings.arguments[ConstantsManager.verificationIdArgument], phoneNumber: routeSettings.arguments[ConstantsManager.phoneNumberArgument]);
        case Routes.signUpRoute: return SignUpScreen(phoneNumber: routeSettings.arguments[ConstantsManager.phoneNumberArgument]);

        // Terms Of Use And Privacy Policy
        case Routes.termsOfUseRoute: return const TermsOfUseScreen();
        case Routes.privacyPolicyRoute: return const PrivacyPolicyScreen();

        // Main
        case Routes.mainRoute: return const MainScreen();

        // Lawyers
        case Routes.lawyersCategoriesRoute: return const LawyersCategoriesScreen();
        case Routes.lawyersRoute: return LawyersScreen(lawyersCategoryId: routeSettings.arguments[ConstantsManager.lawyersCategoryIdArgument]);
        case Routes.lawyerDetailsRoute: return LawyerDetailsScreen(lawyerModel: routeSettings.arguments[ConstantsManager.lawyerModelArgument]);
        case Routes.lawyerReviewsRoute: return const LawyerReviewsScreen();

        // Public Relations
        case Routes.publicRelationsCategoriesRoute: return const PublicRelationsCategoriesScreen();
        case Routes.publicRelationsRoute: return PublicRelationsScreen(publicRelationCategoryId: routeSettings.arguments[ConstantsManager.publicRelationCategoryIdArgument]);
        case Routes.publicRelationDetailsRoute: return PublicRelationDetailsScreen(publicRelationModel: routeSettings.arguments[ConstantsManager.publicRelationModelArgument]);
        case Routes.publicRelationReviewsRoute: return const PublicRelationReviewsScreen();

        // Legal Accounts
        case Routes.legalAccountantsRoute: return const LegalAccountantsScreen();
        case Routes.legalAccountantDetailsRoute: return LegalAccountantDetailsScreen(legalAccountantModel: routeSettings.arguments[ConstantsManager.legalAccountantModelArgument]);
        case Routes.legalAccountantReviewsRoute: return const LegalAccountantReviewsScreen();

        // Fahem Services
        case Routes.fahemServicesRoute: return const FahemServicesScreen();

        // Instant Lawyers
        case Routes.instantLawyersOnBoardingRoute: return const InstantLawyersOnBoardingScreen();
        case Routes.instantLawyersRoute: return const InstantLawyersScreen();

        // Instant Consultation
        case Routes.instantConsultationOnBoardingRoute: return const InstantConsultationOnBoardingScreen();
        case Routes.instantConsultationFormRoute: return const InstantConsultationFormScreen();

        // Secret Consultation
        case Routes.secretConsultationOnBoardingRoute: return const SecretConsultationOnBoardingScreen();
        case Routes.secretConsultationFormRoute: return const SecretConsultationFormScreen();

        // Establishing Companies
        case Routes.establishingCompaniesOnBoardingRoute: return const EstablishingCompaniesOnBoardingScreen();
        case Routes.establishingCompaniesRoute: return const EstablishingCompaniesScreen();

        // Real Estate Legal Advice
        case Routes.realEstateLegalAdviceOnBoardingRoute: return const RealEstateLegalAdviceOnBoardingScreen();
        case Routes.realEstateLegalAdviceRoute: return const RealEstateLegalAdviceScreen();

        // Investment Legal Advice
        case Routes.investmentLegalAdviceOnBoardingRoute: return const InvestmentLegalAdviceOnBoardingScreen();
        case Routes.investmentLegalAdviceRoute: return const InvestmentLegalAdviceScreen();

        // Trademark Registration And Intellectual Protection
        case Routes.trademarkRegistrationAndIntellectualProtectionOnBoardingRoute: return const TrademarkRegistrationAndIntellectualProtectionOnBoardingScreen();
        case Routes.trademarkRegistrationAndIntellectualProtectionRoute: return const TrademarkRegistrationAndIntellectualProtectionScreen();

        // Debt Collection
        case Routes.debtCollectionOnBoardingRoute: return const DebtCollectionOnBoardingScreen();
        case Routes.debtCollectionRoute: return const DebtCollectionScreen();

        // Jobs
        case Routes.jobsRoute: return const JobsScreen();
        case Routes.jobDetailsRoute: return JobDetailsScreen(jobModel: routeSettings.arguments[ConstantsManager.jobModelArgument], tag: routeSettings.arguments[ConstantsManager.tagArgument]);
        case Routes.jobApplyRoute: return JobApplyScreen(jobModel: routeSettings.arguments[ConstantsManager.jobModelArgument], tag: routeSettings.arguments[ConstantsManager.tagArgument]);

        // Playlists
        case Routes.playlistsRoute: return const PlaylistsScreen();
        case Routes.playlistDetailsRoute: return PlaylistDetailsScreen(playlistModel: routeSettings.arguments[ConstantsManager.playlistModelArgument]);

        // Return To The Transaction
        case Routes.returnToTheTransactionRoute: return ReturnToTheTransactionScreen(transactionModel: routeSettings.arguments[ConstantsManager.transactionModelArgument]);

        // Packages
        case Routes.packagesRoute: return const PackagesScreen();

        // Chat
        case Routes.chatRoomRoute: return const ChatRoomScreen();

        // Profile
        case Routes.profileRoute: return const ProfileScreen();

        default: return isFirstOpenApp ? const GetStartScreen() : const SplashScreen();
      }
    },
  );
}

Widget _slideTransition({required Animation<double> animation, required Widget child}) {
  const Offset begin = Offset(1.0, 0.0);
  const Offset end = Offset.zero;
  const Cubic curve = Curves.ease;
  Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}