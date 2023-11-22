import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/usecases/transactions/transactions/delete_transaction_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/toggle_is_done_instant_consultation_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/get_transactions_for_user_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/insert_transaction_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/toggle_is_viewed_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsProvider with ChangeNotifier {
  final GetTransactionsForUserUseCase _getTransactionsForUserUseCase;
  final InsertTransactionUseCase _insertTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final ToggleIsDoneInstantConsultationUseCase _toggleIsDoneInstantConsultationUseCase;
  final ToggleIsViewedUseCase _toggleIsViewedUseCase;

  TransactionsProvider(
    this._insertTransactionUseCase,
    this._getTransactionsForUserUseCase,
    this._deleteTransactionUseCase,
    this._toggleIsDoneInstantConsultationUseCase,
    this._toggleIsViewedUseCase,
  );

  Future<Either<Failure, List<TransactionModel>>> getTransactionsForUserImpl(GetTransactionsForUserParameters parameters) async {
    return await _getTransactionsForUserUseCase.call(parameters);
  }

  Future<Either<Failure, TransactionModel>> insertTransactionImpl(InsertTransactionParameters parameters) async {
    return await _insertTransactionUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deleteTransactionImpl(DeleteTransactionParameters parameters) async {
    return await _deleteTransactionUseCase.call(parameters);
  }

  Future<Either<Failure, TransactionModel>> toggleIsDoneInstantConsultationImpl(ToggleIsDoneInstantConsultationParameters parameters) async {
    return await _toggleIsDoneInstantConsultationUseCase.call(parameters);
  }

  Future<Either<Failure, TransactionModel>> toggleIsViewedImpl(ToggleIsViewedParameters parameters) async {
    return await _toggleIsViewedUseCase.call(parameters);
  }

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;
  setTransactions(List<TransactionModel> transactions) => _transactions = transactions;
  changeTransactions(List<TransactionModel> transactions) {_transactions = transactions; notifyListeners();}

  List<TransactionModel> _selectedTransactions = [];
  List<TransactionModel> get selectedTransactions => _selectedTransactions;
  setSelectedTransactions(List<TransactionModel> selectedTransactions) => _selectedTransactions = selectedTransactions;

  void addTransaction(TransactionModel transactionModel) {
    _transactions.insert(0, transactionModel);
    notifyListeners();
  }
  void editTransaction(TransactionModel transactionModel) {
    int index = _transactions.indexWhere((element) => element.transactionId == transactionModel.transactionId);
    _transactions[index] = transactionModel;

    int selectedTransactionsIndex = _selectedTransactions.indexWhere((element) => element.transactionId == transactionModel.transactionId);
    if(selectedTransactionsIndex != -1) {_selectedTransactions[selectedTransactionsIndex] = transactionModel;}

    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  Future<void> toggleIsDoneInstantConsultation(BuildContext context, ToggleIsDoneInstantConsultationParameters parameters) async {
    changeIsLoading(true);

     Either<Failure, TransactionModel> response = await toggleIsDoneInstantConsultationImpl(parameters);
     response.fold((failure) {
       changeIsLoading(false);
       Dialogs.failureOccurred(context, failure);
     }, (transaction) async {
       changeIsLoading(false);
       editTransaction(transaction);
     });
  }

  Future<void> toggleIsViewed(BuildContext context, ToggleIsViewedParameters parameters) async {
    if(_transactions.firstWhere((element) => element.transactionId == parameters.transactionId).isViewed) return;

    changeIsLoading(true);

    Either<Failure, TransactionModel> response = await toggleIsViewedImpl(parameters);
    response.fold((failure) {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (transaction) async {
      changeIsLoading(false);
      editTransaction(transaction);
    });
  }

  List<String> categories = ['all', 'lawyers', 'publicRelations', 'legalAccountants', 'instantConsultations', 'secretConsultations'];
  String getCategoryName(BuildContext context, String category) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    String result = '';
    if(category == 'all') {
      result = Methods.getText(StringsManager.all, appProvider.isEnglish);
    }
    else if(category == 'lawyers') {
      result = Methods.getText(StringsManager.lawyers, appProvider.isEnglish);
    }
    else if(category == 'publicRelations') {
      result = Methods.getText(StringsManager.publicRelations, appProvider.isEnglish);
    }
    else if(category == 'legalAccountants') {
      result = Methods.getText(StringsManager.legalAccountants, appProvider.isEnglish);
    }
    else if(category == 'instantConsultations') {
      result = Methods.getText(StringsManager.instantConsultations, appProvider.isEnglish);
    }
    else if(category == 'secretConsultations') {
      result = Methods.getText(StringsManager.secretConsultations, appProvider.isEnglish);
    }
    return result;
  }
  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;
  resetSelectedCategory() => _selectedCategory = 'all';
  changeSelectedCategory(String selectedCategory) {
    if(selectedCategory != _selectedCategory) {
      _selectedCategory = selectedCategory;

      _selectedTransactions = [];
      if(selectedCategory == 'all') {
        _selectedTransactions = transactions;
      }
      else if(selectedCategory == 'lawyers') {
        _selectedTransactions = _transactions.where((element) => element.transactionType == TransactionType.showLawyerNumber
            || element.transactionType == TransactionType.appointmentBookingWithLawyer).toList();
      }
      else if(selectedCategory == 'publicRelations') {
        _selectedTransactions = _transactions.where((element) => element.transactionType == TransactionType.showPublicRelationNumber
            || element.transactionType == TransactionType.appointmentBookingWithPublicRelation).toList();
      }
      else if(selectedCategory == 'legalAccountants') {
        _selectedTransactions = _transactions.where((element) => element.transactionType == TransactionType.showLegalAccountantNumber
            || element.transactionType == TransactionType.appointmentBookingWithLegalAccountant).toList();
      }
      else if(selectedCategory == 'instantConsultations') {
        _selectedTransactions = _transactions.where((element) => element.transactionType == TransactionType.instantConsultation).toList();
      }
      else if(selectedCategory == 'secretConsultations') {
        _selectedTransactions = _transactions.where((element) => element.transactionType == TransactionType.secretConsultation).toList();
      }

      notifyListeners();
      showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    }
  }

  void resetAllData() {
    resetSelectedCategory();
  }

  Future<bool> onBackPressed(BuildContext context) async {
    resetAllData();
    return await Future.value(true);
  }

  String getKeyword(TransactionType transactionType) {
    if(transactionType == TransactionType.showLawyerNumber || transactionType == TransactionType.appointmentBookingWithLawyer) {
      return ConstantsManager.fahemBusinessLawyersKeyword;
    }
    else if(transactionType == TransactionType.showPublicRelationNumber || transactionType == TransactionType.appointmentBookingWithPublicRelation) {
      return ConstantsManager.fahemBusinessPublicRelationsKeyword;
    }
    else if(transactionType == TransactionType.showLegalAccountantNumber || transactionType == TransactionType.appointmentBookingWithLegalAccountant) {
      return ConstantsManager.fahemBusinessLegalAccountantsKeyword;
    }
    return '';
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
      List list = _selectedTransactions;
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