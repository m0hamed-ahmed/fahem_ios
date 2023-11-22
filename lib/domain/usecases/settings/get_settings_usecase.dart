import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/settings/settings_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetSettingsUseCase extends BaseUseCase<SettingsModel, NoParameters> {
  final BaseRepository _baseRepository;

  GetSettingsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, SettingsModel>> call(NoParameters parameters) async {
    return await _baseRepository.getSettings();
  }
}