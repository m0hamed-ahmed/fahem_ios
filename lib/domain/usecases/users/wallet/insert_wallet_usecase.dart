import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertWalletUseCase extends BaseUseCase<WalletModel, InsertWalletParameters> {
  final BaseRepository _baseRepository;

  InsertWalletUseCase(this._baseRepository);

  @override
  Future<Either<Failure, WalletModel>> call(InsertWalletParameters parameters) async {
    return await _baseRepository.insertWallet(parameters);
  }
}

class InsertWalletParameters {
  final WalletModel walletModel;

  InsertWalletParameters({required this.walletModel});
}