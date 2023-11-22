import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/jobs/employment_applications/employment_application_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertEmploymentApplicationUseCase extends BaseUseCase<EmploymentApplicationModel, InsertEmploymentApplicationParameters> {
  final BaseRepository _baseRepository;

  InsertEmploymentApplicationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, EmploymentApplicationModel>> call(InsertEmploymentApplicationParameters parameters) async {
    return await _baseRepository.insertEmploymentApplication(parameters);
  }
}

class InsertEmploymentApplicationParameters {
  final EmploymentApplicationModel employmentApplicationModel;

  InsertEmploymentApplicationParameters({required this.employmentApplicationModel});
}