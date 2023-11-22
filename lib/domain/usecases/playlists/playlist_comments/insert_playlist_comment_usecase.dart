import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/playlists/playlist_comments/playlist_comment_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class InsertPlaylistCommentUseCase extends BaseUseCase<PlaylistCommentModel, InsertPlaylistCommentParameters> {
  final BaseRepository _baseRepository;

  InsertPlaylistCommentUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PlaylistCommentModel>> call(InsertPlaylistCommentParameters parameters) async {
    return await _baseRepository.insertPlaylistComment(parameters);
  }
}

class InsertPlaylistCommentParameters {
  final PlaylistCommentModel playlistCommentModel;

  InsertPlaylistCommentParameters({required this.playlistCommentModel});
}