import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/widgets/public_relation_item.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/widgets/build_public_relations_categories_grid.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicRelationsCategoriesScreen extends StatefulWidget {

  const PublicRelationsCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<PublicRelationsCategoriesScreen> createState() => _PublicRelationsCategoriesScreenState();
}

class _PublicRelationsCategoriesScreenState extends State<PublicRelationsCategoriesScreen> {
  late AppProvider appProvider;
  late PublicRelationsProvider publicRelationsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Selector<PublicRelationsCategoriesProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: Scaffold(
              body: Background(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(SizeManager.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PreviousButton(),
                            const SizedBox(width: SizeManager.s20),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Methods.getText(StringsManager.atYourService, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                  ),
                                  Text(
                                    Methods.getText(StringsManager.publicRelationsFromFahem, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s16),

                        const BuildPublicRelationsCategoriesGrid(),

                        if(publicRelationsProvider.publicRelations.isNotEmpty) Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: SizeManager.s16),
                            Text(
                              Methods.getText(StringsManager.highestRated, appProvider.isEnglish).toTitleCase(),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                            ),
                            const SizedBox(height: SizeManager.s8),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => PublicRelationItem(publicRelationModel: publicRelationsProvider.publicRelations[index], index: index),
                              separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                              itemCount: publicRelationsProvider.publicRelations.isNotEmpty && publicRelationsProvider.publicRelations.length >= ConstantsManager.maxNumberToShowHighestRatedPublicRelations
                                  ? ConstantsManager.maxNumberToShowHighestRatedPublicRelations
                                  : publicRelationsProvider.publicRelations.length,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}