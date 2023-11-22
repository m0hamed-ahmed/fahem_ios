import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/data/data_source/static/instant_lawyer_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/controllers/instant_lawyers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantLawyersOnBoardingProvider with ChangeNotifier {
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
    if(_currentPage == instantLawyerOnBoardingData.length - 1) {
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
        InstantLawyersProvider instantLawyersProvider = Provider.of<InstantLawyersProvider>(context, listen: false);
        governoratesData[0].latitude = position.latitude;
        governoratesData[0].longitude = position.longitude;
        instantLawyersProvider.setSelectedGovernmentModel(governoratesData[0]);
        instantLawyersProvider.myCurrentPositionLatitude = position.latitude;
        instantLawyersProvider.myCurrentPositionLongitude = position.longitude;
        CacheHelper.setData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_LAWYERS, value: false);
        Navigator.pushReplacementNamed(context, Routes.instantLawyersRoute);
      }
    });
    changeIsLoading(false);
  }
}