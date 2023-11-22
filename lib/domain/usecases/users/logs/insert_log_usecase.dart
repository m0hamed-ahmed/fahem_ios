import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertLogUseCase extends BaseUseCase<LogModel, InsertLogParameters> {
  final BaseRepository _baseRepository;

  InsertLogUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LogModel>> call(InsertLogParameters parameters) async {
    return await _baseRepository.insertLog(parameters);
  }
}

class InsertLogParameters {
  final LogModel logModel;

  InsertLogParameters({required this.logModel});
}