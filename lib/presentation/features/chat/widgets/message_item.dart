import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/chat/message_model.dart';
import 'package:fahem/presentation/features/chat/controllers/chat_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatefulWidget {
  final MessageModel messageModel;
  final String senderId;
  final String? date;

  const MessageItem({super.key, required this.messageModel, required this.senderId, required this.date});

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late AppProvider appProvider;
  late ChatRoomProvider chatRoomProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    chatRoomProvider = Provider.of<ChatRoomProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.messageModel.messageMode == MessageMode.send ? Column(
      children: [
        if(widget.date != null) Container(
          margin: const EdgeInsets.only(bottom: SizeManager.s10),
          child: Text(
            widget.date!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: SizeManager.s12),
          ),
        ),

        InkWell(
          onLongPress: widget.messageModel.senderId == widget.senderId
              ? () async => await chatRoomProvider.onLongPressDeleteMessage(context, widget.senderId, widget.messageModel.messageId)
              : null,
          child: Align(
            alignment: widget.messageModel.senderId == widget.senderId ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.symmetric(vertical: SizeManager.s5, horizontal: SizeManager.s10),
              decoration: BoxDecoration(
                color: widget.messageModel.senderId == widget.senderId ? ColorsManager.primaryColor : ColorsManager.grey300,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(SizeManager.s10),
                  topEnd: const Radius.circular(SizeManager.s10),
                  bottomEnd: Radius.circular(widget.messageModel.senderId == widget.senderId ? SizeManager.s0 : SizeManager.s10),
                  bottomStart: Radius.circular(widget.messageModel.senderId == widget.senderId ? SizeManager.s10 : SizeManager.s0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.messageModel.text,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: widget.messageModel.senderId == widget.senderId ? ColorsManager.white : ColorsManager.black),
                  ),
                  const SizedBox(height: SizeManager.s5),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      Methods.formatDate(context: context, milliseconds: int.parse(widget.messageModel.timeStamp), isTimeAndAOnly: true),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: widget.messageModel.senderId == widget.senderId ? ColorsManager.white : ColorsManager.black, fontSize: SizeManager.s12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ) : InkWell(
      onLongPress: widget.messageModel.senderId == widget.senderId
          ? () async => await chatRoomProvider.onLongPressRetrieveMessage(context, widget.senderId, widget.messageModel.messageId)
          : null,
      child: Align(
        alignment: widget.messageModel.senderId == widget.senderId ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
        child: Container(
          width: SizeManager.s200,
          padding: const EdgeInsets.symmetric(vertical: SizeManager.s5, horizontal: SizeManager.s10),
          decoration: BoxDecoration(
            color: ColorsManager.black38,
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(SizeManager.s10),
              topEnd: const Radius.circular(SizeManager.s10),
              bottomEnd: Radius.circular(widget.messageModel.senderId == widget.senderId ? SizeManager.s0 : SizeManager.s10),
              bottomStart: Radius.circular(widget.messageModel.senderId == widget.senderId ? SizeManager.s10 : SizeManager.s0),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.delete, color: ColorsManager.white, size: SizeManager.s18),
              const SizedBox(width: SizeManager.s5),
              Flexible(
                child: Text(
                  Methods.getText(StringsManager.thisMessageHasBeenDeleted, appProvider.isEnglish).toCapitalized(),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}