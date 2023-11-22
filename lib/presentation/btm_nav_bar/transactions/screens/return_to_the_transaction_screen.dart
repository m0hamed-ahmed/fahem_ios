import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/usecases/transactions/transactions/toggle_is_done_instant_consultation_usecase.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/instant_consultations_comments_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/widgets/instant_consultation_comment_item.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnToTheTransactionScreen extends StatefulWidget {
  final TransactionModel transactionModel;

  const ReturnToTheTransactionScreen({super.key, required this.transactionModel});

  @override
  State<ReturnToTheTransactionScreen> createState() => _ReturnToTheTransactionScreenState();
}

class _ReturnToTheTransactionScreenState extends State<ReturnToTheTransactionScreen> {
  late AppProvider appProvider;
  late TransactionsProvider transactionsProvider;
  late InstantConsultationsCommentsProvider instantConsultationsCommentsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    instantConsultationsCommentsProvider = Provider.of<InstantConsultationsCommentsProvider>(context, listen: false);

    instantConsultationsCommentsProvider.commentsForTransaction = instantConsultationsCommentsProvider.instantConsultationsComments.where((element) => element.transactionId == widget.transactionModel.transactionId).toList();

    instantConsultationsCommentsProvider.initScrollController();
    instantConsultationsCommentsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Selector<TransactionsProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: instantConsultationsCommentsProvider.scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(widget.transactionModel.transactionType == TransactionType.instantConsultation) Padding(
                        padding: const EdgeInsets.all(SizeManager.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const PreviousButton(),
                                const SizedBox(width: SizeManager.s20),
                                Expanded(
                                  child: Text(
                                    Methods.getText(StringsManager.instantConsultation, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeManager.s20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Methods.getText(StringsManager.name, appProvider.isEnglish).toCapitalized(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(height: SizeManager.s5),
                                Container(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.grey300,
                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                  ),
                                  child: Text(
                                    widget.transactionModel.name,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeManager.s20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Methods.getText(StringsManager.mobileNumber, appProvider.isEnglish).toCapitalized(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(height: SizeManager.s5),
                                Container(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.grey300,
                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                  ),
                                  child: Text(
                                    widget.transactionModel.phoneNumber,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeManager.s20),

                            if(widget.transactionModel.emailAddress != null) Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Methods.getText(StringsManager.eMail, appProvider.isEnglish).toCapitalized(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(height: SizeManager.s5),
                                Container(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.grey300,
                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                  ),
                                  child: Text(
                                    widget.transactionModel.emailAddress!,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                              ],
                            ),
                            if(widget.transactionModel.emailAddress != null) const SizedBox(height: SizeManager.s20),

                            Text(
                              Methods.getText(StringsManager.theInstantConsultation, appProvider.isEnglish).toCapitalized(),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                            ),
                            const SizedBox(height: SizeManager.s5),
                            Container(
                              padding: const EdgeInsets.all(SizeManager.s10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorsManager.grey300,
                                borderRadius: BorderRadius.circular(SizeManager.s10),
                              ),
                              child: Text(
                                appProvider.isEnglish ? widget.transactionModel.textEn : widget.transactionModel.textAr,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                              ),
                            ),
                            const SizedBox(height: SizeManager.s20),

                            Text(
                              '${Methods.getText(StringsManager.comments, appProvider.isEnglish).toCapitalized()} (${instantConsultationsCommentsProvider.commentsForTransaction.length})',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                            ),
                            const SizedBox(height: SizeManager.s8),
                            Consumer<InstantConsultationsCommentsProvider>(
                              builder: (context, provider, _) {
                                return instantConsultationsCommentsProvider.commentsForTransaction.isEmpty ? Container() : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InstantConsultationCommentItem(instantConsultationCommentModel: instantConsultationsCommentsProvider.commentsForTransaction[index], index: index),
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
                                              if(!provider.hasMoreData && instantConsultationsCommentsProvider.commentsForTransaction.length > provider.limit) Text(
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
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      if(widget.transactionModel.transactionType == TransactionType.secretConsultation) Padding(
                        padding: const EdgeInsets.all(SizeManager.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const PreviousButton(),
                                const SizedBox(width: SizeManager.s20),
                                Expanded(
                                  child: Text(
                                    Methods.getText(StringsManager.secretConsultation, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeManager.s20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Methods.getText(StringsManager.mobileNumber, appProvider.isEnglish).toCapitalized(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(height: SizeManager.s5),
                                Container(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.grey300,
                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                  ),
                                  child: Text(
                                    widget.transactionModel.phoneNumber,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SizeManager.s20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Methods.getText(StringsManager.theSecretConsultation, appProvider.isEnglish).toCapitalized(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(height: SizeManager.s5),
                                Container(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.grey300,
                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                  ),
                                  child: Text(
                                    appProvider.isEnglish ? widget.transactionModel.textEn : widget.transactionModel.textAr,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: widget.transactionModel.transactionType == TransactionType.instantConsultation ? Container(
                margin: const EdgeInsets.all(SizeManager.s16),
                child: Selector<TransactionsProvider, bool?>(
                  selector: (context, provider) => provider.transactions.firstWhere((element) => element.transactionId == widget.transactionModel.transactionId).isDoneInstantConsultation,
                  builder: (context, isDoneInstantConsultation, __) {
                    return IgnorePointer(
                      ignoring: (isDoneInstantConsultation == null || isDoneInstantConsultation == false) ? false : true,
                      child: Opacity(
                        opacity: (isDoneInstantConsultation == null || isDoneInstantConsultation == false) ? 1 : 0.5,
                        child: CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () {
                            Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.areYouSureAboutTheProcessOfClosingTheConsultation, appProvider.isEnglish).toCapitalized()).then((value) {
                              if(value) {
                                ToggleIsDoneInstantConsultationParameters parameters = ToggleIsDoneInstantConsultationParameters(
                                  transactionId: widget.transactionModel.transactionId,
                                );
                                transactionsProvider.toggleIsDoneInstantConsultation(context, parameters);
                                Dialogs.showBottomSheetMessage(
                                  context: context,
                                  message: Methods.getText(StringsManager.consultationClosed, appProvider.isEnglish).toCapitalized(),
                                  showMessage: ShowMessage.success,
                                );
                              }
                            });
                          },
                          text: Methods.getText((isDoneInstantConsultation == null || isDoneInstantConsultation == false) ? StringsManager.doneConsultation : StringsManager.consultationClosed, appProvider.isEnglish).toTitleCase(),
                        ),
                      ),
                    );
                  },
                ),
              ) : const SizedBox(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    instantConsultationsCommentsProvider.disposeScrollController();
    super.dispose();
  }
}