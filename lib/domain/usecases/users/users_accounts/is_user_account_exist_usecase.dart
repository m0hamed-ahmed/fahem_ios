import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class IsUserAccountExistUseCase extends BaseUseCase<bool, IsUserAccountExistParameters> {
  final BaseRepository _baseRepository;

  IsUserAccountExistUseCase(this._baseRepository);

  @override
  Future<Either<Failure, bool>> call(IsUserAccountExistParameters parameters) async {
    return await _baseRepository.isUserAccountExist(parameters);
  }
}

class IsUserAccountExistParameters {
  final int userAccountId;

  IsUserAccountExistParameters({required this.userAccountId});
}