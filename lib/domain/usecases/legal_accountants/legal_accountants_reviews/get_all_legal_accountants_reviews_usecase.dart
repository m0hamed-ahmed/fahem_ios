import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLegalAccountantsReviewsUseCase extends BaseUseCase<List<LegalAccountantReviewModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLegalAccountantsReviewsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LegalAccountantReviewModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLegalAccountantsReviews();
  }
}