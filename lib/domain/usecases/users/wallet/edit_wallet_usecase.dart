import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class EditWalletUseCase extends BaseUseCase<WalletModel, EditWalletParameters> {
  final BaseRepository _baseRepository;

  EditWalletUseCase(this._baseRepository);

  @override
  Future<Either<Failure, WalletModel>> call(EditWalletParameters parameters) async {
    return await _baseRepository.editWallet(parameters);
  }
}

class EditWalletParameters {
  final WalletModel walletModel;

  EditWalletParameters({required this.walletModel});
}