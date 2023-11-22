import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_features/lawyer_feature_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_features/get_all_lawyers_features_usecase.dart';
import 'package:flutter/material.dart';

class LawyersFeaturesProvider with ChangeNotifier {
  final GetAllLawyersFeaturesUseCase _getAllLawyersFeaturesUseCase;

  LawyersFeaturesProvider(this._getAllLawyersFeaturesUseCase);

  Future<Either<Failure, List<LawyerFeatureModel>>> getAllLawyersFeaturesImpl() async {
    return await _getAllLawyersFeaturesUseCase.call(const NoParameters());
  }

  List<LawyerFeatureModel> _lawyersFeatures = [];
  List<LawyerFeatureModel> get lawyersFeatures => _lawyersFeatures;
  setLawyersFeatures(List<LawyerFeatureModel> lawyersFeatures) => _lawyersFeatures = lawyersFeatures;
}