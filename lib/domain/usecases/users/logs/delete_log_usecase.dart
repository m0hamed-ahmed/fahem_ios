import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class DeleteLogUseCase extends BaseUseCase<void, DeleteLogParameters> {
  final BaseRepository _baseRepository;

  DeleteLogUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(DeleteLogParameters parameters) async {
    return await _baseRepository.deleteLog(parameters);
  }
}

class DeleteLogParameters {
  final LogModel logModel;

  DeleteLogParameters({required this.logModel});
}