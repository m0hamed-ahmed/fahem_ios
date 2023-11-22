import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrademarkRegistrationAndIntellectualProtectionProvider with ChangeNotifier {

  late double myCurrentPositionLatitude;
  late double myCurrentPositionLongitude;

  late GovernmentModel _selectedGovernmentModel;
  GovernmentModel get selectedGovernmentModel => _selectedGovernmentModel;
  setSelectedGovernmentModel(GovernmentModel selectedGovernmentModel) => _selectedGovernmentModel = selectedGovernmentModel;
  changeSelectedGovernmentModel(GovernmentModel selectedGovernmentModel) {_selectedGovernmentModel = selectedGovernmentModel; notifyListeners();}

  List<LawyerModel> _trademarkRegistrationAndIntellectualProtection = [];
  List<LawyerModel> get trademarkRegistrationAndIntellectualProtection => _trademarkRegistrationAndIntellectualProtection;
  setTrademarkRegistrationAndIntellectualProtection(List<LawyerModel> trademarkRegistrationAndIntellectualProtection) => _trademarkRegistrationAndIntellectualProtection = trademarkRegistrationAndIntellectualProtection;
  changeTrademarkRegistrationAndIntellectualProtection(List<LawyerModel> trademarkRegistrationAndIntellectualProtection) {
    _trademarkRegistrationAndIntellectualProtection = trademarkRegistrationAndIntellectualProtection;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  late GoogleMapController googleMapController;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  setMakers(Set<Marker> markers) => _markers = markers;
  changeMakers(Set<Marker> markers) {_markers = markers; notifyListeners();}

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
      List list = _trademarkRegistrationAndIntellectualProtection;
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