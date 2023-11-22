import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class ToggleIsViewedUseCase extends BaseUseCase<TransactionModel, ToggleIsViewedParameters> {
  final BaseRepository _baseRepository;

  ToggleIsViewedUseCase(this._baseRepository);

  @override
  Future<Either<Failure, TransactionModel>> call(ToggleIsViewedParameters parameters) async {
    return await _baseRepository.toggleIsViewed(parameters);
  }
}

class ToggleIsViewedParameters {
  final int transactionId;

  ToggleIsViewedParameters({required this.transactionId});
}