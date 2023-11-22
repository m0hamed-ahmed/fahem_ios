import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/data/models/playlists/playlist_comments/playlist_comment_model.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/delete_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/edit_playlist_comment_usecase.dart';
import 'package:fahem/domain/usecases/playlists/playlist_comments/insert_playlist_comment_usecase.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlists_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistDetailsProvider with ChangeNotifier {
  final InsertPlaylistCommentUseCase _insertPlaylistCommentUseCase;
  final EditPlaylistCommentUseCase _editPlaylistCommentUseCase;
  final DeletePlaylistCommentUseCase _deletePlaylistCommentUseCase;

  PlaylistDetailsProvider(this._insertPlaylistCommentUseCase, this._editPlaylistCommentUseCase, this._deletePlaylistCommentUseCase);

  Future<Either<Failure, PlaylistCommentModel>> insertPlaylistCommentImpl(InsertPlaylistCommentParameters parameters) async {
    return await _insertPlaylistCommentUseCase.call(parameters);
  }

  Future<Either<Failure, PlaylistCommentModel>> editPlaylistCommentImpl(EditPlaylistCommentParameters parameters) async {
    return await _editPlaylistCommentUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deletePlaylistCommentImpl(DeletePlaylistCommentParameters parameters) async {
    return await _deletePlaylistCommentUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  PlaylistsMode _playlistsMode = PlaylistsMode.aboutVideo;
  PlaylistsMode get playlistsMode => _playlistsMode;
  setPlaylistsMode(PlaylistsMode playlistsMode) => _playlistsMode = playlistsMode;
  changePlaylistsMode(PlaylistsMode playlistsMode) {_playlistsMode = playlistsMode; notifyListeners();}

  int _currentVideoIndex = 0;
  int get currentVideoIndex => _currentVideoIndex;
  setCurrentVideoIndex(int currentVideoIndex) => _currentVideoIndex = currentVideoIndex;
  changeCurrentVideoIndex(int currentVideoIndex) {_currentVideoIndex = currentVideoIndex; notifyListeners();}

  late TextEditingController textEditingControllerComment;

  String _comment = ConstantsManager.empty;
  String get comment => _comment;
  setComment(String comment) => _comment = comment;
  changeComment(String comment) {_comment = comment; notifyListeners();}

  Future<void> onPressedAddComment(BuildContext context, int playlistId) async {
    FocusScope.of(context).unfocus();

    PlaylistsProvider playlistsProvider = Provider.of<PlaylistsProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    changeIsLoading(true);

    PlaylistCommentModel playlistCommentModel = PlaylistCommentModel(
      playlistCommentId: 0,
      playlistId: playlistId,
      userAccountId: userAccountProvider.userAccount!.userAccountId,
      firstName: userAccountProvider.userAccount!.firstName,
      familyName: userAccountProvider.userAccount!.familyName,
      comment: _comment,
      createdAt: DateTime.now(),
    );
    // Insert Playlist comment
    InsertPlaylistCommentParameters parameters = InsertPlaylistCommentParameters(
      playlistCommentModel: playlistCommentModel,
    );
    Either<Failure, PlaylistCommentModel> response = await insertPlaylistCommentImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (comment) {
      changeIsLoading(false);
      textEditingControllerComment.clear();
      setComment(ConstantsManager.empty);
      int playlistIndex = playlistsProvider.playlists.indexWhere((element) => element.playlistId == comment.playlistId);
      playlistsProvider.playlists[playlistIndex].playlistComments.insert(0, comment);
      notifyListeners();
    });

    changeIsLoading(false);
  }

  void resetAllData() {
    setPlaylistsMode(PlaylistsMode.aboutVideo);
    setCurrentVideoIndex(0);
    setComment(ConstantsManager.empty);
  }

  Future<bool> onBackPressed() async {
    resetAllData();
    return await Future.value(true);
  }
}