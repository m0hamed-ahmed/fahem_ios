import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/static/main_category_model.dart';

List<MainCategoryModel> mainCategoryData = [
  MainCategoryModel(
    mainCategoryId: 1,
    image: ImagesManager.lawyers,
    nameAr: Methods.getText(StringsManager.lawyers, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.lawyers, true).toTitleCase(),
    route: Routes.lawyersCategoriesRoute,
    timeStamp: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
  ),
  MainCategoryModel(
    mainCategoryId: 2,
    image: ImagesManager.publicRelations,
    nameAr: Methods.getText(StringsManager.publicRelations, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.publicRelations, true).toTitleCase(),
    route: Routes.publicRelationsCategoriesRoute,
    timeStamp: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
  ),
  MainCategoryModel(
    mainCategoryId: 3,
    image: ImagesManager.legalAccountants,
    nameAr: Methods.getText(StringsManager.legalAccountants, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.legalAccountants, true).toTitleCase(),
    route: Routes.legalAccountantsRoute,
    timeStamp: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
  ),
];