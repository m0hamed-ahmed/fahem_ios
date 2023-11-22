import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertLawyerReviewUseCase extends BaseUseCase<LawyerReviewModel, InsertLawyerReviewParameters> {
  final BaseRepository _baseRepository;

  InsertLawyerReviewUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerReviewModel>> call(InsertLawyerReviewParameters parameters) async {
    return await _baseRepository.insertLawyerReview(parameters);
  }
}

class InsertLawyerReviewParameters {
  final LawyerReviewModel lawyerReviewModel;

  InsertLawyerReviewParameters({required this.lawyerReviewModel});
}