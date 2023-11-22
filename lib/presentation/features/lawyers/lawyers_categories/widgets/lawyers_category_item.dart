import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/data/models/lawyers/lawyers_categories/lawyer_category_model.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/controllers/lawyers_categories_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LawyersCategoryItem extends StatefulWidget {
  final LawyerCategoryModel lawyerCategoryModel;
  final double height;
  final String linesImage;

  const LawyersCategoryItem({super.key, required this.lawyerCategoryModel, required this.height, required this.linesImage});

  @override
  State<LawyersCategoryItem> createState() => _LawyersCategoryItemState();
}

class _LawyersCategoryItemState extends State<LawyersCategoryItem> {
  late AppProvider appProvider;
  late LawyersCategoriesProvider lawyersCategoriesProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyersCategoriesProvider = Provider.of<LawyersCategoriesProvider>(context, listen: false);
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
          LawyersProvider lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
          lawyersProvider.changeSelectedLawyers(lawyersProvider.lawyers.where((lawyer) {
            return lawyer.categoriesIds.contains(widget.lawyerCategoryModel.lawyerCategoryId.toString());
          }).toList());
          GovernmentModel governmentModel = governoratesData[1];
          lawyersProvider.setSelectedGovernmentModel(governmentModel);
          Navigator.pushNamed(
            context,
            Routes.lawyersRoute,
            arguments: {
              ConstantsManager.lawyersCategoryIdArgument: widget.lawyerCategoryModel.lawyerCategoryId,
            },
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.lawyersCategoriesDirectory}/${widget.lawyerCategoryModel.image}')),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: ColorsManager.black.withOpacity(0.5),
            ),
            Image.asset(widget.linesImage, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.all(SizeManager.s10),
              child: Text(
                appProvider.isEnglish ? widget.lawyerCategoryModel.nameEn : widget.lawyerCategoryModel.nameAr,
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