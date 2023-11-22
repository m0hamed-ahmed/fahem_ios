import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetTransactionsForUserUseCase extends BaseUseCase<List<TransactionModel>, GetTransactionsForUserParameters> {
  final BaseRepository _baseRepository;

  GetTransactionsForUserUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<TransactionModel>>> call(GetTransactionsForUserParameters parameters) async {
    return await _baseRepository.getTransactionsForUser(parameters);
  }
}

class GetTransactionsForUserParameters {
  final int userAccountId;

  GetTransactionsForUserParameters({required this.userAccountId});
}