import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_reviews/get_all_lawyers_reviews_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_reviews/insert_lawyer_review_usecase.dart';
import 'package:flutter/material.dart';

class LawyersReviewsProvider with ChangeNotifier {
  final GetAllLawyersReviewsUseCase _getAllLawyersReviewsUseCase;
  final InsertLawyerReviewUseCase _insertLawyerReviewUseCase;

  LawyersReviewsProvider(this._getAllLawyersReviewsUseCase, this._insertLawyerReviewUseCase);

  Future<Either<Failure, List<LawyerReviewModel>>> getAllLawyersReviewsImpl() async {
    return await _getAllLawyersReviewsUseCase.call(const NoParameters());
  }

  Future<Either<Failure, LawyerReviewModel>> insertLawyerReviewImpl(InsertLawyerReviewParameters parameters) async {
    return await _insertLawyerReviewUseCase.call(parameters);
  }

  List<LawyerReviewModel> _lawyersReviews = [];
  List<LawyerReviewModel> get lawyersReviews => _lawyersReviews;
  setLawyersReviews(List<LawyerReviewModel> lawyersReviews) => _lawyersReviews = lawyersReviews;
  changeLawyersReviews(List<LawyerReviewModel> lawyersReviews) {
    _lawyersReviews = lawyersReviews;
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
      List list = _lawyersReviews;
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