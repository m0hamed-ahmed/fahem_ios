import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations_features/public_relation_feature_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllPublicRelationsFeaturesUseCase extends BaseUseCase<List<PublicRelationFeatureModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllPublicRelationsFeaturesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PublicRelationFeatureModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllPublicRelationsFeatures();
  }
}