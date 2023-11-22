import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertUserAccountUseCase extends BaseUseCase<UserAccountModel, InsertUserAccountParameters> {
  final BaseRepository _baseRepository;

  InsertUserAccountUseCase(this._baseRepository);

  @override
  Future<Either<Failure, UserAccountModel>> call(InsertUserAccountParameters parameters) async {
    return await _baseRepository.insertUserAccount(parameters);
  }
}

class InsertUserAccountParameters {
  final UserAccountModel userAccountModel;

  InsertUserAccountParameters({required this.userAccountModel});
}