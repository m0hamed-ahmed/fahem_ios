import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/transactions/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllInstantConsultationsCommentsUseCase extends BaseUseCase<List<InstantConsultationCommentModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllInstantConsultationsCommentsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<InstantConsultationCommentModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllInstantConsultationsComments();
  }
}