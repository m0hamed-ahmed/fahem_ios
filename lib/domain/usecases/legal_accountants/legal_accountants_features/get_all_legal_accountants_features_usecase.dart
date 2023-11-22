import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_features/legal_accountant_feature_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLegalAccountantsFeaturesUseCase extends BaseUseCase<List<LegalAccountantFeatureModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLegalAccountantsFeaturesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LegalAccountantFeatureModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLegalAccountantsFeatures();
  }
}