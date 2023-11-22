import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_categories/get_all_public_relations_categories_usecase.dart';
import 'package:flutter/material.dart';

class PublicRelationsCategoriesProvider with ChangeNotifier {
  final GetAllPublicRelationsCategoriesUseCase _getAllPublicRelationsCategoriesUseCase;

  PublicRelationsCategoriesProvider(this._getAllPublicRelationsCategoriesUseCase);

  Future<Either<Failure, List<PublicRelationCategoryModel>>> getAllPublicRelationsCategoriesImpl() async {
    return await _getAllPublicRelationsCategoriesUseCase.call(const NoParameters());
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<PublicRelationCategoryModel> _publicRelationsCategories = [];
  List<PublicRelationCategoryModel> get publicRelationsCategories => _publicRelationsCategories;
  setPublicRelationsCategories(List<PublicRelationCategoryModel> publicRelationsCategories) => _publicRelationsCategories = publicRelationsCategories;

  PublicRelationCategoryModel getPublicRelationCategoryWithId(int publicRelationCategoryId) {
    return _publicRelationsCategories.firstWhere((element) => element.publicRelationCategoryId == publicRelationCategoryId);
  }
}