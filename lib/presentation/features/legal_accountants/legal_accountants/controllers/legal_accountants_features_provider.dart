import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_features/legal_accountant_feature_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_features/get_all_legal_accountants_features_usecase.dart';
import 'package:flutter/material.dart';

class LegalAccountantsFeaturesProvider with ChangeNotifier {
  final GetAllLegalAccountantsFeaturesUseCase _getAllLegalAccountantsFeaturesUseCase;

  LegalAccountantsFeaturesProvider(this._getAllLegalAccountantsFeaturesUseCase);

  Future<Either<Failure, List<LegalAccountantFeatureModel>>> getAllLegalAccountantsFeaturesImpl() async {
    return await _getAllLegalAccountantsFeaturesUseCase.call(const NoParameters());
  }

  List<LegalAccountantFeatureModel> _legalAccountantsFeatures = [];
  List<LegalAccountantFeatureModel> get legalAccountantsFeatures => _legalAccountantsFeatures;
  setLegalAccountantsFeatures(List<LegalAccountantFeatureModel> legalAccountantsFeatures) => _legalAccountantsFeatures = legalAccountantsFeatures;
}