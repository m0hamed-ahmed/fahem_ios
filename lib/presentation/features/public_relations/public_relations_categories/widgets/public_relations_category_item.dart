import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicRelationsCategoryItem extends StatefulWidget {
  final PublicRelationCategoryModel publicRelationCategoryModel;
  final double height;
  final String linesImage;

  const PublicRelationsCategoryItem({Key? key, required this.publicRelationCategoryModel, required this.height, required this.linesImage}) : super(key: key);

  @override
  State<PublicRelationsCategoryItem> createState() => _PublicRelationsCategoryItemState();
}

class _PublicRelationsCategoryItemState extends State<PublicRelationsCategoryItem> {
  late AppProvider appProvider;
  late PublicRelationsCategoriesProvider publicRelationsCategoriesProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationsCategoriesProvider = Provider.of<PublicRelationsCategoriesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeManager.s20),
      ),
      child: InkWell(
        onTap: () async {
          PublicRelationsProvider publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);
          publicRelationsProvider.changeSelectedPublicRelations(publicRelationsProvider.publicRelations.where((publicRelations) {
            return publicRelations.categoriesIds.contains(widget.publicRelationCategoryModel.publicRelationCategoryId.toString());
          }).toList());
          GovernmentModel governmentModel = governoratesData[1];
          publicRelationsProvider.setSelectedGovernmentModel(governmentModel);
          Navigator.pushNamed(
            context,
            Routes.publicRelationsRoute,
            arguments: {
              ConstantsManager.publicRelationCategoryIdArgument: widget.publicRelationCategoryModel.publicRelationCategoryId,
            },
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.publicRelationsCategoriesDirectory}/${widget.publicRelationCategoryModel.image}')),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: ColorsManager.black.withOpacity(0.5),
            ),
            Image.asset(widget.linesImage, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.all(SizeManager.s10),
              child: Text(
                appProvider.isEnglish ? widget.publicRelationCategoryModel.nameEn : widget.publicRelationCategoryModel.nameAr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}