import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCategoryItem extends StatefulWidget {
  final String category;

  const TransactionCategoryItem({super.key, required this.category});

  @override
  State<TransactionCategoryItem> createState() => _TransactionCategoryItemState();
}

class _TransactionCategoryItemState extends State<TransactionCategoryItem> {
  late TransactionsProvider transactionsProvider;

  @override
  void initState() {
    super.initState();
    transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TransactionsProvider, String>(
      selector: (context, provider) => provider.selectedCategory,
      builder: (context, selectedCategory, _) {
        return Container(
          decoration: BoxDecoration(
            color: selectedCategory == widget.category ? ColorsManager.secondaryColor : ColorsManager.white,
            border: Border.all(color: selectedCategory == widget.category ? ColorsManager.secondaryColor : ColorsManager.primaryColor),
            borderRadius: BorderRadius.circular(SizeManager.s10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => transactionsProvider.changeSelectedCategory(widget.category),
              borderRadius: BorderRadius.circular(SizeManager.s10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SizeManager.s10),
                child: Center(
                  child: Text(
                    transactionsProvider.getCategoryName(context, widget.category).toTitleCase(),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: selectedCategory == widget.category ? ColorsManager.white : ColorsManager.primaryColor,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}