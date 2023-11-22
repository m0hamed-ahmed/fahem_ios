import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/sliders/slider_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllSlidersUseCase extends BaseUseCase<List<SliderModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllSlidersUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<SliderModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllSliders();
  }
}