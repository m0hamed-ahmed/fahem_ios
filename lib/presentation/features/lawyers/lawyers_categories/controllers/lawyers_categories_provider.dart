import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_categories/lawyer_category_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_categories/get_all_lawyers_categories_usecase.dart';
import 'package:flutter/material.dart';

class LawyersCategoriesProvider with ChangeNotifier {
  final GetAllLawyersCategoriesUseCase _getAllLawyersCategoriesUseCase;

  LawyersCategoriesProvider(this._getAllLawyersCategoriesUseCase);

  Future<Either<Failure, List<LawyerCategoryModel>>> getAllLawyersCategoriesImpl() async {
    return await _getAllLawyersCategoriesUseCase.call(const NoParameters());
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<LawyerCategoryModel> _lawyersCategories = [];
  List<LawyerCategoryModel> get lawyersCategories => _lawyersCategories;
  setLawyersCategories(List<LawyerCategoryModel> lawyersCategories) => _lawyersCategories = lawyersCategories;

  LawyerCategoryModel getLawyerCategoryWithId(int lawyerCategoryId) {
    return _lawyersCategories.firstWhere((element) => element.lawyerCategoryId == lawyerCategoryId);
  }
}