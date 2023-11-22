import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllPublicRelationsReviewsUseCase extends BaseUseCase<List<PublicRelationReviewModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllPublicRelationsReviewsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PublicRelationReviewModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllPublicRelationsReviews();
  }
}