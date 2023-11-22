import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class UploadFileUseCase extends BaseUseCase<String, UploadFileParameters> {
  final BaseRepository _baseRepository;

  UploadFileUseCase(this._baseRepository);

  @override
  Future<Either<Failure, String>> call(UploadFileParameters parameters) async {
    return await _baseRepository.uploadFile(parameters);
  }
}

class UploadFileParameters {
  final File file;
  final String directory;

  UploadFileParameters({required this.file, required this.directory});
}