import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/btm_nav_bar/search/controllers/search_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/search/widgets/search_item.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late AppProvider appProvider;
  late SearchProvider searchProvider;
  final TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setSelectedSearchData(searchProvider.searchData);
    searchProvider.initScrollController();
    searchProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      duration: const Duration(seconds: 1),
      child: Padding(
        padding: const EdgeInsets.only(top: SizeManager.s16, left: SizeManager.s16, right: SizeManager.s16),
        child: Consumer<SearchProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Methods.getText(StringsManager.atYourService, appProvider.isEnglish).toTitleCase(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                    ),
                    Text(
                      Methods.getText(StringsManager.appName, appProvider.isEnglish).toTitleCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                    ),
                  ],
                ),
                const SizedBox(height: SizeManager.s16),
                CustomTextFormField(
                  controller: _textEditingControllerSearch,
                  textInputAction: TextInputAction.search,
                  textDirection: Methods.getDirection(appProvider.isEnglish),
                  labelText: Methods.getText(StringsManager.searchByNameOrSpecialty, appProvider.isEnglish).toCapitalized(),
                  onChanged: (val) => searchProvider.onChangeSearch(context, val.trim()),
                  prefixIcon: Image.asset(ImagesManager.searchOutlineIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textEditingControllerSearch.clear();
                      searchProvider.changeSelectedSearchData(searchProvider.searchData);
                    },
                    icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                  ),
                ),
                const SizedBox(height: SizeManager.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Methods.getText(StringsManager.results, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${provider.selectedSearchData.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: SizeManager.s8),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonType: ButtonType.postImage,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await Dialogs.orderByDialog(context: context, orderBy: searchProvider.orderBy).then((value) {
                            if(value != null) {
                              searchProvider.setOrderBy(value);
                              searchProvider.applyOrder();
                            }
                          });
                        },
                        text: Methods.getText(StringsManager.order, appProvider.isEnglish).toTitleCase(),
                        imageName: ImagesManager.orderIc,
                        imageColor: ColorsManager.white,
                        height: SizeManager.s40,
                      ),
                    ),
                    // const SizedBox(width: SizeManager.s10),
                    // Expanded(
                    //   child: CustomButton(
                    //     buttonType: ButtonType.preImage,
                    //     onPressed: () {
                    //       FocusScope.of(context).unfocus();
                    //     },
                    //     text: Methods.getText(StringsManager.filter, appProvider.isEnglish).toTitleCase(),
                    //     imageName: ImagesManager.filterIc,
                    //     imageColor: ColorsManager.primaryColor,
                    //     height: SizeManager.s40,
                    //     borderColor: ColorsManager.primaryColor,
                    //     buttonColor: ColorsManager.white,
                    //     textColor: ColorsManager.primaryColor,
                    //   ),
                    // ),
                    // const SizedBox(width: SizeManager.s10),
                    // Expanded(
                    //   child: CustomButton(
                    //     buttonType: ButtonType.preImage,
                    //     onPressed: () {
                    //       FocusScope.of(context).unfocus();
                    //     },
                    //     text: Methods.getText(StringsManager.map, appProvider.isEnglish).toTitleCase(),
                    //     imageName: ImagesManager.mapOutlineIc,
                    //     imageColor: ColorsManager.primaryColor,
                    //     height: SizeManager.s40,
                    //     borderColor: ColorsManager.primaryColor,
                    //     buttonColor: ColorsManager.white,
                    //     textColor: ColorsManager.primaryColor,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: SizeManager.s8),
                Expanded(
                  child: provider.selectedSearchData.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoResults) : ListView.separated(
                    controller: provider.scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SearchItem(searchModel: searchProvider.selectedSearchData[index], index: index),
                          if(index == provider.numberOfItems-1) Padding(
                            padding: const EdgeInsets.only(top: SizeManager.s16),
                            child: Column(
                              children: [
                                if(provider.hasMoreData) const Center(
                                  child: SizedBox(
                                    width: SizeManager.s20,
                                    height: SizeManager.s20,
                                    child: CircularProgressIndicator(strokeWidth: SizeManager.s3, color: ColorsManager.primaryColor),
                                  ),
                                ),
                                if(!provider.hasMoreData && provider.selectedSearchData.length > provider.limit) Text(
                                  Methods.getText(StringsManager.thereAreNoOtherResults, appProvider.isEnglish).toCapitalized(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                    itemCount: provider.numberOfItems,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingControllerSearch.dispose();
    searchProvider.scrollController.dispose();
    super.dispose();
  }
}