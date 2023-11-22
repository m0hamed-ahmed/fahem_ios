import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/widgets/transaction_category_item.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/widgets/transaction_item.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {

  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late AppProvider appProvider;
  late TransactionsProvider transactionsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);

    transactionsProvider.resetAllData();

    transactionsProvider.setSelectedTransactions(transactionsProvider.transactions);
    transactionsProvider.initScrollController();
    transactionsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      duration: const Duration(seconds: 1),
      child: Selector<TransactionsProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: WillPopScope(
              onWillPop: () => Future.value(!isLoading),
              child: Consumer<TransactionsProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: SizeManager.s16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                        child: Text(
                          Methods.getText(StringsManager.myTransactions, appProvider.isEnglish).toCapitalized(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s16),
                      SizedBox(
                        height: SizeManager.s35,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => TransactionCategoryItem(category: transactionsProvider.categories[index]),
                          separatorBuilder: (context, index) => const SizedBox(width: SizeManager.s10),
                          itemCount: transactionsProvider.categories.length,
                        ),
                      ),
                      const SizedBox(height: SizeManager.s16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Methods.getText(StringsManager.results, appProvider.isEnglish).toCapitalized(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${provider.selectedTransactions.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SizeManager.s8),
                      Expanded(
                        child: provider.selectedTransactions.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoTransactions) : ListView.separated(
                          controller: provider.scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TransactionItem(transactionModel: transactionsProvider.selectedTransactions[index]),
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
                                      if(!provider.hasMoreData && provider.selectedTransactions.length > provider.limit) Text(
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
        },
      ),
    );
  }

  @override
  void dispose() {
    transactionsProvider.disposeScrollController();
    super.dispose();
  }
}