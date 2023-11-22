import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/main/controllers/main_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

BottomNavigationBarItem bottomNavigationBarItem({required BuildContext context, required int index, required String text, required String image}) {
  return BottomNavigationBarItem(
    label: text,
    icon: Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topEnd,
      children: [
        Selector<MainProvider, int>(
          selector: (context, provider) => provider.bottomNavigationBarIndex,
          builder: (context, bottomNavigationBarIndex, _) {
            return Image.asset(
              image,
              width: SizeManager.s20,
              height: SizeManager.s20,
              color: bottomNavigationBarIndex == index ? ColorsManager.white : ColorsManager.white.withOpacity(0.5),
            );
          },
        ),
        Selector<UserAccountProvider, UserAccountModel?>(
          selector: (context, provider) => provider.userAccount,
          builder: (context, userAccount, _) {
            return Consumer<TransactionsProvider>(
              builder: (context, transactionsProvider, _) {
                // int transactionsIsNotViewedLength = transactionsProvider.transactions.where((element) => !element.isViewed).length;
                // return index == 2 && userAccount != null && transactionsIsNotViewedLength != 0
                return index == 2 && userAccount != null && !CacheHelper.getData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED)
                    ? PositionedDirectional(
                  top: 0,
                  end: -3,
                  child: Container(
                    padding: const EdgeInsets.all(SizeManager.s2),
                    width: SizeManager.s10,
                    height: SizeManager.s10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.red,
                    ),
                  ),
                )
                    : const SizedBox();
              },
            );
          },
        ),
        // Selector<UserAccountProvider, UserAccountModel?>(
        //   selector: (context, provider) => provider.userAccount,
        //   builder: (context, userAccount, _) {
        //     return Consumer<TransactionsProvider>(
        //       builder: (context, transactionsProvider, _) {
        //         int transactionsIsNotViewedLength = transactionsProvider.transactions.where((element) => !element.isViewed).length;
        //         return index == 2 && userAccount != null && transactionsIsNotViewedLength != 0 ? PositionedDirectional(
        //           top: -8,
        //           end: -10,
        //           child: Container(
        //             padding: const EdgeInsets.all(SizeManager.s2),
        //             width: SizeManager.s20,
        //             height: SizeManager.s20,
        //             decoration: const BoxDecoration(
        //               shape: BoxShape.circle,
        //               color: ColorsManager.red,
        //             ),
        //             child: Center(
        //               child: FittedBox(
        //                 child: Consumer<TransactionsProvider>(
        //                   builder: (context, _, __) {
        //                     return Text(
        //                       transactionsIsNotViewedLength.toString(),
        //                       style: const TextStyle(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
        //                     );
        //                   },
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ) : const SizedBox();
        //       },
        //     );
        //   },
        // ),
      ],
    ),
  );
}