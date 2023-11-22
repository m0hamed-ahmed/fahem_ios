import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/chat/suggested_message_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/chat/get_suggested_messages_usecase.dart';
import 'package:flutter/material.dart';

class SuggestedMessagesProvider with ChangeNotifier {
  final GetSuggestedMessagesUseCase _getSuggestedMessagesUseCase;

  SuggestedMessagesProvider(this._getSuggestedMessagesUseCase);

  Future<Either<Failure, List<SuggestedMessageModel>>> getSuggestedMessagesImpl() async {
    return await _getSuggestedMessagesUseCase.call(const NoParameters());
  }

  List<SuggestedMessageModel> _suggestedMessages = [];
  List<SuggestedMessageModel> get suggestedMessages => _suggestedMessages;
  setSuggestedMessages(List<SuggestedMessageModel> suggestedMessages) => _suggestedMessages = suggestedMessages;
}