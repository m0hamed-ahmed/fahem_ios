import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers/get_all_lawyers_usecase.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LawyersProvider with ChangeNotifier {
  final GetAllLawyersUseCase _getAllLawyersUseCase;

  LawyersProvider(this._getAllLawyersUseCase);

  Future<Either<Failure, List<LawyerModel>>> getAllLawyersImpl() async {
    return await _getAllLawyersUseCase.call(const NoParameters());
  }

  List<LawyerModel> _lawyers = [];
  List<LawyerModel> get lawyers => _lawyers;
  setLawyers(List<LawyerModel> lawyers) => _lawyers = lawyers;

  List<LawyerModel> _selectedLawyers = [];
  List<LawyerModel> get selectedLawyers => _selectedLawyers;
  changeSelectedLawyers(List<LawyerModel> selectedLawyers) {
    _selectedLawyers = selectedLawyers;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  GovernmentModel? _selectedGovernmentModel;
  GovernmentModel? get selectedGovernmentModel => _selectedGovernmentModel;
  setSelectedGovernmentModel(GovernmentModel? selectedGovernmentModel) => _selectedGovernmentModel = selectedGovernmentModel;
  changeSelectedGovernmentModel(GovernmentModel? selectedGovernmentModel) {_selectedGovernmentModel = selectedGovernmentModel; notifyListeners();}

  LawyerModel? getLawyerWithId(int lawyerId) {
    int index = _lawyers.indexWhere((element) => element.lawyerId == lawyerId);
    if(index == -1) {
      return null;
    }
    else {
      return _lawyers[index];
    }
  }

  void onChangeSearch(BuildContext context, String val, int lawyersCategoryId) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if(_selectedGovernmentModel != null) {
      if(val.isEmpty) {
        if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
          changeSelectedLawyers(_lawyers.where((lawyer) {
            double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, lawyer.latitude, lawyer.longitude) / 1000;
            return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
                && distanceKm <= settingsProvider.settings.distanceKm;
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
          changeSelectedLawyers(_lawyers.where((lawyer) {
            return lawyer.categoriesIds.contains(lawyersCategoryId.toString());
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else {
          changeSelectedLawyers(_lawyers.where((lawyer) {
            return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
                && lawyer.governorate == _selectedGovernmentModel!.nameAr;
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
      }
      else {
        if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
          changeSelectedLawyers(_lawyers.where((lawyer) {
            double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, lawyer.latitude, lawyer.longitude) / 1000;
            return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
                && distanceKm <= settingsProvider.settings.distanceKm
                && (lawyer.name.toLowerCase().contains(val.toLowerCase()) || lawyer.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
          changeSelectedLawyers(_lawyers.where((lawyer) {
            return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
                && (lawyer.name.toLowerCase().contains(val.toLowerCase()) || lawyer.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else {
          changeSelectedLawyers(_lawyers.where((lawyer) {
            return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
                && lawyer.governorate == _selectedGovernmentModel!.nameAr
                && (lawyer.name.toLowerCase().contains(val.toLowerCase()) || lawyer.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
      }
    }
  }

  void onClearSearch(BuildContext context, int lawyersCategoryId) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if(_selectedGovernmentModel != null) {
      if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
        changeSelectedLawyers(_lawyers.where((lawyer) {
          double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, lawyer.latitude, lawyer.longitude) / 1000;
          return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
              && distanceKm <= settingsProvider.settings.distanceKm;
        }).toList());
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
      else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
        changeSelectedLawyers(_lawyers.where((lawyer) {
          return lawyer.categoriesIds.contains(lawyersCategoryId.toString());
        }).toList());
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
      else {
        changeSelectedLawyers(_lawyers.where((lawyer) {
          return lawyer.categoriesIds.contains(lawyersCategoryId.toString())
              && lawyer.governorate == _selectedGovernmentModel!.nameAr;
        }).toList());
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
    }
  }

  // Start Pagination //
  int _numberOfItems = 0;
  int get numberOfItems => _numberOfItems;
  setNumberOfItems(int numberOfItems) => _numberOfItems = numberOfItems;
  changeNumberOfItems(int numberOfItems) {_numberOfItems = numberOfItems; notifyListeners();}

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;
  setHasMoreData(bool hasMoreData) => _hasMoreData = hasMoreData;
  changeHasMoreData(bool hasMoreData) {_hasMoreData = hasMoreData;  notifyListeners();}

  late ScrollController _scrollController;
  ScrollController get scrollController => _scrollController;
  initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
        showDataInList(isResetData: false, isRefresh: true, isScrollUp: false);
      }
    });
  }
  disposeScrollController() => _scrollController.dispose();
  _scrollUp() => _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);

  int limit = 10;

  void showDataInList({required bool isResetData, required bool isRefresh, required bool isScrollUp}) async {
    try { // Check scrollController created or not & hasClients or not
      if(_scrollController.hasClients) {
        if(isScrollUp) {_scrollUp();}
      }
    }
    catch(error) {
      debugPrint(error.toString());
    }

    if(isResetData) {
      setNumberOfItems(0);
      setHasMoreData(true);
    }

    if(_hasMoreData) {
      List list = _selectedLawyers;
      if(isRefresh) {changeNumberOfItems(_numberOfItems += (list.length - numberOfItems) >= limit ? limit : (list.length - numberOfItems));}
      if(!isRefresh) {setNumberOfItems(_numberOfItems += (list.length - numberOfItems) >= limit ? limit : (list.length - numberOfItems));}
      debugPrint('numberOfItems: $_numberOfItems');

      if(numberOfItems == list.length) {
        if(isRefresh) {changeHasMoreData(false);}
        if(!isRefresh) {setHasMoreData(false);}
      }
    }
  }
  // End Pagination //
}