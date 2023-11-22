import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/data/models/static/search_model.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {

  List<SearchModel> _searchData = [];
  List<SearchModel> get searchData => _searchData;
  setSearchData(List<SearchModel> searchData) => _searchData = searchData;

  List<SearchModel> _selectedSearchData = [];
  List<SearchModel> get selectedSearchData => _selectedSearchData;
  setSelectedSearchData(List<SearchModel> selectedSearchData) => _selectedSearchData = selectedSearchData;
  changeSelectedSearchData(List<SearchModel> selectedSearchData) {
    _selectedSearchData = selectedSearchData;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  OrderBy _orderBy = OrderBy.accountVerification;
  OrderBy get orderBy => _orderBy;
  setOrderBy(OrderBy orderBy) => _orderBy = orderBy;
  applyOrder() {
    if(_orderBy == OrderBy.accountVerification) {
      _searchData.sort((a, b) => b.isVerified ? 1 : -1);
    }
    else if(_orderBy == OrderBy.highestRated) {
      _searchData.sort((a, b) => b.rating.compareTo(a.rating));
    }
    else if(_orderBy == OrderBy.lowestRated) {
      _searchData.sort((a, b) => a.rating.compareTo(b.rating));
    }
    else if(_orderBy == OrderBy.newlyAdded) {
      _searchData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    else if(_orderBy == OrderBy.theOldest) {
      _searchData.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    // else if(_orderBy == OrderBy.fromNearestToFarthest) {
      // _searchData.sort((a, b) => b.rating.compareTo(a.rating));
    // }
    changeSelectedSearchData(_searchData);
  }

  void onChangeSearch(BuildContext context, String val) {
    if(val.isEmpty) {
      changeSelectedSearchData(_searchData);
    }
    else {
      changeSelectedSearchData(_searchData.where((element) {
        return element.name.toLowerCase().contains(val.toLowerCase())
            || element.tasks.toString().toLowerCase().contains(val.toLowerCase());
      }).toList());
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
      List list = _selectedSearchData;
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