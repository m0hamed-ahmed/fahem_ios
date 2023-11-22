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
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/usecases/transactions/transactions/toggle_is_viewed_usecase.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionItem extends StatefulWidget {
  final TransactionModel transactionModel;

  const TransactionItem({super.key, required this.transactionModel});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late AppProvider appProvider;
  late LawyersProvider lawyersProvider;
  late PublicRelationsProvider publicRelationsProvider;
  late LegalAccountantsProvider legalAccountantsProvider;
  late LawyerModel lawyerModel;
  late PublicRelationModel publicRelationModel;
  late LegalAccountantModel legalAccountantModel;
  late TransactionsProvider transactionsProvider;

  void setModel() {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      lawyerModel = lawyersProvider.getLawyerWithId(widget.transactionModel.targetId)!;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      publicRelationModel = publicRelationsProvider.getPublicRelationWithId(widget.transactionModel.targetId)!;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      legalAccountantModel = legalAccountantsProvider.getLegalAccountantWithId(widget.transactionModel.targetId)!;
    }
  }

  Future<void> goToProfile() async {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      Navigator.pushNamed(context, Routes.lawyerDetailsRoute, arguments: {ConstantsManager.lawyerModelArgument: lawyerModel});
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      Navigator.pushNamed(context, Routes.publicRelationDetailsRoute, arguments: {ConstantsManager.publicRelationModelArgument: publicRelationModel});
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      Navigator.pushNamed(context, Routes.legalAccountantDetailsRoute, arguments: {ConstantsManager.legalAccountantModelArgument: legalAccountantModel});
    }
    else if(widget.transactionModel.transactionType == TransactionType.instantConsultation
        || widget.transactionModel.transactionType == TransactionType.secretConsultation
    ) {
      ToggleIsViewedParameters parameters = ToggleIsViewedParameters(
        transactionId: widget.transactionModel.transactionId,
      );
      transactionsProvider.toggleIsViewed(context, parameters).then((_) {
        Navigator.pushNamed(context, Routes.returnToTheTransactionRoute, arguments: {ConstantsManager.transactionModelArgument: widget.transactionModel});
      });
    }
  }

  String getTitle() {
    if(widget.transactionModel.transactionType == TransactionType.instantConsultation) {
      return appProvider.isEnglish ? 'booking an instant consultation' : 'حجز استشارة فورية';
    }
    else if(widget.transactionModel.transactionType == TransactionType.secretConsultation) {
      return appProvider.isEnglish ? 'booking an secret consultation' : 'حجز استشارة سرية';
    }
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber) {
      return appProvider.isEnglish ? 'lawyer phone number requested' : 'تم طلب رقم هاتف المحامى';
    }
    else if(widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer) {
      return appProvider.isEnglish ? 'booking an appointment with a lawyer' : 'حجز موعد مع المحامى';
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber) {
      return appProvider.isEnglish ? 'public relation phone number requested' : 'تم طلب رقم هاتف علاقات عامة';
    }
    else if(widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation) {
      return appProvider.isEnglish ? 'booking an appointment with a public relation' : 'حجز موعد مع علاقات عامة';
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber) {
      return appProvider.isEnglish ? 'accountant phone number requested' : 'تم طلب رقم هاتف المحاسب';
    }
    else if(widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant) {
      return appProvider.isEnglish ? 'booking an appointment with the accountant' : 'حجز موعد مع المحاسب';
    }
    else {
      return ConstantsManager.empty;
    }
  }
  
  Widget getImage() {
    if(widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
        || widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
    ) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: getImageArgument(), ConstantsManager.directoryArgument: getDirectoryArgument()}),
        child: SizedBox(
          width: SizeManager.s70,
          height: SizeManager.s70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SizeManager.s40),
            child: CachedNetworkImageWidget(image: getTargetImage()),
          ),
        ),
      );
    }
    else {
      return SizedBox(
        width: SizeManager.s70,
        height: SizeManager.s70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeManager.s40),
          child: Image.asset(ImagesManager.logo),
        ),
      );
    }
  }

  String getTargetImage() {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      return ApiConstants.fileUrl(fileName: '${ApiConstants.lawyersDirectory}/${lawyerModel.personalImage}');
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      return ApiConstants.fileUrl(fileName: '${ApiConstants.publicRelationsDirectory}/${publicRelationModel.personalImage}');
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      return ApiConstants.fileUrl(fileName: '${ApiConstants.legalAccountantsDirectory}/${legalAccountantModel.personalImage}');
    }
    else {
      return ConstantsManager.empty;
    }
  }

  String getImageArgument() {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      return lawyerModel.personalImage;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      return publicRelationModel.personalImage;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      return legalAccountantModel.personalImage;
    }
    else {
      return ConstantsManager.empty;
    }
  }

  String getDirectoryArgument() {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      return ApiConstants.lawyersDirectory;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      return ApiConstants.publicRelationsDirectory;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      return ApiConstants.legalAccountantsDirectory;
    }
    else {
      return ConstantsManager.empty;
    }
  }

  String getTargetName() {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      return lawyerModel.name;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      return publicRelationModel.name;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      return legalAccountantModel.name;
    }
    else if(widget.transactionModel.transactionType == TransactionType.instantConsultation
    ) {
      return Methods.getText(StringsManager.instantConsultation, appProvider.isEnglish).toCapitalized();
    }
    else if(widget.transactionModel.transactionType == TransactionType.secretConsultation
    ) {
      return Methods.getText(StringsManager.secretConsultation, appProvider.isEnglish).toCapitalized();
    }
    else {
      return ConstantsManager.empty;
    }
  }

  String getTargetJobTitle() {
    if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
    ) {
      return lawyerModel.jobTitle;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
    ) {
      return publicRelationModel.jobTitle;
    }
    else if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
        || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
    ) {
      return legalAccountantModel.jobTitle;
    }
    else if(widget.transactionModel.transactionType == TransactionType.instantConsultation
    ) {
      if(widget.transactionModel.isDoneInstantConsultation != null &&  widget.transactionModel.isDoneInstantConsultation == true) {
        return Methods.getText(StringsManager.consultationClosed, appProvider.isEnglish).toCapitalized();
      }
      else {
        return Methods.getText(StringsManager.consultationIsAvailable, appProvider.isEnglish).toCapitalized();
      }
    }
    else {
      return ConstantsManager.empty;
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
    publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);
    legalAccountantsProvider = Provider.of<LegalAccountantsProvider>(context, listen: false);
    transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    setModel();
    return Container(
      color: widget.transactionModel.isViewed ? null : ColorsManager.comment2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => goToProfile(),
          child: Padding(
            padding: const EdgeInsets.all(SizeManager.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: getTitle().toCapitalized(),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: ColorsManager.green,
                          fontWeight: widget.transactionModel.isViewed ? FontWeightManager.semiBold : FontWeightManager.black,
                        ),
                      ),
                      const TextSpan(text: ConstantsManager.space),
                      TextSpan(
                        text: Methods.formatDate(context: context, milliseconds: widget.transactionModel.createdAt.millisecondsSinceEpoch),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: widget.transactionModel.isViewed ? FontWeightManager.semiBold : FontWeightManager.black),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorsManager.grey),
                Row(
                  children: [
                    getImage(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(SizeManager.s8),
                        height: SizeManager.s80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              getTargetName(),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: widget.transactionModel.isViewed ? FontWeightManager.semiBold : FontWeightManager.black),
                            ),
                            if(widget.transactionModel.transactionType != TransactionType.secretConsultation) Text(
                              getTargetJobTitle(),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: widget.transactionModel.isViewed ? FontWeightManager.semiBold : FontWeightManager.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SizeManager.s10),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonType: ButtonType.postImage,
                        onPressed: () {
                          ToggleIsViewedParameters parameters = ToggleIsViewedParameters(
                            transactionId: widget.transactionModel.transactionId,
                          );
                          transactionsProvider.toggleIsViewed(context, parameters).then((value) {
                            if(widget.transactionModel.transactionType == TransactionType.instantConsultation
                                || widget.transactionModel.transactionType == TransactionType.secretConsultation
                            ) {
                              Navigator.pushNamed(context, Routes.returnToTheTransactionRoute, arguments: {ConstantsManager.transactionModelArgument: widget.transactionModel});
                            }
                            if(widget.transactionModel.transactionType == TransactionType.showLawyerNumber
                                || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLawyer
                            ) {
                              Dialogs.showLawyerInformationDialog(
                                context: context,
                                lawyerModel: lawyerModel,
                                transactionType: widget.transactionModel.transactionType,
                                transactionModel: widget.transactionModel,
                              );
                            }
                            if(widget.transactionModel.transactionType == TransactionType.showPublicRelationNumber
                                || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation
                            ) {
                              Dialogs.showPublicRelationInformationDialog(
                                context: context,
                                publicRelationModel: publicRelationModel,
                                transactionType: widget.transactionModel.transactionType,
                                transactionModel: widget.transactionModel,
                              );
                            }
                            if(widget.transactionModel.transactionType == TransactionType.showLegalAccountantNumber
                                || widget.transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant
                            ) {
                              Dialogs.showLegalAccountantInformationDialog(
                                context: context,
                                legalAccountantModel: legalAccountantModel,
                                transactionType: widget.transactionModel.transactionType,
                                transactionModel: widget.transactionModel,
                              );
                            }
                          });
                        },
                        text: Methods.getText(StringsManager.returnToTheTransaction, appProvider.isEnglish).toTitleCase(),
                        imageName: ImagesManager.returnToTheTransactionIc,
                        height: SizeManager.s35,
                        borderRadius: SizeManager.s10,
                        buttonColor: ColorsManager.primaryColor,
                        borderColor: ColorsManager.primaryColor,
                        imageColor: ColorsManager.white,
                      ),
                    ),
                    const SizedBox(width: SizeManager.s10),
                    Expanded(
                      child: CustomButton(
                        buttonType: ButtonType.postImage,
                        onPressed: () => Navigator.pushNamed(context, Routes.chatRoomRoute),
                        text: Methods.getText(StringsManager.help, appProvider.isEnglish).toTitleCase(),
                        imageName: ImagesManager.helpOutlineIc,
                        height: SizeManager.s35,
                        borderRadius: SizeManager.s10,
                        imageColor: ColorsManager.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}