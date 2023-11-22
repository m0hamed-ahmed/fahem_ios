import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/controllers/lawyers_categories_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/widgets/lawyers_category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildLawyersCategoriesGrid extends StatefulWidget {

  const BuildLawyersCategoriesGrid({super.key});

  @override
  State<BuildLawyersCategoriesGrid> createState() => _BuildLawyersCategoriesGridState();
}

class _BuildLawyersCategoriesGridState extends State<BuildLawyersCategoriesGrid> {
  late LawyersCategoriesProvider lawyersCategoriesProvider;

  @override
  void initState() {
    super.initState();
    lawyersCategoriesProvider = Provider.of<LawyersCategoriesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              LawyersCategoryItem(
                lawyerCategoryModel: lawyersCategoriesProvider.lawyersCategories[0],
                height: SizeManager.s150,
                linesImage: ImagesManager.lines3,
              ),
              const SizedBox(height: SizeManager.s10),
              LawyersCategoryItem(
                lawyerCategoryModel: lawyersCategoriesProvider.lawyersCategories[1],
                height: SizeManager.s100,
                linesImage: ImagesManager.lines1,
              ),
              const SizedBox(height: SizeManager.s10),
              LawyersCategoryItem(
                lawyerCategoryModel: lawyersCategoriesProvider.lawyersCategories[2],
                height: SizeManager.s125,
                linesImage: ImagesManager.lines2,
              ),
            ],
          ),
        ),
        const SizedBox(width: SizeManager.s10),
        Expanded(
          child: Column(
            children: [
              LawyersCategoryItem(
                lawyerCategoryModel: lawyersCategoriesProvider.lawyersCategories[3],
                height: SizeManager.s100,
                linesImage: ImagesManager.lines1,
              ),
              const SizedBox(height: SizeManager.s10),
              LawyersCategoryItem(
                lawyerCategoryModel: lawyersCategoriesProvider.lawyersCategories[4],
                height: SizeManager.s125,
                linesImage: ImagesManager.lines3,
              ),
              const SizedBox(height: SizeManager.s10),
              LawyersCategoryItem(
                lawyerCategoryModel: lawyersCategoriesProvider.lawyersCategories[5],
                height: SizeManager.s150,
                linesImage: ImagesManager.lines3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}