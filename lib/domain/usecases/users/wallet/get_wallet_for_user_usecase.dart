import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetWalletForUserUseCase extends BaseUseCase<WalletModel?, GetWalletParameters> {
  final BaseRepository _baseRepository;

  GetWalletForUserUseCase(this._baseRepository);

  @override
  Future<Either<Failure, WalletModel?>> call(GetWalletParameters parameters) async {
    return await _baseRepository.getWalletForUser(parameters);
  }
}

class GetWalletParameters {
  final int userAccountId;

  GetWalletParameters({required this.userAccountId});
}