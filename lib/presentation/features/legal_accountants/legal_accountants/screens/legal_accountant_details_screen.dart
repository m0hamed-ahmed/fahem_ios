import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_features_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/widgets/legal_accountant_review_item.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class LegalAccountantDetailsScreen extends StatefulWidget {
  final LegalAccountantModel legalAccountantModel;

  const LegalAccountantDetailsScreen({super.key, required this.legalAccountantModel});

  @override
  State<LegalAccountantDetailsScreen> createState() => _LegalAccountantsDetailsScreenState();
}

class _LegalAccountantsDetailsScreenState extends State<LegalAccountantDetailsScreen> {
  late AppProvider appProvider;
  late LegalAccountantsReviewsProvider legalAccountantsReviewsProvider;
  late LegalAccountantsFeaturesProvider legalAccountantsFeaturesProvider;
  late UserAccountProvider userAccountProvider;
  late TransactionsProvider transactionsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantsReviewsProvider = Provider.of<LegalAccountantsReviewsProvider>(context, listen: false);
    legalAccountantsFeaturesProvider = Provider.of<LegalAccountantsFeaturesProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
  }

  bool isShowReviewButton() {
    for(int i=0; i<transactionsProvider.transactions.length; i++) {
      if(
      widget.legalAccountantModel.legalAccountantId == transactionsProvider.transactions[i].targetId
          && (transactionsProvider.transactions[i].transactionType == TransactionType.showLegalAccountantNumber || transactionsProvider.transactions[i].transactionType == TransactionType.appointmentBookingWithLegalAccountant)
      ) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Consumer<LegalAccountantsReviewsProvider>(
              builder: (context, provider, _) {
                List<LegalAccountantReviewModel> legalAccountantsReviews = legalAccountantsReviewsProvider.legalAccountantsReviews.where((element) => element.legalAccountantId == widget.legalAccountantModel.legalAccountantId).toList();
                int totalReviews = legalAccountantsReviews.length;
                int excellent = legalAccountantsReviewsProvider.legalAccountantsReviews.where((element) => element.legalAccountantId == widget.legalAccountantModel.legalAccountantId && element.rating >= 4 && element.rating <= 5).length;
                int good = legalAccountantsReviewsProvider.legalAccountantsReviews.where((element) => element.legalAccountantId == widget.legalAccountantModel.legalAccountantId && element.rating >= 2 && element.rating < 4).length;
                int lessThanExpected = legalAccountantsReviewsProvider.legalAccountantsReviews.where((element) => element.legalAccountantId == widget.legalAccountantModel.legalAccountantId && element.rating >= 0 && element.rating < 2).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                                  '${Methods.getText(StringsManager.data, appProvider.isEnglish).toTitleCase()} ${widget.legalAccountantModel.name}',
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SizeManager.s20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.legalAccountantModel.personalImage, ConstantsManager.directoryArgument: ApiConstants.legalAccountantsDirectory}),
                                child: SizedBox(
                                  width: SizeManager.s100,
                                  height: SizeManager.s100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(SizeManager.s50),
                                    child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.legalAccountantsDirectory}/${widget.legalAccountantModel.personalImage}')),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.legalAccountantModel.name,
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                            ),
                                          ),
                                          if(widget.legalAccountantModel.isVerified) ...[
                                            const SizedBox(width: SizeManager.s5),
                                            const Icon(Icons.verified, color: ColorsManager.primaryColor, size: 20),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: SizeManager.s5),
                                      Text(
                                        widget.legalAccountantModel.jobTitle,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: SizeManager.s5),
                                      Row(
                                        children: [
                                          RatingBar(numberOfStars: widget.legalAccountantModel.rating, starSize: SizeManager.s12, padding: SizeManager.s1),
                                          const SizedBox(width: SizeManager.s10),
                                          Text(
                                            '${Methods.getText(StringsManager.overallRatingOf, appProvider.isEnglish).toCapitalized()} $totalReviews ${Methods.getText(StringsManager.user, appProvider.isEnglish)}',
                                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: SizeManager.s10),
                                      ReadMoreText(
                                        widget.legalAccountantModel.information,
                                        trimMode: TrimMode.Line,
                                        trimLines: 3,
                                        trimCollapsedText: Methods.getText(StringsManager.showMore, appProvider.isEnglish).toCapitalized(),
                                        trimExpandedText: ' ${Methods.getText(StringsManager.showLess, appProvider.isEnglish).toCapitalized()}',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        moreStyle: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeightManager.bold),
                                        lessStyle: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeightManager.bold),
                                      ),
                                      const SizedBox(height: SizeManager.s20),
                                      Wrap(
                                        spacing: SizeManager.s5,
                                        runSpacing: SizeManager.s5,
                                        children: List.generate(widget.legalAccountantModel.features.length, (index) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: SizeManager.s3, horizontal: SizeManager.s10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(SizeManager.s10),
                                              border: Border.all(color: ColorsManager.secondaryColor),
                                            ),
                                            child: Text(
                                              widget.legalAccountantModel.features[index],
                                              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.secondaryColor, fontWeight: FontWeightManager.black),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: ColorsManager.grey),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagesManager.clipboardIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                              const SizedBox(width: SizeManager.s10),
                              Expanded(
                                child: Wrap(
                                  children: List.generate(widget.legalAccountantModel.tasks.length, (index) {
                                    return Text(
                                      '${widget.legalAccountantModel.tasks[index]} ${index == widget.legalAccountantModel.tasks.length-1 ? '' : '-'} ',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagesManager.mapIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                              const SizedBox(width: SizeManager.s10),
                              Expanded(
                                child: Text(
                                  widget.legalAccountantModel.address,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagesManager.moneyIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                              const SizedBox(width: SizeManager.s10),
                              Text(
                                '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${widget.legalAccountantModel.consultationPrice} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const Divider(color: ColorsManager.grey),
                          Text(
                            Methods.getText(
                              widget.legalAccountantModel.isBookingByAppointment && widget.legalAccountantModel.availablePeriods.isNotEmpty
                                  ? StringsManager.chooseYourConsultationAppointment
                                  : StringsManager.callNow,
                              appProvider.isEnglish,
                            ).toTitleCase(),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  buttonType: ButtonType.postImage,
                                  onPressed: () {
                                    if(userAccountProvider.userAccount == null) {
                                      Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                        if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                                      });
                                    }
                                    else {
                                      Dialogs.onPressedCallNow(
                                        context: context,
                                        title: Methods.getText(StringsManager.pleaseEnterYourDataToShowTheAccountantNumber, appProvider.isEnglish).toCapitalized(),
                                        targetId: widget.legalAccountantModel.legalAccountantId,
                                        textAr: 'تم طلب رقم هاتف المحاسب ${widget.legalAccountantModel.name}',
                                        textEn: 'Accountant ${widget.legalAccountantModel.name} phone number has been requested',
                                        transactionType: TransactionType.showLegalAccountantNumber,
                                        targetNumberText: Methods.getText(StringsManager.accountantNumber, appProvider.isEnglish).toCapitalized(),
                                        model: widget.legalAccountantModel,
                                      );
                                    }
                                  },
                                  text: Methods.getText(StringsManager.callNow, appProvider.isEnglish).toTitleCase(),
                                  imageName: ImagesManager.animatedPhoneIc,
                                  imageColor: ColorsManager.primaryColor,
                                  imageSize: SizeManager.s25,
                                  buttonColor: ColorsManager.white,
                                  borderColor: ColorsManager.primaryColor,
                                  textColor: ColorsManager.primaryColor,
                                  height: SizeManager.s40,
                                  borderRadius: SizeManager.s10,
                                ),
                              ),
                              if(widget.legalAccountantModel.isBookingByAppointment && widget.legalAccountantModel.availablePeriods.isNotEmpty) const SizedBox(width: SizeManager.s20),
                              if(widget.legalAccountantModel.isBookingByAppointment && widget.legalAccountantModel.availablePeriods.isNotEmpty) Expanded(
                                child: CustomButton(
                                  buttonType: ButtonType.postImage,
                                  onPressed: () {
                                    if(userAccountProvider.userAccount == null) {
                                      Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                        if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                                      });
                                    }
                                    else {
                                      Dialogs.chooseAppointmentBooking(
                                        context: context,
                                        title: Methods.getText(StringsManager.bookAnAppointmentWithTheAccountant, appProvider.isEnglish).toCapitalized(),
                                        targetId: widget.legalAccountantModel.legalAccountantId,
                                        textAr: 'حجز موعد مع المحاسب ${widget.legalAccountantModel.name} فى الفترة',
                                        textEn: 'Booking an appointment with accountant ${widget.legalAccountantModel.name}',
                                        transactionType: TransactionType.appointmentBookingWithLegalAccountant,
                                        periodsIds: widget.legalAccountantModel.availablePeriods,
                                      );
                                    }
                                  },
                                  text: Methods.getText(StringsManager.appointmentBooking, appProvider.isEnglish).toTitleCase(),
                                  imageName: ImagesManager.animatedAppointmentIc,
                                  imageColor: ColorsManager.white,
                                  imageSize: SizeManager.s25,
                                  height: SizeManager.s40,
                                  borderRadius: SizeManager.s10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SizeManager.s10),
                          if(widget.legalAccountantModel.isBookingByAppointment && widget.legalAccountantModel.availablePeriods.isNotEmpty) Center(
                            child: Text(
                              Methods.getText(StringsManager.pleaseAdhereToTheSpecifiedReservationDate, appProvider.isEnglish).toCapitalized(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const Divider(color: ColorsManager.grey),

                          // Images
                          if(widget.legalAccountantModel.images.isNotEmpty) Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Methods.getText(StringsManager.images, appProvider.isEnglish).toTitleCase(),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(height: SizeManager.s10),
                              Wrap(
                                spacing: SizeManager.s5,
                                runSpacing: SizeManager.s5,
                                children: List.generate(widget.legalAccountantModel.images.length, (index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.legalAccountantModel.images[index], ConstantsManager.directoryArgument: ApiConstants.legalAccountantsGalleryDirectory}),
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      width: SizeManager.s100,
                                      height: SizeManager.s100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(SizeManager.s10),
                                      ),
                                      child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.legalAccountantsGalleryDirectory}/${widget.legalAccountantModel.images[index]}')),
                                    ),
                                  );
                                }),
                              ),
                              const Divider(color: ColorsManager.grey),
                            ],
                          ),

                          // Customers Reviews
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Methods.getText(StringsManager.customersReviews, appProvider.isEnglish).toTitleCase(),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(height: SizeManager.s10),
                              Center(
                                child: Text(
                                  widget.legalAccountantModel.rating.toStringAsFixed(2).endsWith('0') ? widget.legalAccountantModel.rating.toStringAsFixed(1) : widget.legalAccountantModel.rating.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s40, fontWeight: FontWeightManager.black),
                                ),
                              ),
                              const SizedBox(height: SizeManager.s5),
                              Center(
                                child: RatingBar(numberOfStars: widget.legalAccountantModel.rating),
                              ),
                              const SizedBox(height: SizeManager.s5),
                              Center(
                                child: Text(
                                  '${Methods.getText(StringsManager.overallRatingOf, appProvider.isEnglish).toCapitalized()} $totalReviews ${Methods.getText(StringsManager.user, appProvider.isEnglish)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              const SizedBox(height: SizeManager.s10),
                              SizedBox(
                                height: SizeManager.s70,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Methods.getText(StringsManager.excellent, appProvider.isEnglish).toCapitalized(),
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.grey),
                                        ),
                                        Text(
                                          Methods.getText(StringsManager.good, appProvider.isEnglish).toCapitalized(),
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.grey),
                                        ),
                                        Text(
                                          Methods.getText(StringsManager.lessThanExpected, appProvider.isEnglish).toCapitalized(),
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: SizeManager.s20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    color: ColorsManager.grey300,
                                                    width: constraints.maxWidth * 1,
                                                    height: SizeManager.s10,
                                                  ),
                                                  Container(
                                                    color: ColorsManager.green,
                                                    width: constraints.maxWidth * (totalReviews == 0 ? 0 : excellent/totalReviews),
                                                    height: SizeManager.s10,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    color: ColorsManager.grey300,
                                                    width: constraints.maxWidth * 1,
                                                    height: SizeManager.s10,
                                                  ),
                                                  Container(
                                                    color: ColorsManager.orange,
                                                    width: constraints.maxWidth * (totalReviews == 0 ? 0 : good/totalReviews),
                                                    height: SizeManager.s10,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    color: ColorsManager.grey300,
                                                    width: constraints.maxWidth * 1,
                                                    height: SizeManager.s10,
                                                  ),
                                                  Container(
                                                    color: ColorsManager.red700,
                                                    width: constraints.maxWidth * (totalReviews == 0 ? 0 : lessThanExpected/totalReviews),
                                                    height: SizeManager.s10,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Review Button
                    if(isShowReviewButton())  Padding(
                      padding: const EdgeInsets.all(SizeManager.s16),
                      child: Selector<UserAccountProvider, UserAccountModel?>(
                        selector: (context, provider) => provider.userAccount,
                        builder: (context, userAccount, __) {
                          int userReviewIndex = userAccount == null ? -1 : legalAccountantsReviews.indexWhere((element) => element.userAccountId == userAccount.userAccountId);

                          if(userReviewIndex == -1 || userAccount == null) {
                            return CustomButton(
                              buttonType: ButtonType.text,
                              onPressed: () async {
                                if(userAccount == null) {
                                  Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                    if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                                  });
                                }
                                else {
                                  Dialogs.sendReview(
                                    context: context,
                                    targetId: widget.legalAccountantModel.legalAccountantId,
                                    title: '${Methods.getText(StringsManager.rate, appProvider.isEnglish).toTitleCase()} ${widget.legalAccountantModel.name}',
                                    selectTheFeaturesText: Methods.getText(StringsManager.selectTheFeaturesOfAccountant, appProvider.isEnglish).toCapitalized(),
                                    mainCategories: MainCategories.legalAccountants,
                                    features: legalAccountantsFeaturesProvider.legalAccountantsFeatures,
                                  );
                                }
                              },
                              text: '${Methods.getText(StringsManager.rate, appProvider.isEnglish).toTitleCase()} ${widget.legalAccountantModel.name}',
                              borderRadius: SizeManager.s10,
                            );
                          }
                          else {
                            LegalAccountantReviewModel yourReview = legalAccountantsReviews.firstWhere((element) => element.userAccountId == userAccount.userAccountId);
                            return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(SizeManager.s10),
                                decoration: BoxDecoration(
                                  color: ColorsManager.grey100,
                                  borderRadius: BorderRadius.circular(SizeManager.s10),
                                  border: Border.all(color: ColorsManager.grey300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Methods.getText(StringsManager.yourReview, appProvider.isEnglish).toTitleCase(),
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(height: SizeManager.s10),
                                    Row(
                                      children: [
                                        RatingBar(numberOfStars: yourReview.rating),
                                        const SizedBox(width: SizeManager.s5),
                                        Text(
                                          yourReview.rating.toString(),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        const Spacer(),
                                        Text(
                                          Methods.formatDate(context: context, milliseconds: yourReview.createdAt.millisecondsSinceEpoch),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: SizeManager.s10),
                                    Text(
                                      yourReview.comment,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                )
                            );
                          }
                        },
                      ),
                    ),

                    // Reviews
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: SizeManager.s16),
                      itemBuilder: (context, index) => LegalAccountantReviewItem(legalAccountantsReviews: legalAccountantsReviews.toList(), index: index),
                      itemCount: totalReviews >= ConstantsManager.maxNumberToShowReviews ? ConstantsManager.maxNumberToShowReviews : totalReviews,
                    ),
                    if(totalReviews > ConstantsManager.maxNumberToShowReviews) Padding(
                      padding: const EdgeInsets.only(bottom: SizeManager.s16),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.legalAccountantReviewsRoute),
                          child: Text(
                            Methods.getText(StringsManager.viewMoreReviews, appProvider.isEnglish).toTitleCase(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}