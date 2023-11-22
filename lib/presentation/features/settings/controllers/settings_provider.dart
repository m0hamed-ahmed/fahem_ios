import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/settings/settings_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/settings/get_settings_usecase.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  final GetSettingsUseCase _getSettingsUseCase;

  SettingsProvider(this._getSettingsUseCase);

  Future<Either<Failure, SettingsModel>> getSettingsImpl() async {
    return await _getSettingsUseCase.call(const NoParameters());
  }

  late SettingsModel _settings;
  SettingsModel get settings => _settings;
  setSettings(SettingsModel settings) => _settings = settings;
}