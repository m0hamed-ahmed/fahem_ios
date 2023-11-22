import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/debt_collection_on_boarding_data.dart';
import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/controllers/debt_collection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtCollectionOnBoardingProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  setCurrentPage(int index) => _currentPage = index;
  onPageChanged(int index) {_currentPage = index; notifyListeners();}

  late PageController _pageController;
  PageController get pageController => _pageController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  void init() {
    _pageController = PageController();
  }

  Future<void> next(BuildContext context) async {
    if(_currentPage == debtCollectionOnBoardingData.length - 1) {
      skip(context);
    }
    else {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: ConstantsManager.onBoardingPageViewDuration),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skip(BuildContext context) async {
    changeIsLoading(true);
    await Methods.checkPermissionAndGetCurrentPosition(context).then((position) {
      if(position != null) {
        DebtCollectionProvider debtCollectionProvider = Provider.of<DebtCollectionProvider>(context, listen: false);
        governoratesData[0].latitude = position.latitude;
        governoratesData[0].longitude = position.longitude;
        debtCollectionProvider.setSelectedGovernmentModel(governoratesData[0]);
        debtCollectionProvider.myCurrentPositionLatitude = position.latitude;
        debtCollectionProvider.myCurrentPositionLongitude = position.longitude;
        CacheHelper.setData(key: PREFERENCES_KEY_IS_FIRST_OPEN_DEBT_COLLECTION, value: false);
        Navigator.pushReplacementNamed(context, Routes.debtCollectionRoute);
      }
    });
    changeIsLoading(false);
  }
}