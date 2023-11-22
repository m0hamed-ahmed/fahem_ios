import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants/get_all_legal_accountants_usecase.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LegalAccountantsProvider with ChangeNotifier {
  final GetAllLegalAccountantsUseCase _getAllLegalAccountantsUseCase;

  LegalAccountantsProvider(this._getAllLegalAccountantsUseCase);

  Future<Either<Failure, List<LegalAccountantModel>>> getAllLegalAccountantsImpl() async {
    return await _getAllLegalAccountantsUseCase.call(const NoParameters());
  }

  List<LegalAccountantModel> _legalAccountants = [];
  List<LegalAccountantModel> get legalAccountants => _legalAccountants;
  setLegalAccountants(List<LegalAccountantModel> legalAccountants) => _legalAccountants = legalAccountants;

  List<LegalAccountantModel> _selectedLegalAccountants = [];
  List<LegalAccountantModel> get selectedLegalAccountants => _selectedLegalAccountants;
  changeSelectedLegalAccountants(List<LegalAccountantModel> selectedLegalAccountants) {
    _selectedLegalAccountants = selectedLegalAccountants;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  GovernmentModel? _selectedGovernmentModel;
  GovernmentModel? get selectedGovernmentModel => _selectedGovernmentModel;
  setSelectedGovernmentModel(GovernmentModel? selectedGovernmentModel) => _selectedGovernmentModel = selectedGovernmentModel;
  changeSelectedGovernmentModel(GovernmentModel? selectedGovernmentModel) {_selectedGovernmentModel = selectedGovernmentModel; notifyListeners();}

  LegalAccountantModel? getLegalAccountantWithId(int legalAccountantId) {
    int index = _legalAccountants.indexWhere((element) => element.legalAccountantId == legalAccountantId);
    if(index == -1) {
      return null;
    }
    else {
      return _legalAccountants[index];
    }
  }

  void onChangeSearch(BuildContext context, String val) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if(_selectedGovernmentModel != null) {
      if(val.isEmpty) {
        if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
          changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
            double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, legalAccountants.latitude, legalAccountants.longitude) / 1000;
            return distanceKm <= settingsProvider.settings.distanceKm;
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
          changeSelectedLegalAccountants(_legalAccountants);
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else {
          changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
            return legalAccountants.governorate == _selectedGovernmentModel!.nameAr;
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
      }
      else {
        if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
          changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
            double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, legalAccountants.latitude, legalAccountants.longitude) / 1000;
            return distanceKm <= settingsProvider.settings.distanceKm
                && (legalAccountants.name.toLowerCase().contains(val.toLowerCase()) || legalAccountants.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
          changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
            return (legalAccountants.name.toLowerCase().contains(val.toLowerCase()) || legalAccountants.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else {
          changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
            return legalAccountants.governorate == _selectedGovernmentModel!.nameAr
                && (legalAccountants.name.toLowerCase().contains(val.toLowerCase()) || legalAccountants.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
      }
    }
  }

  void onClearSearch(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if(_selectedGovernmentModel != null) {
      if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
        changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
          double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, legalAccountants.latitude, legalAccountants.longitude) / 1000;
          return distanceKm <= settingsProvider.settings.distanceKm;
        }).toList());
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
      else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
        changeSelectedLegalAccountants(_legalAccountants);
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
      else {
        changeSelectedLegalAccountants(_legalAccountants.where((legalAccountants) {
          return legalAccountants.governorate == _selectedGovernmentModel!.nameAr;
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
      List list = _selectedLegalAccountants;
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