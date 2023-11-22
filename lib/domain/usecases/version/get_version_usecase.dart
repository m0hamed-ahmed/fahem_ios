import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/version/version_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetVersionUseCase extends BaseUseCase<VersionModel, NoParameters> {
  final BaseRepository _baseRepository;

  GetVersionUseCase(this._baseRepository);

  @override
  Future<Either<Failure, VersionModel>> call(NoParameters parameters) async {
    return await _baseRepository.getVersion();
  }
}