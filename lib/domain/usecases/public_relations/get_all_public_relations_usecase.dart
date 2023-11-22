import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllPublicRelationsUseCase extends BaseUseCase<List<PublicRelationModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllPublicRelationsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PublicRelationModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllPublicRelations();
  }
}