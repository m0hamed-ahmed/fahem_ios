import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/widgets/public_relations_category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildPublicRelationsCategoriesGrid extends StatefulWidget {

  const BuildPublicRelationsCategoriesGrid({Key? key}) : super(key: key);

  @override
  State<BuildPublicRelationsCategoriesGrid> createState() => _BuildPublicRelationsCategoriesGridState();
}

class _BuildPublicRelationsCategoriesGridState extends State<BuildPublicRelationsCategoriesGrid> {
  late PublicRelationsCategoriesProvider publicRelationsCategoriesProvider;

  @override
  void initState() {
    super.initState();
    publicRelationsCategoriesProvider = Provider.of<PublicRelationsCategoriesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              PublicRelationsCategoryItem(
                publicRelationCategoryModel: publicRelationsCategoriesProvider.publicRelationsCategories[0],
                height: SizeManager.s225,
                linesImage: ImagesManager.lines3,
              ),
              const SizedBox(height: SizeManager.s10),
              PublicRelationsCategoryItem(
                publicRelationCategoryModel: publicRelationsCategoriesProvider.publicRelationsCategories[1],
                height: SizeManager.s185,
                linesImage: ImagesManager.lines1,
              ),
            ],
          ),
        ),
        const SizedBox(width: SizeManager.s10),
        Expanded(
          child: Column(
            children: [
              PublicRelationsCategoryItem(
                publicRelationCategoryModel: publicRelationsCategoriesProvider.publicRelationsCategories[2],
                height: SizeManager.s100,
                linesImage: ImagesManager.lines1,
              ),
              const SizedBox(height: SizeManager.s10),
              PublicRelationsCategoryItem(
                publicRelationCategoryModel: publicRelationsCategoriesProvider.publicRelationsCategories[3],
                height: SizeManager.s200,
                linesImage: ImagesManager.lines3,
              ),
              const SizedBox(height: SizeManager.s10),
              PublicRelationsCategoryItem(
                publicRelationCategoryModel: publicRelationsCategoriesProvider.publicRelationsCategories[4],
                height: SizeManager.s100,
                linesImage: ImagesManager.lines3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}