import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_reviews/get_all_legal_accountants_reviews_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_reviews/insert_legal_accountant_review_usecase.dart';
import 'package:flutter/material.dart';

class LegalAccountantsReviewsProvider with ChangeNotifier {
  final GetAllLegalAccountantsReviewsUseCase _getAllLegalAccountantsReviewsUseCase;
  final InsertLegalAccountantReviewUseCase _insertLegalAccountantReviewUseCase;

  LegalAccountantsReviewsProvider(this._getAllLegalAccountantsReviewsUseCase, this._insertLegalAccountantReviewUseCase);

  Future<Either<Failure, List<LegalAccountantReviewModel>>> getAllLegalAccountantsReviewsImpl() async {
    return await _getAllLegalAccountantsReviewsUseCase.call(const NoParameters());
  }

  Future<Either<Failure, LegalAccountantReviewModel>> insertLegalAccountantReviewImpl(InsertLegalAccountantReviewParameters parameters) async {
    return await _insertLegalAccountantReviewUseCase.call(parameters);
  }

  List<LegalAccountantReviewModel> _legalAccountantsReviews = [];
  List<LegalAccountantReviewModel> get legalAccountantsReviews => _legalAccountantsReviews;
  setLegalAccountantsReviews(List<LegalAccountantReviewModel> legalAccountantsReviews) => _legalAccountantsReviews = legalAccountantsReviews;
  changeLegalAccountantsReviews(List<LegalAccountantReviewModel> legalAccountantsReviews) {
    _legalAccountantsReviews = legalAccountantsReviews;
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
      List list = _legalAccountantsReviews;
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