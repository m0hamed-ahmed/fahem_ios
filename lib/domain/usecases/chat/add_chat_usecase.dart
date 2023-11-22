import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/chat/chat_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class AddChatUseCase extends BaseUseCase<void, AddChatParameters> {
  final BaseRepository _baseRepository;

  AddChatUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(AddChatParameters parameters) async {
    return await _baseRepository.addChat(parameters);
  }
}

class AddChatParameters {
  final ChatModel chatModel;

  AddChatParameters({required this.chatModel});
}