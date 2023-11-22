import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlist_details_provider.dart';
import 'package:fahem/presentation/features/playlists/widgets/playlist_comment_item.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistComments extends StatefulWidget {
  final PlaylistModel playlistModel;

  const PlaylistComments({super.key, required this.playlistModel});

  @override
  State<PlaylistComments> createState() => _PlaylistCommentsState();
}

class _PlaylistCommentsState extends State<PlaylistComments> {
  late AppProvider appProvider;
  late PlaylistDetailsProvider playlistDetailsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    playlistDetailsProvider = Provider.of<PlaylistDetailsProvider>(context, listen: false);

    playlistDetailsProvider.textEditingControllerComment = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Column(
        children: [
          CustomTextFormField(
            controller: playlistDetailsProvider.textEditingControllerComment,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            textDirection: Methods.getDirection(appProvider.isEnglish),
            fillColor: ColorsManager.grey300,
            borderColor: ColorsManager.grey300,
            hintText: Methods.getText(StringsManager.addComment, appProvider.isEnglish).toTitleCase(),
            contentPadding: const EdgeInsets.all(SizeManager.s10),
            onChanged: (val) => playlistDetailsProvider.changeComment(val),
          ),
          const SizedBox(height: SizeManager.s10),
          Selector<UserAccountProvider, UserAccountModel?>(
            selector: (context, provider) => provider.userAccount,
            builder: (context, account, _) {
              return Selector<PlaylistDetailsProvider, bool>(
                selector: (context, provider) => provider.isLoading,
                builder: (context, isLoading, _) {
                  return isLoading ? const SizedBox(
                      height: SizeManager.s20,
                      width: SizeManager.s20,
                      child: CircularProgressIndicator(strokeWidth: SizeManager.s3)
                  ) : Selector<PlaylistDetailsProvider, String>(
                    selector: (context, provider) => provider.comment,
                    builder: (context, comment, _) {
                      return IgnorePointer(
                        ignoring: comment == ConstantsManager.empty,
                        child: CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () {
                            if(account == null) {
                              Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                              });
                            }
                            else {
                              playlistDetailsProvider.onPressedAddComment(context, widget.playlistModel.playlistId);
                            }
                          },
                          text: Methods.getText(StringsManager.send, appProvider.isEnglish).toTitleCase(),
                          buttonColor: comment == ConstantsManager.empty ? ColorsManager.primaryColor.withOpacity(0.5) : ColorsManager.primaryColor,
                          height: SizeManager.s40,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: SizeManager.s20),
          Consumer<PlaylistDetailsProvider>(
            builder: (context, _, __) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => PlaylistCommentItem(playlistCommentModel: widget.playlistModel.playlistComments[index]),
                separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                itemCount: widget.playlistModel.playlistComments.length,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    playlistDetailsProvider.textEditingControllerComment.dispose();
    super.dispose();
  }
}