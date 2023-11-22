import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/domain/usecases/shared/upload_file_usecase.dart';
import 'package:flutter/material.dart';

class UploadFileProvider with ChangeNotifier {
  final UploadFileUseCase _uploadFileUseCase;

  UploadFileProvider(this._uploadFileUseCase);

  Future<Either<Failure, String>> uploadFileImpl(UploadFileParameters parameters) async{
    return await _uploadFileUseCase.call(parameters);
  }
}