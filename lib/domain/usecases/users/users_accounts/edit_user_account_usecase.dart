import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class EditUserAccountUseCase extends BaseUseCase<UserAccountModel, EditUserAccountParameters> {
  final BaseRepository _baseRepository;

  EditUserAccountUseCase(this._baseRepository);

  @override
  Future<Either<Failure, UserAccountModel>> call(EditUserAccountParameters parameters) async {
    return await _baseRepository.editUserAccount(parameters);
  }
}

class EditUserAccountParameters {
  final UserAccountModel userAccountModel;

  EditUserAccountParameters({required this.userAccountModel});
}