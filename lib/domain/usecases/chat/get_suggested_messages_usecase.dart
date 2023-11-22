import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/chat/suggested_message_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetSuggestedMessagesUseCase extends BaseUseCase<List<SuggestedMessageModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetSuggestedMessagesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<SuggestedMessageModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getSuggestedMessages();
  }
}