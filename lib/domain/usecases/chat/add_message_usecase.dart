import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/chat/message_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class AddMessageUseCase extends BaseUseCase<void, AddMessageParameters> {
  final BaseRepository _baseRepository;

  AddMessageUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(AddMessageParameters parameters) async {
    return await _baseRepository.addMessage(parameters);
  }
}

class AddMessageParameters {
  final MessageModel messageModel;

  AddMessageParameters({required this.messageModel});
}