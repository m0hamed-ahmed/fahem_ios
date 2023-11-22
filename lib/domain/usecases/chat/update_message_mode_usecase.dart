import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class UpdateMessageModeUseCase extends BaseUseCase<void, UpdateMessageModeParameters> {
  final BaseRepository _baseRepository;

  UpdateMessageModeUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(UpdateMessageModeParameters parameters) async {
    return await _baseRepository.updateMessageMode(parameters);
  }
}

class UpdateMessageModeParameters {
  final String senderId;
  final String messageId;
  final MessageMode messageMode;

  UpdateMessageModeParameters(this.senderId, this.messageId, this.messageMode);
}