import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/packages/package_model.dart';
import 'package:fahem/presentation/features/packages/controllers/packages_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackageItem extends StatefulWidget {
  final PackageModel packageModel;
  final int index;
  
  const PackageItem({super.key, required this.packageModel, required this.index});

  @override
  State<PackageItem> createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  late AppProvider appProvider;
  late PackagesProvider packagesProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    packagesProvider = Provider.of<PackagesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<WalletProvider, int>(
      selector: (context, provider) => provider.wallet == null ? 0 :provider.wallet!.balance,
      builder: (context, balance, child) {
        return Selector<PackagesProvider, PackageModel?>(
          selector: (context, provider) => provider.selectedPackage,
          builder: (context, selectedPackage, child) {
            return IgnorePointer(
              ignoring: balance >= widget.packageModel.price ? false : true,
              child: Opacity(
                opacity: balance >= widget.packageModel.price ? 1 : 0.3,
                child: GestureDetector(
                  onTap: () => packagesProvider.changeSelectedPackage(widget.packageModel),
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedPackage != null && widget.packageModel == selectedPackage ? ColorsManager.black : Colors.transparent,
                        width: SizeManager.s2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: SizeManager.s8, horizontal: SizeManager.s16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appProvider.isEnglish ? widget.packageModel.nameEn : widget.packageModel.nameAr,
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                              ),
                              Text(
                                '${widget.packageModel.price.toString()} ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: SizeManager.s8, horizontal: SizeManager.s16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: widget.index % 2 == 0 ? ColorsManager.secondaryColor.withOpacity(0.3) : ColorsManager.primaryColor.withOpacity(0.3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(widget.packageModel.featuresAr.length, (index2) {
                              return Text(
                                widget.packageModel.featuresAr[index2],
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.black),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}