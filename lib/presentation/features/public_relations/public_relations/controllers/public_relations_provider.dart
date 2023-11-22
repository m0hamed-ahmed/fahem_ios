import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/get_all_public_relations_usecase.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PublicRelationsProvider with ChangeNotifier {
  final GetAllPublicRelationsUseCase _getAllPublicRelationsUseCase;

  PublicRelationsProvider(this._getAllPublicRelationsUseCase);

  Future<Either<Failure, List<PublicRelationModel>>> getAllPublicRelationsImpl() async {
    return await _getAllPublicRelationsUseCase.call(const NoParameters());
  }

  List<PublicRelationModel> _publicRelations = [];
  List<PublicRelationModel> get publicRelations => _publicRelations;
  setPublicRelations(List<PublicRelationModel> publicRelations) => _publicRelations = publicRelations;

  List<PublicRelationModel> _selectedPublicRelations = [];
  List<PublicRelationModel> get selectedPublicRelations => _selectedPublicRelations;
  changeSelectedPublicRelations(List<PublicRelationModel> selectedPublicRelations) {
    _selectedPublicRelations = selectedPublicRelations;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  GovernmentModel? _selectedGovernmentModel;
  GovernmentModel? get selectedGovernmentModel => _selectedGovernmentModel;
  setSelectedGovernmentModel(GovernmentModel? selectedGovernmentModel) => _selectedGovernmentModel = selectedGovernmentModel;
  changeSelectedGovernmentModel(GovernmentModel? selectedGovernmentModel) {_selectedGovernmentModel = selectedGovernmentModel; notifyListeners();}

  PublicRelationModel? getPublicRelationWithId(int publicRelationId) {
    int index = _publicRelations.indexWhere((element) => element.publicRelationId == publicRelationId);
    if(index == -1) {
      return null;
    }
    else {
      return _publicRelations[index];
    }
  }

  void onChangeSearch(BuildContext context, String val, int publicRelationCategoryId) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if(_selectedGovernmentModel != null) {
      if(val.isEmpty) {
        if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
          changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
            double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, publicRelations.latitude, publicRelations.longitude) / 1000;
            return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
                && distanceKm <= settingsProvider.settings.distanceKm;
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
          changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
            return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString());
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else {
          changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
            return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
                && publicRelations.governorate == _selectedGovernmentModel!.nameAr;
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
      }
      else {
        if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
          changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
            double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, publicRelations.latitude, publicRelations.longitude) / 1000;
            return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
                && distanceKm <= settingsProvider.settings.distanceKm
                && (publicRelations.name.toLowerCase().contains(val.toLowerCase()) || publicRelations.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
          changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
            return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
                && (publicRelations.name.toLowerCase().contains(val.toLowerCase()) || publicRelations.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
        else {
          changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
            return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
                && publicRelations.governorate == _selectedGovernmentModel!.nameAr
                && (publicRelations.name.toLowerCase().contains(val.toLowerCase()) || publicRelations.tasks.toString().toLowerCase().contains(val.toLowerCase()));
          }).toList());
          changeSelectedGovernmentModel(_selectedGovernmentModel);
        }
      }
    }
  }

  void onClearSearch(BuildContext context, int publicRelationCategoryId) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if(_selectedGovernmentModel != null) {
      if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.currentLocation) {
        changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
          double distanceKm = Geolocator.distanceBetween(_selectedGovernmentModel!.latitude, _selectedGovernmentModel!.longitude, publicRelations.latitude, publicRelations.longitude) / 1000;
          return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
              && distanceKm <= settingsProvider.settings.distanceKm;
        }).toList());
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
      else if(_selectedGovernmentModel!.governoratesMode == GovernoratesMode.allGovernorates) {
        changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
          return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString());
        }).toList());
        changeSelectedGovernmentModel(_selectedGovernmentModel);
      }
      else {
        changeSelectedPublicRelations(_publicRelations.where((publicRelations) {
          return publicRelations.categoriesIds.contains(publicRelationCategoryId.toString())
              && publicRelations.governorate == _selectedGovernmentModel!.nameAr;
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
      List list = _selectedPublicRelations;
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