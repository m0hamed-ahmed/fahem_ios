import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlists/get_all_playlists_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistsProvider with ChangeNotifier {
  final GetAllPlaylistsUseCase _getAllPlaylistsUseCase;

  PlaylistsProvider(this._getAllPlaylistsUseCase);

  Future<Either<Failure, List<PlaylistModel>>> getAllPlaylistsImpl() async {
    return await _getAllPlaylistsUseCase.call(const NoParameters());
  }

  List<PlaylistModel> _playlists = [];
  List<PlaylistModel> get playlists => _playlists;
  setPlaylists(List<PlaylistModel> playlists) => _playlists = playlists;

  List<PlaylistModel> _selectedPlaylists = [];
  List<PlaylistModel> get selectedPlaylists => _selectedPlaylists;
  setSelectedPlaylists(List<PlaylistModel> selectedPlaylists) => _selectedPlaylists = selectedPlaylists;
  changeSelectedPlaylists(List<PlaylistModel> selectedPlaylists) {
    _selectedPlaylists = selectedPlaylists;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void onChangeSearch(BuildContext context, String val) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if(val.isEmpty) {
      changeSelectedPlaylists(playlists);
    }
    else {
      if(appProvider.isEnglish) {
        changeSelectedPlaylists(playlists.where((element) => element.playlistNameEn.toLowerCase().contains(val.toLowerCase())).toList());
      }
      else {
        changeSelectedPlaylists(playlists.where((element) => element.playlistNameAr.toLowerCase().contains(val.toLowerCase())).toList());
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
      List list = _selectedPlaylists;
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