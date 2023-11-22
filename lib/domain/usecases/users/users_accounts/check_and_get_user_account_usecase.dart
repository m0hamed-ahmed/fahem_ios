import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class CheckAndGetUserAccountUseCase extends BaseUseCase<UserAccountModel?, CheckAndGetUserAccountParameters> {
  final BaseRepository _baseRepository;

  CheckAndGetUserAccountUseCase(this._baseRepository);

  @override
  Future<Either<Failure, UserAccountModel?>> call(CheckAndGetUserAccountParameters parameters) async {
    return await _baseRepository.checkAndGetUserAccount(parameters);
  }
}

class CheckAndGetUserAccountParameters {
  final String phoneNumber;

  CheckAndGetUserAccountParameters({required this.phoneNumber});
}