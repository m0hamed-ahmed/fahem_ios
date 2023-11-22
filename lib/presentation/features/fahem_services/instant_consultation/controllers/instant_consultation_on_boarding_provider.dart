import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/data/data_source/static/instant_lawyer_on_boarding_data.dart';
import 'package:flutter/material.dart';

class InstantConsultationOnBoardingProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  setCurrentPage(int index) => _currentPage = index;
  onPageChanged(int index) {_currentPage = index; notifyListeners();}

  late PageController _pageController;
  PageController get pageController => _pageController;

  void init() {
    _pageController = PageController();
  }

  Future<void> next(BuildContext context) async {
    _currentPage++;
    if(currentPage > instantLawyerOnBoardingData.length - 1) {
      skip(context);
    }
    else {
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: ConstantsManager.onBoardingPageViewDuration),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skip(BuildContext context) async {
    CacheHelper.setData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_CONSULTATION, value: false);
    Navigator.pushReplacementNamed(context, Routes.instantConsultationFormRoute);
  }
}