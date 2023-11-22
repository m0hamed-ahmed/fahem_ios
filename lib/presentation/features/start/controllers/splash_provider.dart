import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/chat/suggested_message_model.dart';
import 'package:fahem/data/models/static/search_model.dart';
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
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_features/public_relation_feature_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/data/models/settings/settings_model.dart';
import 'package:fahem/data/models/sliders/slider_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/data/models/packages/package_model.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/data/models/version/version_model.dart';
import 'package:fahem/domain/usecases/users/logs/get_logs_for_user_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/get_transactions_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/get_wallet_for_user_usecase.dart';
import 'package:fahem/presentation/features/chat/controllers/suggested_messages_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/sliders_provider.dart';
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
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_features_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/controllers/public_relations_reviews_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlists_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/search/controllers/search_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/features/start/controllers/version_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/instant_consultations_comments_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashProvider with ChangeNotifier {

  bool _isGetDataDone = false;
  setIsGetDataDone(bool isGetDataDone) => _isGetDataDone = isGetDataDone;

  bool _isErrorOccurred = false;
  bool get isErrorOccurred => _isErrorOccurred;
  changeIsErrorOccurred(bool isErrorOccurred) {_isErrorOccurred = isErrorOccurred; notifyListeners();}

  Timer? _loadingTimer;
  setLoadingTimer(Timer? loadingTimer) => _loadingTimer = loadingTimer;

  int _loadingCount = 0;
  int get loadingCount => _loadingCount;
  changeLoadingCount(int loadingCount) {_loadingCount = loadingCount; notifyListeners();}

  void _startLoading() {
    _loadingTimer ??= Timer.periodic(const Duration(milliseconds: ConstantsManager.splashLoadingDuration), (timer) {
      changeLoadingCount(++_loadingCount);
    });
  }

  void _cancelLoading() {
    _loadingTimer?.cancel();
    setLoadingTimer(null);
  }

  Future<void> getVersionAndGetData(BuildContext context) async {
    if(Platform.isAndroid) {
      await _getVersion(context);
    }
    else {
      await getData(context: context);
    }
  }

  Future<void> _getVersion(BuildContext context) async {
    VersionProvider versionProvider = Provider.of<VersionProvider>(context, listen: false);

    Either<Failure, VersionModel> response = await versionProvider.getVersionImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (versionModel) async {
      if(versionModel.isReview) {
        await getData(context: context);
      }
      await _isAppNeedToUpdate(versionModel).then((value) async {
        if(value) {
          await _updateApp(context, versionModel.isMustUpdate ? true : false);
        }
        else {
          await getData(context: context);
        }
      });
    });
  }

  Future<bool> _isAppNeedToUpdate(VersionModel versionModel) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version != versionModel.version;
  }

  Future<void> _updateApp(BuildContext context, bool isMustUpdate) async {
    if(isMustUpdate) {
      _removeDataFromCache();
    }

    await Dialogs.showUpdateDialog(context, StringsManager.update, StringsManager.updateMsg, isMustUpdate: isMustUpdate).then((value) async {
      if(value) {
        await Methods.openUrl(ConstantsManager.playStoreUrl).then((value) {
          Navigator.pop(context);
        });
      }
      else {
        if(!isMustUpdate) {
          await getData(context: context);
        }
      }
    });
  }

  Future<void> _removeDataFromCache() async {
    CacheHelper.removeData(key: PREFERENCES_KEY_USER_ACCOUNT);
  }

  Future<void> getData({required BuildContext context, bool isSwipeRefresh = false}) async {
    if(!isSwipeRefresh) _startLoading();
    await _getAllLawyers(context);
    await _getAllPublicRelations(context);
    await _getAllLegalAccountants(context);
    _setSearchData(context);
    await Future.wait([
      _getAllPackages(context),
      _getAvailableJobs(context),
      _getAllPlaylists(context),
      _getAllLawyersCategories(context),
      _getAllLawyersReviews(context),
      _getAllLawyersFeatures(context),
      _getAllPublicRelationsCategories(context),
      _getAllPublicRelationsReviews(context),
      _getAllPublicRelationsFeatures(context),
      _getAllSliders(context),
      _getAllLegalAccountantsReviews(context),
      _getAllLegalAccountantsFeatures(context),
      _getAllInstantConsultationsComments(context),
      _getWalletForUser(context),
      _getLogsForUser(context),
      _getTransactionsForUser(context),
      _getSettings(context),
      _getSuggestedMessages(context),
    ]).then((value) {
      if(!isSwipeRefresh) {
        Future.delayed(const Duration(seconds: ConstantsManager.splashScreenDuration)).then((value) {
          setIsGetDataDone(true);
          _cancelLoading();
          if(_isGetDataDone && !_isErrorOccurred) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute, (route) => false);
          }
        });
      }
    });
  }

  void _setSearchData(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context, listen: false);
    LawyersProvider lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
    PublicRelationsProvider publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);
    LegalAccountantsProvider legalAccountantsProvider = Provider.of<LegalAccountantsProvider>(context, listen: false);

    List<SearchModel> list = [];
    for(int i=0; i<lawyersProvider.lawyers.length; i++) {
      list.add(SearchModel.fromJson(LawyerModel.toMap(lawyersProvider.lawyers[i])));
    }
    for(int i=0; i<publicRelationsProvider.publicRelations.length; i++) {
      list.add(SearchModel.fromJson(PublicRelationModel.toMap(publicRelationsProvider.publicRelations[i])));
    }
    for(int i=0; i<legalAccountantsProvider.legalAccountants.length; i++) {
      list.add(SearchModel.fromJson(LegalAccountantModel.toMap(legalAccountantsProvider.legalAccountants[i])));
    }

    // list.sort((a, b) => b.rating.compareTo(a.rating));
    list.sort((a, b) => b.isVerified ? 1 : -1);

    searchProvider.setSearchData(list);
  }

  Future<void> _getAllLawyers(BuildContext context) async {
    LawyersProvider lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);

    Either<Failure, List<LawyerModel>> response = await lawyersProvider.getAllLawyersImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (lawyers) async {
      lawyersProvider.setLawyers(lawyers);
    });
  }

  Future<void> _getAllPublicRelations(BuildContext context) async {
    PublicRelationsProvider publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);

    Either<Failure, List<PublicRelationModel>> response = await publicRelationsProvider.getAllPublicRelationsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelations) async {
      publicRelationsProvider.setPublicRelations(publicRelations);
    });
  }

  Future<void> _getAllLegalAccountants(BuildContext context) async {
    LegalAccountantsProvider legalAccountantsProvider = Provider.of<LegalAccountantsProvider>(context, listen: false);

    Either<Failure, List<LegalAccountantModel>> response = await legalAccountantsProvider.getAllLegalAccountantsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountants) async {
      legalAccountantsProvider.setLegalAccountants(legalAccountants);
    });
  }

  Future<void> _getAllPackages(BuildContext context) async {
    PackagesProvider packagesProvider = Provider.of<PackagesProvider>(context, listen: false);

    Either<Failure, List<PackageModel>> response = await packagesProvider.getAllPackagesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (packages) async {
      packagesProvider.setPackages(packages);
    });
  }

  Future<void> _getAvailableJobs(BuildContext context) async {
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    Either<Failure, List<JobModel>> response = await jobsProvider.getAvailableJobsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (jobs) async {
      jobsProvider.setJobs(jobs);
    });
  }

  Future<void> _getAllPlaylists(BuildContext context) async {
    PlaylistsProvider playlistsProvider = Provider.of<PlaylistsProvider>(context, listen: false);

    Either<Failure, List<PlaylistModel>> response = await playlistsProvider.getAllPlaylistsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (playlists) async {
      playlistsProvider.setPlaylists(playlists);
    });
  }

  Future<void> _getAllLawyersReviews(BuildContext context) async {
    LawyersReviewsProvider lawyersReviewsProvider = Provider.of<LawyersReviewsProvider>(context, listen: false);

    Either<Failure, List<LawyerReviewModel>> response = await lawyersReviewsProvider.getAllLawyersReviewsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (lawyersReviews) async {
      lawyersReviewsProvider.setLawyersReviews(lawyersReviews);
    });
  }

  Future<void> _getAllPublicRelationsReviews(BuildContext context) async {
    PublicRelationsReviewsProvider publicRelationsReviewsProvider = Provider.of<PublicRelationsReviewsProvider>(context, listen: false);

    Either<Failure, List<PublicRelationReviewModel>> response = await publicRelationsReviewsProvider.getAllPublicRelationsReviewsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelationsReviews) async {
      publicRelationsReviewsProvider.setPublicRelationsReviews(publicRelationsReviews);
    });
  }

  Future<void> _getAllLegalAccountantsReviews(BuildContext context) async {
    LegalAccountantsReviewsProvider legalAccountantsReviewsProvider = Provider.of<LegalAccountantsReviewsProvider>(context, listen: false);

    Either<Failure, List<LegalAccountantReviewModel>> response = await legalAccountantsReviewsProvider.getAllLegalAccountantsReviewsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountantsReviews) async {
      legalAccountantsReviewsProvider.setLegalAccountantsReviews(legalAccountantsReviews);
    });
  }

  Future<void> _getAllLawyersFeatures(BuildContext context) async {
    LawyersFeaturesProvider lawyersFeaturesProvider = Provider.of<LawyersFeaturesProvider>(context, listen: false);

    Either<Failure, List<LawyerFeatureModel>> response = await lawyersFeaturesProvider.getAllLawyersFeaturesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (lawyersFeatures) async {
      lawyersFeaturesProvider.setLawyersFeatures(lawyersFeatures);
    });
  }

  Future<void> _getAllPublicRelationsFeatures(BuildContext context) async {
    PublicRelationsFeaturesProvider publicRelationsFeaturesProvider = Provider.of<PublicRelationsFeaturesProvider>(context, listen: false);

    Either<Failure, List<PublicRelationFeatureModel>> response = await publicRelationsFeaturesProvider.getAllPublicRelationsFeaturesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelationsFeatures) async {
      publicRelationsFeaturesProvider.setPublicRelationsFeatures(publicRelationsFeatures);
    });
  }

  Future<void> _getAllLegalAccountantsFeatures(BuildContext context) async {
    LegalAccountantsFeaturesProvider legalAccountantsFeaturesProvider = Provider.of<LegalAccountantsFeaturesProvider>(context, listen: false);

    Either<Failure, List<LegalAccountantFeatureModel>> response = await legalAccountantsFeaturesProvider.getAllLegalAccountantsFeaturesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountantsFeatures) async {
      legalAccountantsFeaturesProvider.setLegalAccountantsFeatures(legalAccountantsFeatures);
    });
  }

  Future<void> _getAllLawyersCategories(BuildContext context) async {
    LawyersCategoriesProvider lawyersCategoriesProvider = Provider.of<LawyersCategoriesProvider>(context, listen: false);

    Either<Failure, List<LawyerCategoryModel>> response = await lawyersCategoriesProvider.getAllLawyersCategoriesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (lawyersCategories) async {
      lawyersCategoriesProvider.setLawyersCategories(lawyersCategories);
    });
  }

  Future<void> _getAllPublicRelationsCategories(BuildContext context) async {
    PublicRelationsCategoriesProvider publicRelationsCategoriesProvider = Provider.of<PublicRelationsCategoriesProvider>(context, listen: false);

    Either<Failure, List<PublicRelationCategoryModel>> response = await publicRelationsCategoriesProvider.getAllPublicRelationsCategoriesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelationsCategories) async {
      publicRelationsCategoriesProvider.setPublicRelationsCategories(publicRelationsCategories);
    });
  }

  Future<void> _getAllSliders(BuildContext context) async {
    SlidersProvider slidersProvider = Provider.of<SlidersProvider>(context, listen: false);

    Either<Failure, List<SliderModel>> response = await slidersProvider.getAllSlidersImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (sliders) async {
      slidersProvider.setSliders(sliders);
    });
  }

  Future<void> _getAllInstantConsultationsComments(BuildContext context) async {
    InstantConsultationsCommentsProvider instantConsultationsCommentsProvider = Provider.of<InstantConsultationsCommentsProvider>(context, listen: false);

    Either<Failure, List<InstantConsultationCommentModel>> response = await instantConsultationsCommentsProvider.getAllInstantConsultationsCommentsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (instantConsultationsComments) async {
      instantConsultationsCommentsProvider.setInstantConsultationsComments(instantConsultationsComments);
    });
  }

  Future<void> _getTransactionsForUser(BuildContext context) async {
    TransactionsProvider transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    if(userAccountProvider.userAccount == null) return;

    GetTransactionsForUserParameters parameters = GetTransactionsForUserParameters(
      userAccountId: userAccountProvider.userAccount!.userAccountId,
    );
    Either<Failure, List<TransactionModel>> response = await transactionsProvider.getTransactionsForUserImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (transactions) async {
      List<TransactionModel> list = [];
      LawyersProvider lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
      PublicRelationsProvider publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);
      LegalAccountantsProvider legalAccountantsProvider = Provider.of<LegalAccountantsProvider>(context, listen: false);
      for(int i=0; i<transactions.length; i++) {
        if(transactions[i].transactionType == TransactionType.showLawyerNumber || transactions[i].transactionType == TransactionType.appointmentBookingWithLawyer) {
          if(lawyersProvider.getLawyerWithId(transactions[i].targetId) != null) {list.add(transactions[i]);}
        }
        else if(transactions[i].transactionType == TransactionType.showPublicRelationNumber || transactions[i].transactionType == TransactionType.appointmentBookingWithPublicRelation) {
          if(publicRelationsProvider.getPublicRelationWithId(transactions[i].targetId) != null) {list.add(transactions[i]);}
        }
        else if(transactions[i].transactionType == TransactionType.showLegalAccountantNumber || transactions[i].transactionType == TransactionType.appointmentBookingWithLegalAccountant) {
          if(legalAccountantsProvider.getLegalAccountantWithId(transactions[i].targetId) != null) {list.add(transactions[i]);}
        }
        else {
          list.add(transactions[i]);
        }
      }
      transactionsProvider.setTransactions(list);
    });
  }

  Future<void> _getLogsForUser(BuildContext context) async {
    LogsProvider logsProvider = Provider.of<LogsProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    if(userAccountProvider.userAccount == null) return;

    GetLogsForUserParameters parameters = GetLogsForUserParameters(
      userAccountId: userAccountProvider.userAccount!.userAccountId,
    );
    Either<Failure, List<LogModel>> response = await logsProvider.getLogsForUserImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (logs) async {
      logsProvider.setLogs(logs);
    });
  }

  Future<void> _getWalletForUser(BuildContext context) async {
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    if(userAccountProvider.userAccount == null) return;

    GetWalletParameters parameters = GetWalletParameters(
      userAccountId: userAccountProvider.userAccount!.userAccountId,
    );
    Either<Failure, WalletModel?> response = await walletProvider.getWalletForUserImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (wallet) async {
      walletProvider.setWallet(wallet);
    });
  }

  Future<void> _getSettings(BuildContext context) async {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    Either<Failure, SettingsModel> response = await settingsProvider.getSettingsImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (settings) async {
      settingsProvider.setSettings(settings);
    });
  }

  Future<void> _getSuggestedMessages(BuildContext context) async {
    SuggestedMessagesProvider suggestedMessagesProvider = Provider.of<SuggestedMessagesProvider>(context, listen: false);

    Either<Failure, List<SuggestedMessageModel>> response = await suggestedMessagesProvider.getSuggestedMessagesImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (suggestedMessages) async {
      suggestedMessagesProvider.setSuggestedMessages(suggestedMessages);
    });
  }

  Future<void> onPressedTryAgain(BuildContext context) async {
    changeIsErrorOccurred(false);
    await getVersionAndGetData(context);
  }
}