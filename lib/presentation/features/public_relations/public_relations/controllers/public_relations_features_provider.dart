import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations_features/public_relation_feature_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_features/get_all_public_relations_features_usecase.dart';
import 'package:flutter/material.dart';

class PublicRelationsFeaturesProvider with ChangeNotifier {
  final GetAllPublicRelationsFeaturesUseCase _getAllPublicRelationsFeaturesUseCase;

  PublicRelationsFeaturesProvider(this._getAllPublicRelationsFeaturesUseCase);

  Future<Either<Failure, List<PublicRelationFeatureModel>>> getAllPublicRelationsFeaturesImpl() async {
    return await _getAllPublicRelationsFeaturesUseCase.call(const NoParameters());
  }

  List<PublicRelationFeatureModel> _publicRelationsFeatures = [];
  List<PublicRelationFeatureModel> get publicRelationsFeatures => _publicRelationsFeatures;
  setPublicRelationsFeatures(List<PublicRelationFeatureModel> publicRelationsFeatures) => _publicRelationsFeatures = publicRelationsFeatures;
}