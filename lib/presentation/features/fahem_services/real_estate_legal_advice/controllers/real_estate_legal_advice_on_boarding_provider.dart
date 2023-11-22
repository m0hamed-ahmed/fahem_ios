import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/data/data_source/static/real_estate_legal_advice_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/controllers/real_estate_legal_advice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealEstateLegalAdviceOnBoardingProvider with ChangeNotifier {
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
    if(_currentPage == realEstateLegalAdviceOnBoardingData.length - 1) {
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
        RealEstateLegalAdviceProvider realEstateLegalAdviceProvider = Provider.of<RealEstateLegalAdviceProvider>(context, listen: false);
        governoratesData[0].latitude = position.latitude;
        governoratesData[0].longitude = position.longitude;
        realEstateLegalAdviceProvider.setSelectedGovernmentModel(governoratesData[0]);
        realEstateLegalAdviceProvider.myCurrentPositionLatitude = position.latitude;
        realEstateLegalAdviceProvider.myCurrentPositionLongitude = position.longitude;
        CacheHelper.setData(key: PREFERENCES_KEY_IS_FIRST_OPEN_REAL_ESTATE_LEGAL_ADVICE, value: false);
        Navigator.pushReplacementNamed(context, Routes.realEstateLegalAdviceRoute);
      }
    });
    changeIsLoading(false);
  }
}