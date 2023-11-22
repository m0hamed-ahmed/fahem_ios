import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class IsUserHaveWalletUseCase extends BaseUseCase<bool, IsUserHaveWalletParameters> {
  final BaseRepository _baseRepository;

  IsUserHaveWalletUseCase(this._baseRepository);

  @override
  Future<Either<Failure, bool>> call(IsUserHaveWalletParameters parameters) async {
    return await _baseRepository.isUserHaveWallet(parameters);
  }
}

class IsUserHaveWalletParameters {
  final int userAccountId;

  IsUserHaveWalletParameters({required this.userAccountId});
}