import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/chat/message_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/chat/controllers/chat_room_provider.dart';
import 'package:fahem/presentation/features/chat/controllers/suggested_messages_provider.dart';
import 'package:fahem/presentation/features/chat/widgets/message_item.dart';
import 'package:fahem/presentation/features/chat/widgets/suggested_messages_item.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {

  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late AppProvider appProvider;
  late ChatRoomProvider chatRoomProvider;
  late SuggestedMessagesProvider suggestedMessagesProvider;
  late UserAccountModel userAccountModel;
  final TextEditingController textEditingControllerMessage = TextEditingController();
  List<String?> timeStampDates = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    chatRoomProvider = Provider.of<ChatRoomProvider>(context, listen: false);
    suggestedMessagesProvider = Provider.of<SuggestedMessagesProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    userAccountModel = userAccountProvider.userAccount!;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primaryColor,
          title: Text(
            Methods.getText(StringsManager.chatWithTechnicalSupport, appProvider.isEnglish).toTitleCase(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
          ),
          iconTheme: const IconThemeData(color: ColorsManager.white),
          elevation: SizeManager.s0,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: chatRoomProvider.streamMessages(userAccountId: userAccountModel.userAccountId.toString()),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: ConstantsManager.scrollToMaxChatDuration),
                  );
                }
              });
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(SizeManager.s16),
                      itemBuilder: (context, index) {
                        MessageModel messageModel = MessageModel.fromJson(snapshot.data!.docs[index].data());
                        String timeStamp = Methods.formatDate(context: context, milliseconds: int.parse(messageModel.timeStamp), isDateOnly: true);
                        timeStampDates.contains(timeStamp) ? timeStampDates.add(null) : timeStampDates.add(timeStamp);
                        return MessageItem(messageModel: messageModel, senderId: userAccountModel.userAccountId.toString(), date: timeStampDates[index]);
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s15),
                      itemCount: snapshot.data!.docs.length,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorsManager.grey100,
                      boxShadow: [BoxShadow(color: ColorsManager.black.withOpacity(0.1), blurRadius: SizeManager.s2, spreadRadius: SizeManager.s1)],
                    ),
                    child: Column(
                      children: [
                        if(suggestedMessagesProvider.suggestedMessages.isNotEmpty) Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s10),
                              child: Text(
                                Methods.getText(StringsManager.suggestedMessages, appProvider.isEnglish).toTitleCase(),
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.black),
                              ),
                            ),
                            SizedBox(
                              height: SizeManager.s40,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => SuggestedMessagesItem(suggestedMessageModel: suggestedMessagesProvider.suggestedMessages[index], clientId: userAccountModel.userAccountId.toString()),
                                separatorBuilder: (context, index) => const SizedBox(width: SizeManager.s5),
                                itemCount: suggestedMessagesProvider.suggestedMessages.length,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(SizeManager.s16),
                          child: CustomTextFormField(
                            controller: textEditingControllerMessage,
                            textDirection: Methods.getDirection(appProvider.isEnglish),
                            borderColor: ColorsManager.grey300,
                            hintText: Methods.getText(StringsManager.typeYourMessageHere, appProvider.isEnglish).toCapitalized(),
                            borderRadius: SizeManager.s10,
                            contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s10),
                            suffixIconPadding: EdgeInsets.zero,
                            suffixIcon: Container(
                              decoration: const BoxDecoration(
                                color: ColorsManager.primaryColor,
                                borderRadius: BorderRadiusDirectional.only(
                                  topEnd: Radius.circular(SizeManager.s10),
                                  bottomEnd: Radius.circular(SizeManager.s10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  if(textEditingControllerMessage.text.trim().isNotEmpty) {
                                    chatRoomProvider.onPressedAddChatAndMessage(
                                      context: context,
                                      senderId: userAccountModel.userAccountId.toString(),
                                      message: textEditingControllerMessage.text.trim(),
                                      userAccountModel: userAccountModel,
                                      isPushNotification: true,
                                    );
                                    textEditingControllerMessage.clear();
                                  }
                                },
                                icon: const Icon(Icons.send, color: ColorsManager.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingControllerMessage.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}