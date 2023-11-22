import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/packages/package_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllPackagesUseCase extends BaseUseCase<List<PackageModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllPackagesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PackageModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllPackages();
  }
}