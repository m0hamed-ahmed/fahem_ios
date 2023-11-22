import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLegalAccountantsUseCase extends BaseUseCase<List<LegalAccountantModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLegalAccountantsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LegalAccountantModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLegalAccountants();
  }
}