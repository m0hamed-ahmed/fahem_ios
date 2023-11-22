import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/models/chat/suggested_message_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/chat/controllers/chat_room_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestedMessagesItem extends StatefulWidget {
  final SuggestedMessageModel suggestedMessageModel;
  final String clientId;

  const SuggestedMessagesItem({super.key,required this.suggestedMessageModel, required this.clientId});

  @override
  State<SuggestedMessagesItem> createState() => _SuggestedMessagesItemState();
}

class _SuggestedMessagesItemState extends State<SuggestedMessagesItem> {
  late AppProvider appProvider;
  late ChatRoomProvider chatRoomProvider;
  late UserAccountModel userAccountModel;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    chatRoomProvider = Provider.of<ChatRoomProvider>(context, listen: false);
    userAccountModel = Provider.of<UserAccountProvider>(context, listen: false).userAccount!;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await chatRoomProvider.onPressedAddChatAndMessage(context: context, senderId: widget.clientId, message: widget.suggestedMessageModel.message, userAccountModel: userAccountModel).then((value) {
            chatRoomProvider.onPressedAddChatAndMessage(context: context, senderId: FirebaseConstants.senderId, message: widget.suggestedMessageModel.answer, userAccountModel: userAccountModel);
          });
        },
        borderRadius: BorderRadius.circular(SizeManager.s10),
        child: Ink(
          padding: const EdgeInsets.all(SizeManager.s5),
          decoration: BoxDecoration(
            color: ColorsManager.white,
            border: Border.all(color: ColorsManager.grey300),
            borderRadius: BorderRadius.circular(SizeManager.s10),
          ),
          child: Center(
            child: Text(
              widget.suggestedMessageModel.message,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.black),
            ),
          ),
        ),
      ),
    );
  }
}
