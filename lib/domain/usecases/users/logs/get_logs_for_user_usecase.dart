import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetLogsForUserUseCase extends BaseUseCase<List<LogModel>, GetLogsForUserParameters> {
  final BaseRepository _baseRepository;

  GetLogsForUserUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LogModel>>> call(GetLogsForUserParameters parameters) async {
    return await _baseRepository.getLogsForUser(parameters);
  }
}

class GetLogsForUserParameters {
  final int userAccountId;

  GetLogsForUserParameters({required this.userAccountId});
}