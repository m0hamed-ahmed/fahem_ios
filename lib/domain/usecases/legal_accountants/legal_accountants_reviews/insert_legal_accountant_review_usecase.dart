import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertLegalAccountantReviewUseCase extends BaseUseCase<LegalAccountantReviewModel, InsertLegalAccountantReviewParameters> {
  final BaseRepository _baseRepository;

  InsertLegalAccountantReviewUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LegalAccountantReviewModel>> call(InsertLegalAccountantReviewParameters parameters) async {
    return await _baseRepository.insertLegalAccountantReview(parameters);
  }
}

class InsertLegalAccountantReviewParameters {
  final LegalAccountantReviewModel legalAccountantReviewModel;

  InsertLegalAccountantReviewParameters({required this.legalAccountantReviewModel});
}