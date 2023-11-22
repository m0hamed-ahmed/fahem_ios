import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_features/lawyer_feature_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLawyersFeaturesUseCase extends BaseUseCase<List<LawyerFeatureModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLawyersFeaturesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LawyerFeatureModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLawyersFeatures();
  }
}