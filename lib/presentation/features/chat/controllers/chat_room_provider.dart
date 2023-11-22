import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/chat/chat_model.dart';
import 'package:fahem/data/models/chat/message_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/domain/usecases/chat/add_chat_usecase.dart';
import 'package:fahem/domain/usecases/chat/add_message_usecase.dart';
import 'package:fahem/domain/usecases/chat/update_message_mode_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomProvider with ChangeNotifier {
  final AddChatUseCase _addChatUseCase;
  final AddMessageUseCase _addMessageUseCase;
  final UpdateMessageModeUseCase _updateMessageModeUseCase;

  ChatRoomProvider(this._addChatUseCase, this._addMessageUseCase, this._updateMessageModeUseCase);

  Future<Either<Failure, void>> addChatImpl(AddChatParameters parameters) async {
    return await _addChatUseCase.call(parameters);
  }

  Future<Either<Failure, void>> addMessageImpl(AddMessageParameters parameters) async {
    return await _addMessageUseCase.call(parameters);
  }

  Future<Either<Failure, void>> updateMessageModeImpl(UpdateMessageModeParameters parameters) async {
    return await _updateMessageModeUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessages({required String userAccountId}) {
    return FirebaseFirestore.instance
        .collection(FirebaseConstants.chatsCollection)
        .doc(userAccountId)
        .collection(FirebaseConstants.messagesSubCollection)
        .orderBy(FirebaseConstants.timeStampField, descending: false)
        .snapshots();
  }

  Future<void> onPressedAddChatAndMessage({required BuildContext context, required String senderId, required String message, required UserAccountModel userAccountModel, bool isPushNotification = false}) async {
    String name = '${userAccountModel.firstName} ${userAccountModel.familyName}';
    ChatModel chatModel = ChatModel(
      chatId: userAccountModel.userAccountId.toString(),
      name: name,
      lastMessage: message,
      timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    MessageModel messageModel = MessageModel(
      messageId: Methods.getRandomId(),
      chatId: userAccountModel.userAccountId.toString(),
      senderId: senderId,
      text: message,
      messageMode: MessageMode.send,
      timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // Add Chat
    AddChatParameters addChatParameters = AddChatParameters(
      chatModel: chatModel,
    );
    Either<Failure, void> response1 = await addChatImpl(addChatParameters);
    response1.fold((failure) async  {
      Dialogs.failureOccurred(context, failure);
    }, (_) async  {
      // Add Message
      AddMessageParameters parameters = AddMessageParameters(
        messageModel: messageModel,
      );
      Either<Failure, void> response2 = await addMessageImpl(parameters);
      response2.fold((failure) async  {
        Dialogs.failureOccurred(context, failure);
      }, (_) async {
        if(isPushNotification) {
          NotificationService.pushNotification(topic: FirebaseConstants.fahemAdminTopic, title: name, body: message);
        }
      });
    });
  }

  Future<void> onLongPressDeleteMessage(BuildContext context, String senderId, String messageId) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    FocusScope.of(context).unfocus();
    await Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantDeleteMessage, appProvider.isEnglish).toCapitalized()).then((value) async {
      if(value) {
        // Update messageMode
        changeIsLoading(true);
        UpdateMessageModeParameters parameters = UpdateMessageModeParameters(senderId, messageId, MessageMode.delete);
        Either<Failure, void> response = await updateMessageModeImpl(parameters);
        response.fold((failure) async {
          changeIsLoading(false);
          Dialogs.failureOccurred(context, failure);
        }, (_) async {
          changeIsLoading(false);
        });
      }
    });
  }

  Future<void> onLongPressRetrieveMessage(BuildContext context, String senderId, String messageId) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    FocusScope.of(context).unfocus();
    await Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantRetrieveMessage, appProvider.isEnglish).toCapitalized()).then((value) async {
      if(value) {
        // Update messageMode
        changeIsLoading(true);
        UpdateMessageModeParameters parameters = UpdateMessageModeParameters(senderId, messageId, MessageMode.send);
        Either<Failure, void> response = await updateMessageModeImpl(parameters);
        response.fold((failure) async {
          changeIsLoading(false);
          Dialogs.failureOccurred(context, failure);
        }, (_) async {
          changeIsLoading(false);
        });
      }
    });
  }
}