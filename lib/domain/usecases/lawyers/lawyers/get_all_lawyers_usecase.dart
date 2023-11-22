import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLawyersUseCase extends BaseUseCase<List<LawyerModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLawyersUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LawyerModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLawyers();
  }
}