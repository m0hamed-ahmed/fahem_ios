import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class ToggleIsDoneInstantConsultationUseCase extends BaseUseCase<TransactionModel, ToggleIsDoneInstantConsultationParameters> {
  final BaseRepository _baseRepository;

  ToggleIsDoneInstantConsultationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, TransactionModel>> call(ToggleIsDoneInstantConsultationParameters parameters) async {
    return await _baseRepository.toggleIsDoneInstantConsultation(parameters);
  }
}

class ToggleIsDoneInstantConsultationParameters {
  final int transactionId;
  final int? bestLawyerId;

  ToggleIsDoneInstantConsultationParameters({required this.transactionId, required this.bestLawyerId});
}