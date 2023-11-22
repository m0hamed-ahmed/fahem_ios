import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertPublicRelationReviewUseCase extends BaseUseCase<PublicRelationReviewModel, InsertPublicRelationReviewParameters> {
  final BaseRepository _baseRepository;

  InsertPublicRelationReviewUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationReviewModel>> call(InsertPublicRelationReviewParameters parameters) async {
    return await _baseRepository.insertPublicRelationReview(parameters);
  }
}

class InsertPublicRelationReviewParameters {
  final PublicRelationReviewModel publicRelationReviewModel;

  InsertPublicRelationReviewParameters({required this.publicRelationReviewModel});
}