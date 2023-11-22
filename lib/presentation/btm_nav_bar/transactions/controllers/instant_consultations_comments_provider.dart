import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/transactions/instant_consultations_comments/get_all_instant_consultations_comments_usecase.dart';
import 'package:flutter/material.dart';

class InstantConsultationsCommentsProvider with ChangeNotifier {
  final GetAllInstantConsultationsCommentsUseCase _getAllInstantConsultationsCommentsUseCase;

  InstantConsultationsCommentsProvider(this._getAllInstantConsultationsCommentsUseCase);

  Future<Either<Failure, List<InstantConsultationCommentModel>>> getAllInstantConsultationsCommentsImpl() async {
    return await _getAllInstantConsultationsCommentsUseCase.call(const NoParameters());
  }

  List<InstantConsultationCommentModel> _instantConsultationsComments = [];
  List<InstantConsultationCommentModel> get instantConsultationsComments => _instantConsultationsComments;
  setInstantConsultationsComments(List<InstantConsultationCommentModel> instantConsultationsComments) => _instantConsultationsComments = instantConsultationsComments;

  List<InstantConsultationCommentModel> commentsForTransaction = [];

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
      List list = commentsForTransaction;
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