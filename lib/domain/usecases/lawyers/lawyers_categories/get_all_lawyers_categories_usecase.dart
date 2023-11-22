import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/lawyers/lawyers_categories/lawyer_category_model.dart';
import 'package:fahem/domain/repository/base_repository.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';

class GetAllLawyersCategoriesUseCase extends BaseUseCase<List<LawyerCategoryModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllLawyersCategoriesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LawyerCategoryModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllLawyersCategories();
  }
}