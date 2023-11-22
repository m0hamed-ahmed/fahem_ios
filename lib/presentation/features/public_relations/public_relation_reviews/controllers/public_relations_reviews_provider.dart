import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_reviews/get_all_public_relations_reviews_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_reviews/insert_public_relation_review_usecase.dart';
import 'package:flutter/material.dart';

class PublicRelationsReviewsProvider with ChangeNotifier {
  final GetAllPublicRelationsReviewsUseCase _getAllPublicRelationsReviewsUseCase;
  final InsertPublicRelationReviewUseCase _insertPublicRelationReviewUseCase;

  PublicRelationsReviewsProvider(this._getAllPublicRelationsReviewsUseCase, this._insertPublicRelationReviewUseCase);

  Future<Either<Failure, List<PublicRelationReviewModel>>> getAllPublicRelationsReviewsImpl() async {
    return await _getAllPublicRelationsReviewsUseCase.call(const NoParameters());
  }

  Future<Either<Failure, PublicRelationReviewModel>> insertPublicRelationReviewImpl(InsertPublicRelationReviewParameters parameters) async {
    return await _insertPublicRelationReviewUseCase.call(parameters);
  }

  List<PublicRelationReviewModel> _publicRelationsReviews = [];
  List<PublicRelationReviewModel> get publicRelationsReviews => _publicRelationsReviews;
  setPublicRelationsReviews(List<PublicRelationReviewModel> publicRelationsReviews) => _publicRelationsReviews = publicRelationsReviews;
  changePublicRelationsReviews(List<PublicRelationReviewModel> publicRelationsReviews) {
    _publicRelationsReviews = publicRelationsReviews;
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
      List list = _publicRelationsReviews;
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