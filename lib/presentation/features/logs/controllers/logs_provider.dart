import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/domain/usecases/users/logs/delete_log_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/get_logs_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/insert_log_usecase.dart';
import 'package:flutter/material.dart';

class LogsProvider with ChangeNotifier {
  final GetLogsForUserUseCase _getLogsForUserUseCase;
  final InsertLogUseCase _insertLogUseCase;
  final DeleteLogUseCase _deleteLogUseCase;

  LogsProvider(
    this._getLogsForUserUseCase,
    this._insertLogUseCase,
    this._deleteLogUseCase,
  );

  Future<Either<Failure, List<LogModel>>> getLogsForUserImpl(GetLogsForUserParameters parameters) async {
    return await _getLogsForUserUseCase.call(parameters);
  }

  Future<Either<Failure, LogModel>> insertLogImpl(InsertLogParameters parameters) async {
    return await _insertLogUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deleteLogImpl(DeleteLogParameters parameters) async {
    return await _deleteLogUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<LogModel> _logs = [];
  List<LogModel> get logs => _logs;
  setLogs(List<LogModel> logs) => _logs = logs;
  changeLogs(List<LogModel> logs) {
    _logs = logs;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }
  
  void addLog(LogModel logModel) {
    _logs.insert(0, logModel);
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
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

  int limit = 20;

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
      List list = _logs;
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