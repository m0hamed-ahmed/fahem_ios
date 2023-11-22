import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLawyersReviewsUseCase extends BaseUseCase<List<LawyerReviewModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLawyersReviewsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LawyerReviewModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLawyersReviews();
  }
}