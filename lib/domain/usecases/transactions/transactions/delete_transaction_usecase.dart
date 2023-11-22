import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class DeleteTransactionUseCase extends BaseUseCase<void, DeleteTransactionParameters> {
  final BaseRepository _baseRepository;

  DeleteTransactionUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(DeleteTransactionParameters parameters) async {
    return await _baseRepository.deleteTransaction(parameters);
  }
}

class DeleteTransactionParameters {
  final TransactionModel transactionModel;

  DeleteTransactionParameters({required this.transactionModel});
}