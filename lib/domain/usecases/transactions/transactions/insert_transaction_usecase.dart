import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertTransactionUseCase extends BaseUseCase<TransactionModel, InsertTransactionParameters> {
  final BaseRepository _baseRepository;

  InsertTransactionUseCase(this._baseRepository);

  @override
  Future<Either<Failure, TransactionModel>> call(InsertTransactionParameters parameters) async {
    return await _baseRepository.insertTransaction(parameters);
  }
}

class InsertTransactionParameters {
  final TransactionModel transactionModel;

  InsertTransactionParameters({required this.transactionModel});
}