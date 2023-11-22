import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllPlaylistsUseCase extends BaseUseCase<List<PlaylistModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllPlaylistsUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PlaylistModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllPlaylists();
  }
}