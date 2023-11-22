import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAvailableJobsUseCase extends BaseUseCase<List<JobModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAvailableJobsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<JobModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAvailableJobs();
  }
}