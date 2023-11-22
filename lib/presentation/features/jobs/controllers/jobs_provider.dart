import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/jobs/jobs/get_available_jobs_usecase.dart';
import 'package:flutter/material.dart';

class JobsProvider with ChangeNotifier {
  final GetAvailableJobsUseCase _getAvailableJobsUseCase;

  JobsProvider(this._getAvailableJobsUseCase);

  Future<Either<Failure, List<JobModel>>> getAvailableJobsImpl() async {
    return await _getAvailableJobsUseCase.call(const NoParameters());
  }

  List<JobModel> _jobs = [];
  List<JobModel> get jobs => _jobs;
  setJobs(List<JobModel> jobs) => _jobs = jobs;

  List<JobModel> _selectedJobs = [];
  List<JobModel> get selectedJobs => _selectedJobs;
  setSelectedJobs(List<JobModel> selectedJobs) => _selectedJobs = selectedJobs;
  changeSelectedJobs(List<JobModel> selectedJobs) {
    _selectedJobs = selectedJobs;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void onChangeSearch(BuildContext context, String val) {
    if(val.isEmpty) {
      changeSelectedJobs(jobs);
    }
    else {
      changeSelectedJobs(jobs.where((element) => element.jobTitle.toLowerCase().contains(val.toLowerCase())).toList());
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
      List list = _selectedJobs;
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