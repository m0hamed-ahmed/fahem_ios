import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/services/kashier_payment_service.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/core/utils/validator.dart';
import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/data/data_source/static/period_data.dart';
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/data/models/lawyers/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/data/models/static/period_model.dart';
import 'package:fahem/data/models/transactions/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/domain/usecases/lawyers/lawyers_reviews/insert_lawyer_review_usecase.dart';
import 'package:fahem/domain/usecases/legal_accountants/legal_accountants_reviews/insert_legal_accountant_review_usecase.dart';
import 'package:fahem/domain/usecases/public_relations/public_relations_reviews/insert_public_relation_review_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/insert_transaction_usecase.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/instant_consultations_comments_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/widgets/instant_consultation_comment_item.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_reviews/controllers/lawyers_reviews_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/controllers/public_relations_reviews_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating_bar;

class Dialogs {

  static Future<void> showBottomSheet({required BuildContext context, required Widget child, Function? thenMethod}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      barrierColor: ColorsManager.black.withOpacity(0.8),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(SizeManager.s30),
          topEnd: Radius.circular(SizeManager.s30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Directionality(
            textDirection: Methods.getDirection(appProvider.isEnglish),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: SizeManager.s16, horizontal: SizeManager.s24),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) => thenMethod != null ? thenMethod() : null);
  }

  static Future<void> _showBottomSheet({required BuildContext context, required Widget child, Function? thenMethod}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      barrierColor: ColorsManager.black.withOpacity(0.8),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(SizeManager.s30),
          topEnd: Radius.circular(SizeManager.s30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Directionality(
            textDirection: Methods.getDirection(appProvider.isEnglish),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: SizeManager.s16, horizontal: SizeManager.s24),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) => thenMethod != null ? thenMethod() : null);
  }
  
  static Future<bool> showBottomSheetConfirmation({required BuildContext context, required String message, Function? thenMethod}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    bool result = false;

    await Dialogs._showBottomSheet(
      context: context,
      thenMethod: thenMethod,
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonType: ButtonType.text,
                  onPressed: () {
                    Navigator.pop(context);
                    result = true;
                  },
                  text: Methods.getText(StringsManager.ok, appProvider.isEnglish).toUpperCase(),
                  height: SizeManager.s40,
                ),
              ),
              const SizedBox(width: SizeManager.s20),
              Expanded(
                child: CustomButton(
                  buttonType: ButtonType.text,
                  onPressed: () {
                    Navigator.pop(context);
                    result = false;
                  },
                  text: Methods.getText(StringsManager.cancel, appProvider.isEnglish).toUpperCase(),
                  height: SizeManager.s40,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Future.value(result);
  }

  static Widget messageWidget({required BuildContext context, required String message, ShowMessage showMessage = ShowMessage.failure}) {
    return Column(
      children: [
        Lottie.asset(
          showMessage == ShowMessage.success ? ImagesManager.animatedSuccess : ImagesManager.animatedFailure,
          width: showMessage == ShowMessage.success ? SizeManager.s200 : SizeManager.s150,
          height: showMessage == ShowMessage.success ? SizeManager.s200 : SizeManager.s150,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: SizeManager.s16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: showMessage == ShowMessage.success ? ColorsManager.success : ColorsManager.failure,
            fontSize: SizeManager.s20,
            fontWeight: FontWeightManager.bold,
          ),
        ),
      ],
    );
  }

  static Future<void> showBottomSheetMessage({
    required BuildContext context,
    required String message,
    ShowMessage showMessage = ShowMessage.failure,
    Function? thenMethod,
    int bottomSheetClosedDuration = ConstantsManager.bottomSheetClosedDuration,
  }) async {
    Timer timer = Timer(Duration(seconds: bottomSheetClosedDuration), () => Navigator.pop(context));

    return Dialogs._showBottomSheet(
      context: context,
      thenMethod: () {
        if(thenMethod != null) thenMethod();
        timer.cancel();
      },
      child: messageWidget(context: context, message: message, showMessage: showMessage),
    );
  }

  static Future<void> failureOccurred(BuildContext context, Failure failure, {int bottomSheetClosedDuration = ConstantsManager.bottomSheetClosedDuration}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Dialogs.showBottomSheetMessage(
      context: context,
      message: appProvider.isEnglish ? failure.messageEn.toCapitalized() : failure.messageAr.toCapitalized(),
      bottomSheetClosedDuration: bottomSheetClosedDuration,
    );
  }

  static Future<void> showPermissionDialog({required BuildContext context, required String title, required String message}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Dialogs._showBottomSheet(
      context: context,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(ImagesManager.location, height: SizeManager.s200),
          ),
          Text(
            Methods.getText(title, appProvider.isEnglish).toCapitalized(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            Methods.getText(message, appProvider.isEnglish).toCapitalized(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18),
          ),
          const SizedBox(height: SizeManager.s10),
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            buttonType: ButtonType.text,
            text: Methods.getText(StringsManager.ok, appProvider.isEnglish).toUpperCase(),
          ),
        ],
      ),
    );
  }

  static Future<bool> showUpdateDialog(BuildContext context, String title, String text, {bool isMustUpdate = false}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return (
      await (showDialog(
        context: context,
        barrierDismissible: !isMustUpdate,
        builder: (context) => WillPopScope(
          onWillPop: () async => !isMustUpdate,
          child: Directionality(
            textDirection: Methods.getDirection(appProvider.isEnglish),
            child: AlertDialog(
              backgroundColor: ColorsManager.grey1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager.s10)),
              title: Text(
                Methods.getText(title, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
              ),
              titlePadding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, top: SizeManager.s16, bottom: SizeManager.s8),
              content: Text(
                Methods.getText(text, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              contentPadding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s8),
              actionsPadding: const EdgeInsets.all(SizeManager.s16),
              actions: [
                if(!isMustUpdate) TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    backgroundColor: ColorsManager.grey300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager.s10)),
                  ),
                  child: Text(
                    Methods.getText(StringsManager.updateLater, appProvider.isEnglish).toCapitalized(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeightManager.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    backgroundColor: ColorsManager.red700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager.s10)),
                  ),
                  child: Text(
                    Methods.getText(StringsManager.updateNow, appProvider.isEnglish).toCapitalized(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ))
    ) ?? false;
  }

  static Future<GovernmentModel?> showBottomSheetGovernorates({required BuildContext context, Function? thenMethod}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    GovernmentModel? governmentModel;
    bool isLoading = false;

    await Dialogs._showBottomSheet(
      context: context,
      thenMethod: thenMethod,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AbsorbPointerWidget(
              absorbing: isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      Methods.getText(StringsManager.chooseGovernment, appProvider.isEnglish).toTitleCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                    ),
                  ),
                  const SizedBox(height: SizeManager.s16),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              if(governoratesData[index].governoratesMode == GovernoratesMode.currentLocation) {
                                setState(() => isLoading = true);
                                await Methods.checkPermissionAndGetCurrentPosition(context).then((position) {
                                  if(position != null) {
                                    governoratesData[index].latitude = position.latitude;
                                    governoratesData[index].longitude = position.longitude;
                                    governmentModel = governoratesData[index];
                                    Navigator.pop(context);
                                  }
                                  else {
                                    setState(() => isLoading = false);
                                  }
                                });
                              }
                              else {
                                governmentModel = governoratesData[index];
                                Navigator.pop(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(SizeManager.s16),
                              child: Text(
                                appProvider.isEnglish ? governoratesData[index].nameEn : governoratesData[index].nameAr,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      itemCount: governoratesData.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    return Future.value(governmentModel);
  }

  static void onPressedCallNow({
    required BuildContext context,
    required String title,
    required int targetId,
    required String textAr,
    required String textEn,
    required TransactionType transactionType,
    required String targetNumberText,
    required dynamic model,
  }) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    TransactionsProvider transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    final String name = '${userAccountProvider.userAccount!.firstName} ${userAccountProvider.userAccount!.familyName}';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController textEditingControllerName = TextEditingController(text: name);
    final TextEditingController textEditingControllerPhoneNumber = TextEditingController(text: userAccountProvider.userAccount!.phoneNumber);
    bool isLoading = false;
    bool isDataValid = false;

    Dialogs._showBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Image.asset(ImagesManager.enterData, width: SizeManager.s350, height: SizeManager.s350),
                !isDataValid ? AbsorbPointerWidget(
                  absorbing: isLoading,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                        ),
                        const SizedBox(height: SizeManager.s40),
                        CustomTextFormField(
                          controller: textEditingControllerName,
                          textInputAction: TextInputAction.next,
                          textDirection: Methods.getDirection(appProvider.isEnglish),
                          labelText: '${Methods.getText(StringsManager.name, appProvider.isEnglish).toCapitalized()} *',
                          prefixIcon: const Icon(Icons.person_outlined, color: ColorsManager.primaryColor),
                          suffixIcon: IconButton(
                            onPressed: () => textEditingControllerName.clear(),
                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                          ),
                          validator: (val) {
                            if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                            return null;
                          },
                        ),
                        const SizedBox(height: SizeManager.s30),
                        CustomTextFormField(
                          controller: textEditingControllerPhoneNumber,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          labelText: '${Methods.getText(StringsManager.mobileNumber, appProvider.isEnglish).toCapitalized()} *',
                          prefixIcon: const Icon(Icons.phone, color: ColorsManager.primaryColor),
                          suffixIcon: IconButton(
                            onPressed: () => textEditingControllerPhoneNumber.clear(),
                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                          ),
                          validator: (val) {
                            if(val!.isEmpty) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                            else if(!Validator.isPhoneNumberValid(val)) {return Methods.getText(StringsManager.phoneNumberIsIncorrect, appProvider.isEnglish).toCapitalized();}
                            return null;
                          },
                        ),
                        const SizedBox(height: SizeManager.s40),
                        CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if(formKey.currentState!.validate()) {
                              setState(() {isLoading = true;});

                              // Insert Transaction
                              TransactionModel transactionModel = TransactionModel(
                                transactionId: 0,
                                targetId: targetId,
                                userAccountId: userAccountProvider.userAccount!.userAccountId,
                                name: textEditingControllerName.text.trim(),
                                phoneNumber: textEditingControllerPhoneNumber.text.trim(),
                                emailAddress: userAccountProvider.userAccount!.emailAddress ?? 'null',
                                textAr: textAr,
                                textEn: textEn,
                                transactionType: transactionType,
                                isViewed: false,
                                createdAt: DateTime.now(),
                              );
                              InsertTransactionParameters parameters = InsertTransactionParameters(
                                transactionModel: transactionModel,
                              );
                              Either<Failure, TransactionModel> response = await transactionsProvider.insertTransactionImpl(parameters);
                              response.fold((failure) async {
                                setState(() {isLoading = false;});
                                Dialogs.failureOccurred(context, failure);
                              }, (transaction) async {
                                CacheHelper.setData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED, value: false);
                                NotificationService.pushNotification(topic: '$targetId${transactionsProvider.getKeyword(transactionType)}', title: 'طلب رقم الموبايل', body: 'العميل $name قام بطلب رقم الموبايل');
                                setState(() {isLoading = false;});
                                transactionsProvider.addTransaction(transaction);
                                setState(() => isDataValid = true);
                              });
                            }
                          },
                          text: Methods.getText(StringsManager.showTheNumber, appProvider.isEnglish).toTitleCase(),
                        ),
                      ],
                    ),
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      targetNumberText,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    Text(
                      model.phoneNumber,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s30, fontWeight: FontWeightManager.black),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonType: ButtonType.postImage,
                            onPressed: () => Methods.openUrl('tel:${model.phoneNumber}'),
                            text: Methods.getText(StringsManager.callNow, appProvider.isEnglish).toTitleCase(),
                            imageName: ImagesManager.animatedPhoneIc,
                            imageColor: ColorsManager.primaryColor,
                            imageSize: SizeManager.s25,
                            buttonColor: ColorsManager.white,
                            borderColor: ColorsManager.primaryColor,
                            textColor: ColorsManager.primaryColor,
                            height: SizeManager.s40,
                          ),
                        ),
                        const SizedBox(width: SizeManager.s20),
                        Expanded(
                          child: CustomButton(
                            buttonType: ButtonType.postImage,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: model.phoneNumber));
                              Dialogs.showBottomSheetMessage(
                                context: context,
                                message: Methods.getText(StringsManager.theNumberHasBeenCopied, appProvider.isEnglish).toCapitalized(),
                                showMessage: ShowMessage.success,
                              );
                            },
                            text: Methods.getText(StringsManager.copyTheNumber, appProvider.isEnglish).toTitleCase(),
                            imageName: ImagesManager.animatedCopyIc,
                            imageColor: ColorsManager.white,
                            imageSize: SizeManager.s25,
                            height: SizeManager.s40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static void chooseAppointmentBooking({
    required BuildContext context,
    required String title,
    required int targetId,
    required String textAr,
    required String textEn,
    required TransactionType transactionType,
    required List<String> periodsIds,
  }) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    TransactionsProvider transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    DateTime date = DateTime.now();
    String? period;
    bool isLoading = false;
    bool isDone = false;
    bool isValidate = false;
    Timer? timer;
    final String name = '${userAccountProvider.userAccount!.firstName} ${userAccountProvider.userAccount!.familyName}';
    List<PeriodModel> selectedPeriods = [];
    for(int i=0; i<periodsIds.length; i++) {
      int index = periodsData.indexWhere((element) => element.periodId == periodsIds[i]);
      selectedPeriods.add(periodsData[index]);
    }

    Dialogs._showBottomSheet(
      context: context,
      thenMethod: () => timer?.cancel(),
      child: StatefulBuilder(
        builder: (context, setState) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: !isDone ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                  ),
                ),
                const SizedBox(height: SizeManager.s20),
                Text(
                  Methods.getText(StringsManager.chooseTheDate, appProvider.isEnglish).toCapitalized(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                ),
                const SizedBox(height: SizeManager.s10),
                Container(
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(SizeManager.s10),
                    border: Border.all(color: ColorsManager.grey300),
                  ),
                  child: CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                    onDateChanged: (value) => date = value,
                  ),
                ),
                const SizedBox(height: SizeManager.s20),
                Text(
                  Methods.getText(StringsManager.chooseThePeriod, appProvider.isEnglish).toCapitalized(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Material(
                    color: Colors.transparent,
                    child: RadioListTile(
                      value: selectedPeriods[index].periodId,
                      groupValue: period,
                      onChanged: (val) {
                        setState(() {
                          period = val;
                          isValidate = true;
                        });
                      },
                      title: Text(
                        appProvider.isEnglish ? selectedPeriods[index].nameEn : selectedPeriods[index].nameAr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  itemCount: selectedPeriods.length,
                ),
                const SizedBox(height: SizeManager.s20),
                IgnorePointer(
                  ignoring: !isValidate,
                  child: CustomButton(
                    buttonType: ButtonType.text,
                    onPressed: () async {
                      Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.areYouSureAboutTheProcessOfBookingAConsultation, appProvider.isEnglish).toCapitalized()).then((value) async {
                        if(value) {
                          setState(() => isLoading = true);

                          // Insert Transaction
                          TransactionModel transactionModel = TransactionModel(
                            transactionId: 0,
                            targetId: targetId,
                            userAccountId: userAccountProvider.userAccount!.userAccountId,
                            name: name,
                            phoneNumber: userAccountProvider.userAccount!.phoneNumber,
                            emailAddress: userAccountProvider.userAccount!.emailAddress ?? 'null',
                            textAr: '$textAr ${selectedPeriods.firstWhere((element) => element.periodId == period).nameAr}',
                            textEn: '$textEn ${selectedPeriods.firstWhere((element) => element.periodId == period).nameEn}',
                            bookingDateTimeStamp: date.millisecondsSinceEpoch.toString(),
                            transactionType: transactionType,
                            isViewed: false,
                            createdAt: DateTime.now(),
                          );
                          InsertTransactionParameters parameters = InsertTransactionParameters(
                            transactionModel: transactionModel,
                          );
                          Either<Failure, TransactionModel> response = await transactionsProvider.insertTransactionImpl(parameters);
                          response.fold((failure) async {
                            setState(() {isLoading = false;});
                            Dialogs.failureOccurred(context, failure);
                          }, (transaction) async {
                            CacheHelper.setData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED, value: false);
                            NotificationService.pushNotification(topic: '$targetId${transactionsProvider.getKeyword(transactionType)}', title: 'حجز ميعاد', body: 'العميل $name قام بحجز ميعاد بتاريخ ${intl.DateFormat.yMMMMd('ar_EG').format(DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch))} فى الفترة ${periodsData.firstWhere((element) => element.periodId == period).nameAr}');
                            transactionsProvider.addTransaction(transaction);
                            setState(() {
                              isLoading = false;
                              isDone = true;
                            });
                            timer = Timer(const Duration(seconds: ConstantsManager.bottomSheetClosedDuration), () => Navigator.pop(context));
                          });
                        }
                      });
                    },
                    text: Methods.getText(StringsManager.book, appProvider.isEnglish).toTitleCase(),
                    buttonColor: isValidate ? ColorsManager.secondaryColor : ColorsManager.secondaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ) : messageWidget(
              context: context,
              message: Methods.getText(StringsManager.consultationBooked, appProvider.isEnglish).toCapitalized(),
              showMessage: ShowMessage.success,
            ),
          );
        },
      ),
    );
  }

  static Future<void> sendReview({
    required BuildContext context,
    required int targetId,
    required String title,
    required String selectTheFeaturesText,
    required MainCategories mainCategories,
    required List<dynamic> features,
  }) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController textEditingControllerReview = TextEditingController();
    double myRating = 0;
    List<dynamic> selectedFeatures = [];
    bool isLoading = false;
    bool isDone = false;
    Timer? timer;

    Dialogs._showBottomSheet(
      context: context,
      thenMethod: () => timer?.cancel(),
      child: StatefulBuilder(
        builder: (context, setState) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: Container(
              child: !isDone ? Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                    ),
                    const SizedBox(height: SizeManager.s20),

                    CustomTextFormField(
                      controller: textEditingControllerReview,
                      textInputAction: TextInputAction.done,
                      textDirection: Methods.getDirection(appProvider.isEnglish),
                      labelText: '${Methods.getText(StringsManager.comment, appProvider.isEnglish).toCapitalized()} *',
                      prefixIcon: const Icon(Icons.comment, color: ColorsManager.primaryColor),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            textEditingControllerReview.clear();
                          });
                        },
                        icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                      ),
                      validator: (val) {
                        if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                        return null;
                      },
                      onChanged: (val) => setState(() {}),
                    ),
                    const SizedBox(height: SizeManager.s20),

                    Center(
                      child: Column(
                        children: [
                          rating_bar.RatingBar.builder(
                            allowHalfRating: true,
                            itemBuilder: (context, _) => const Icon(Icons.star, color: ColorsManager.amber),
                            updateOnDrag: true,
                            onRatingUpdate: (rating) => setState(() => myRating = rating),
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Text(
                            Methods.getRatingText(context: context, rating: myRating),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: myRating <=2 ? ColorsManager.red700 : myRating <= 3 ? ColorsManager.black : ColorsManager.green,
                              fontWeight: FontWeightManager.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SizeManager.s20),

                    if(features.isNotEmpty) Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectTheFeaturesText,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                        ),
                        const SizedBox(height: SizeManager.s5),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: SizeManager.s5,
                            runSpacing: SizeManager.s5,
                            children: List.generate(features.length, (index) {
                              return InkWell(
                                onTap: () {
                                  if(selectedFeatures.contains(features[index])) {
                                    setState(() {
                                      selectedFeatures.removeWhere((element) => element == features[index]);
                                    });
                                  }
                                  else {
                                    setState(() {
                                      selectedFeatures.add(features[index]);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: SizeManager.s10, vertical: SizeManager.s5),
                                  decoration: BoxDecoration(
                                    color: selectedFeatures.contains(features[index]) ? ColorsManager.primaryColor : ColorsManager.white,
                                    border: Border.all(
                                      color: selectedFeatures.contains(features[index]) ? ColorsManager.primaryColor : ColorsManager.grey300,
                                    ),
                                    borderRadius: BorderRadius.circular(SizeManager.s5),
                                  ),
                                  child: Text(
                                    appProvider.isEnglish ? features[index].featureEn : features[index].featureAr,
                                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                      color: selectedFeatures.contains(features[index]) ? ColorsManager.white : ColorsManager.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: SizeManager.s20),
                      ],
                    ),

                    Opacity(
                      opacity: textEditingControllerReview.text.trim().isEmpty ? 0.5 : 1,
                      child: IgnorePointer(
                        ignoring: textEditingControllerReview.text.trim().isEmpty,
                        child: CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if(formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              if(mainCategories == MainCategories.lawyers) {
                                LawyersReviewsProvider lawyersReviewsProvider = Provider.of<LawyersReviewsProvider>(context, listen: false);
                                LawyerReviewModel lawyerReviewModel = LawyerReviewModel(
                                  lawyerReviewId: 0,
                                  lawyerId: targetId,
                                  userAccountId: userAccountProvider.userAccount!.userAccountId,
                                  firstName: userAccountProvider.userAccount!.firstName,
                                  familyName: userAccountProvider.userAccount!.familyName,
                                  comment: textEditingControllerReview.text.trim(),
                                  rating: myRating,
                                  featuresAr: selectedFeatures.map((e) => e.featureAr.toString()).toList(),
                                  featuresEn: selectedFeatures.map((e) => e.featureEn.toString()).toList(),
                                  createdAt: DateTime.now(),
                                );
                                InsertLawyerReviewParameters parameter = InsertLawyerReviewParameters(
                                  lawyerReviewModel: lawyerReviewModel,
                                );
                                Either<Failure, LawyerReviewModel> response = await lawyersReviewsProvider.insertLawyerReviewImpl(parameter);
                                response.fold((failure) {
                                  setState(() => isLoading = false);
                                  Dialogs.failureOccurred(context, failure);
                                }, (lawyerReview) {
                                  NotificationService.pushNotification(topic: '$targetId${ConstantsManager.fahemBusinessLawyersKeyword}', title: 'تقييم', body: textEditingControllerReview.text.trim());
                                  lawyersReviewsProvider.lawyersReviews.insert(0, lawyerReview);
                                  lawyersReviewsProvider.changeLawyersReviews(lawyersReviewsProvider.lawyersReviews);
                                  setState(() {
                                    isLoading = false;
                                    isDone = true;
                                  });
                                  timer = Timer(const Duration(seconds: ConstantsManager.bottomSheetClosedDuration), () => Navigator.pop(context));
                                });
                              }
                              else if(mainCategories == MainCategories.publicRelations) {
                                PublicRelationsReviewsProvider publicRelationsReviewsProvider = Provider.of<PublicRelationsReviewsProvider>(context, listen: false);
                                PublicRelationReviewModel publicRelationReviewModel = PublicRelationReviewModel(
                                  publicRelationReviewId: 0,
                                  publicRelationId: targetId,
                                  userAccountId: userAccountProvider.userAccount!.userAccountId,
                                  firstName: userAccountProvider.userAccount!.firstName,
                                  familyName: userAccountProvider.userAccount!.familyName,
                                  comment: textEditingControllerReview.text.trim(),
                                  rating: myRating,
                                  featuresAr: selectedFeatures.map((e) => e.featureAr.toString()).toList(),
                                  featuresEn: selectedFeatures.map((e) => e.featureEn.toString()).toList(),
                                  createdAt: DateTime.now(),
                                );
                                InsertPublicRelationReviewParameters parameter = InsertPublicRelationReviewParameters(
                                  publicRelationReviewModel: publicRelationReviewModel,
                                );
                                Either<Failure, PublicRelationReviewModel> response = await publicRelationsReviewsProvider.insertPublicRelationReviewImpl(parameter);
                                response.fold((failure) {
                                  setState(() => isLoading = false);
                                  Dialogs.failureOccurred(context, failure);
                                }, (publicRelationReview) {
                                  NotificationService.pushNotification(topic: '$targetId${ConstantsManager.fahemBusinessPublicRelationsKeyword}', title: 'تقييم', body: textEditingControllerReview.text.trim());
                                  publicRelationsReviewsProvider.publicRelationsReviews.insert(0, publicRelationReview);
                                  publicRelationsReviewsProvider.changePublicRelationsReviews(publicRelationsReviewsProvider.publicRelationsReviews);
                                  setState(() {
                                    isLoading = false;
                                    isDone = true;
                                  });
                                  timer = Timer(const Duration(seconds: ConstantsManager.bottomSheetClosedDuration), () => Navigator.pop(context));
                                });
                              }
                              else if(mainCategories == MainCategories.legalAccountants) {
                                LegalAccountantsReviewsProvider legalAccountantsReviewsProvider = Provider.of<LegalAccountantsReviewsProvider>(context, listen: false);
                                LegalAccountantReviewModel legalAccountantReviewModel = LegalAccountantReviewModel(
                                  legalAccountantReviewId: 0,
                                  legalAccountantId: targetId,
                                  userAccountId: userAccountProvider.userAccount!.userAccountId,
                                  firstName: userAccountProvider.userAccount!.firstName,
                                  familyName: userAccountProvider.userAccount!.familyName,
                                  comment: textEditingControllerReview.text.trim(),
                                  rating: myRating,
                                  featuresAr: selectedFeatures.map((e) => e.featureAr.toString()).toList(),
                                  featuresEn: selectedFeatures.map((e) => e.featureEn.toString()).toList(),
                                  createdAt: DateTime.now(),
                                );
                                InsertLegalAccountantReviewParameters parameter = InsertLegalAccountantReviewParameters(
                                  legalAccountantReviewModel: legalAccountantReviewModel,
                                );
                                Either<Failure, LegalAccountantReviewModel> response = await legalAccountantsReviewsProvider.insertLegalAccountantReviewImpl(parameter);
                                response.fold((failure) {
                                  setState(() => isLoading = false);
                                  Dialogs.failureOccurred(context, failure);
                                }, (legalAccountantReview) {
                                  NotificationService.pushNotification(topic: '$targetId${ConstantsManager.fahemBusinessLegalAccountantsKeyword}', title: 'تقييم', body: textEditingControllerReview.text.trim());
                                  legalAccountantsReviewsProvider.legalAccountantsReviews.insert(0, legalAccountantReview);
                                  legalAccountantsReviewsProvider.changeLegalAccountantsReviews(legalAccountantsReviewsProvider.legalAccountantsReviews);
                                  setState(() {
                                    isLoading = false;
                                    isDone = true;
                                  });
                                  timer = Timer(const Duration(seconds: ConstantsManager.bottomSheetClosedDuration), () => Navigator.pop(context));
                                });
                              }
                            }
                          },
                          text: Methods.getText(StringsManager.send, appProvider.isEnglish).toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : messageWidget(
                context: context,
                message: Methods.getText(StringsManager.yourRatingHasBeenSentSuccessfully, appProvider.isEnglish).toCapitalized(),
                showMessage: ShowMessage.success,
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> addMoneyToWallet({required BuildContext context}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController textEditingControllerBalance = TextEditingController();

    Dialogs._showBottomSheet(
      context: context,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Methods.getText(StringsManager.addMoneyToTheWallet, appProvider.isEnglish).toCapitalized(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
            ),
            const SizedBox(height: SizeManager.s20),
            CustomTextFormField(
              controller: textEditingControllerBalance,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              labelText: '${Methods.getText(StringsManager.balance, appProvider.isEnglish).toCapitalized()} *',
              prefixIcon: const Icon(Icons.monetization_on_outlined, color: ColorsManager.primaryColor),
              suffixIcon: IconButton(
                onPressed: () => textEditingControllerBalance.clear(),
                icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
              ),
              validator: (val) {
                if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                else if(!Validator.isIntegerNumber(val)) {return Methods.getText(StringsManager.typeAIntegerNumber, appProvider.isEnglish).toCapitalized();}
                else if(int.parse(val) <= 0) {return Methods.getText(StringsManager.enterANumberGreaterThan0, appProvider.isEnglish).toCapitalized();}
                return null;
              },
            ),
            const SizedBox(height: SizeManager.s20),
            CustomButton(
              buttonType: ButtonType.text,
              onPressed: () async {
                UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
                String name = '${userAccountProvider.userAccount!.firstName} ${userAccountProvider.userAccount!.familyName}';
                int balance = int.parse(textEditingControllerBalance.text.trim());

                if(formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  await KashierPaymentService.chargeWallet(
                    context: context,
                    customerName: name,
                    totalAmount: balance,
                    onPaymentStatusPaid: () {
                      walletProvider.onPressedAddMoneyToTheWallet(context, balance);
                    },
                  );
                }
              },
              text: Methods.getText(StringsManager.add, appProvider.isEnglish).toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showLawyerInformationDialog({
    required BuildContext context,
    required LawyerModel lawyerModel,
    required TransactionType transactionType,
    required TransactionModel transactionModel,
  }) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    Dialogs._showBottomSheet(
      context: context,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: SizeManager.s80,
            height: SizeManager.s80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeManager.s40),
              child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.lawyersDirectory}/${lawyerModel.personalImage}')),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(SizeManager.s8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    lawyerModel.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                  ),
                  Text(
                    lawyerModel.jobTitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeightManager.black),
                  ),
                  const SizedBox(height: SizeManager.s10),
                  Text(
                    '${Methods.getText(StringsManager.theLocation, appProvider.isEnglish).toCapitalized()}: ${lawyerModel.address}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                  ),
                  Text(
                    '${Methods.getText(StringsManager.phoneNumber, appProvider.isEnglish).toCapitalized()}: ${lawyerModel.phoneNumber}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                  ),
                  Text(
                    '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${lawyerModel.consultationPrice} ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                  ),
                  Text(
                    '${Methods.getText(StringsManager.theTransaction, appProvider.isEnglish).toCapitalized()}: ${appProvider.isEnglish ? transactionModel.textEn : transactionModel.textAr}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                  ),
                  if(transactionType == TransactionType.appointmentBookingWithLawyer) Text(
                    '${Methods.getText(StringsManager.bookingDate, appProvider.isEnglish).toCapitalized()}: ${Methods.formatDate(context: context, milliseconds: int.parse(transactionModel.bookingDateTimeStamp!))}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showPublicRelationInformationDialog({
    required BuildContext context,
    required PublicRelationModel publicRelationModel,
    required TransactionType transactionType,
    required TransactionModel transactionModel,
  }) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    Dialogs._showBottomSheet(
      context: context,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeManager.s80,
                height: SizeManager.s80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SizeManager.s40),
                  child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.publicRelationsDirectory}/${publicRelationModel.personalImage}')),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(SizeManager.s8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        publicRelationModel.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                      ),
                      Text(
                        publicRelationModel.jobTitle,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeightManager.black),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Text(
                        '${Methods.getText(StringsManager.theLocation, appProvider.isEnglish).toCapitalized()}: ${publicRelationModel.address}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      Text(
                        '${Methods.getText(StringsManager.phoneNumber, appProvider.isEnglish).toCapitalized()}: ${publicRelationModel.phoneNumber}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      Text(
                        '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${publicRelationModel.consultationPrice} ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      Text(
                        '${Methods.getText(StringsManager.theTransaction, appProvider.isEnglish).toCapitalized()}: ${appProvider.isEnglish ? transactionModel.textEn : transactionModel.textAr}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      if(transactionModel.transactionType == TransactionType.appointmentBookingWithPublicRelation) Text(
                        '${Methods.getText(StringsManager.bookingDate, appProvider.isEnglish).toCapitalized()}: ${Methods.formatDate(context: context, milliseconds: int.parse(transactionModel.bookingDateTimeStamp!))}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> showLegalAccountantInformationDialog({
    required BuildContext context,
    required LegalAccountantModel legalAccountantModel,
    required TransactionType transactionType,
    required TransactionModel transactionModel,
  }) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    Dialogs.showBottomSheet(
      context: context,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeManager.s80,
                height: SizeManager.s80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SizeManager.s40),
                  child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.legalAccountantsDirectory}/${legalAccountantModel.personalImage}')),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(SizeManager.s8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        legalAccountantModel.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                      ),
                      Text(
                        legalAccountantModel.jobTitle,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeightManager.black),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Text(
                        '${Methods.getText(StringsManager.theLocation, appProvider.isEnglish).toCapitalized()}: ${legalAccountantModel.address}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      Text(
                        '${Methods.getText(StringsManager.phoneNumber, appProvider.isEnglish).toCapitalized()}: ${legalAccountantModel.phoneNumber}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      Text(
                        '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${legalAccountantModel.consultationPrice} ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      Text(
                        '${Methods.getText(StringsManager.theTransaction, appProvider.isEnglish).toCapitalized()}: ${appProvider.isEnglish ? transactionModel.textEn : transactionModel.textAr}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                      if(transactionModel.transactionType == TransactionType.appointmentBookingWithLegalAccountant) Text(
                        '${Methods.getText(StringsManager.bookingDate, appProvider.isEnglish).toCapitalized()}: ${Methods.formatDate(context: context, milliseconds: int.parse(transactionModel.bookingDateTimeStamp!))}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  static Future<PaymentsMethods?> showPayConfirmationDialog({
    required BuildContext context,
    required String title,
    required int serviceCost,
  }) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    PaymentsMethods? result;

    await showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      barrierColor: ColorsManager.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: ColorsManager.secondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(SizeManager.s30),
          topEnd: Radius.circular(SizeManager.s30),
        ),
      ),
      builder: (context) {
        return Directionality(
          textDirection: Methods.getDirection(appProvider.isEnglish),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(SizeManager.s32),
                child: Image.asset(ImagesManager.creditCard, width: SizeManager.s350, height: SizeManager.s350),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s32),
                decoration: const BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeManager.s30),
                    topRight: Radius.circular(SizeManager.s30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.black),
                    ),
                    const SizedBox(height: SizeManager.s20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: SizeManager.s50,
                            padding: const EdgeInsets.all(SizeManager.s10),
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryColor,
                              border: Border.all(color: ColorsManager.primaryColor),
                              borderRadius: const BorderRadiusDirectional.only(
                                topStart: Radius.circular(SizeManager.s10),
                                bottomStart: Radius.circular(SizeManager.s10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                Methods.getText(StringsManager.serviceCost, appProvider.isEnglish).toTitleCase(),
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: SizeManager.s50,
                            padding: const EdgeInsets.all(SizeManager.s10),
                            decoration: BoxDecoration(
                              color: ColorsManager.white,
                              border: Border.all(color: ColorsManager.primaryColor),
                              borderRadius: const BorderRadiusDirectional.only(
                                topEnd: Radius.circular(SizeManager.s10),
                                bottomEnd: Radius.circular(SizeManager.s10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$serviceCost ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(walletProvider.wallet != null) ...[
                      const SizedBox(height: SizeManager.s10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(SizeManager.s10),
                              child: Text(
                                '${Methods.getText(StringsManager.yourCurrentWalletBalance, appProvider.isEnglish)} ${walletProvider.wallet!.balance} ${Methods.getText(StringsManager.egp, appProvider.isEnglish)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          CustomButton(
                            buttonType: ButtonType.text,
                            onPressed: () => addMoneyToWallet(context: context),
                            text: Methods.getText(StringsManager.chargeYourWallet, appProvider.isEnglish).toCapitalized(),
                            width: SizeManager.s100,
                            height: SizeManager.s35,
                            borderRadius: SizeManager.s5,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: SizeManager.s40),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonType: ButtonType.text,
                            onPressed: () {
                              Navigator.pop(context);
                              result = PaymentsMethods.direct;
                            },
                            text: Methods.getText(StringsManager.payNow2, appProvider.isEnglish).toCapitalized(),
                          ),
                        ),
                        const SizedBox(width: SizeManager.s10),
                        Expanded(
                          child: CustomButton(
                            buttonType: ButtonType.text,
                            onPressed: () {
                              Navigator.pop(context);
                              result = PaymentsMethods.wallet;
                            },
                            text: Methods.getText(StringsManager.payFromYourWallet, appProvider.isEnglish).toCapitalized(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return Future.value(result);
  }

  static Future<OrderBy?> orderByDialog({required BuildContext context, required OrderBy orderBy}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    OrderBy orderByGroupValue = orderBy;
    OrderBy? result;

    await Dialogs._showBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Center(
                child: Text(
                  Methods.getText(StringsManager.orderBy, appProvider.isEnglish).toTitleCase(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(height: SizeManager.s20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: OrderBy.values.length,
                itemBuilder: (context, index) => RadioListTile(
                  value: OrderBy.values[index],
                  groupValue: orderByGroupValue,
                  title: Text(
                    OrderBy.fromOrderBy(context, OrderBy.values[index]),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (val) => setState(() => orderByGroupValue = val!),
                ),
                separatorBuilder: (context, index) => const Divider(color: ColorsManager.grey, height: SizeManager.s0),
              ),
              const SizedBox(height: SizeManager.s20),
              CustomButton(
                buttonType: ButtonType.text,
                text: Methods.getText(StringsManager.ok, appProvider.isEnglish).toCapitalized(),
                onPressed: () {
                  result = orderByGroupValue;
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );

    return Future.value(result);
  }

  static Future<LawyerModel?> chooseBetterLawyer(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    InstantConsultationsCommentsProvider instantConsultationsCommentsProvider = Provider.of<InstantConsultationsCommentsProvider>(context, listen: false);
    LawyersProvider lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
    InstantConsultationCommentModel? selectedInstantConsultationComment;
    LawyerModel? result;

    await Dialogs._showBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Center(
                child: Text(
                  Methods.getText(StringsManager.chooseTheBestLawyer, appProvider.isEnglish).toTitleCase(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(height: SizeManager.s20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: instantConsultationsCommentsProvider.commentsForTransaction.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => setState(() => selectedInstantConsultationComment = instantConsultationsCommentsProvider.commentsForTransaction[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedInstantConsultationComment != null && selectedInstantConsultationComment!.instantConsultationCommentId == instantConsultationsCommentsProvider.commentsForTransaction[index].instantConsultationCommentId
                              ? ColorsManager.primaryColor
                              : Colors.transparent,
                          width: SizeManager.s2,
                        ),
                      ),
                      child: InstantConsultationCommentItem(
                        instantConsultationCommentModel: instantConsultationsCommentsProvider.commentsForTransaction[index],
                        index: index,
                        isSupportOnTap: false,
                        boxColor: ColorsManager.grey1,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
              ),
              const SizedBox(height: SizeManager.s20),
              CustomButton(
                buttonType: ButtonType.text,
                text: Methods.getText(StringsManager.ok, appProvider.isEnglish).toCapitalized(),
                onPressed: () {
                  if(selectedInstantConsultationComment != null) result = lawyersProvider.getLawyerWithId(selectedInstantConsultationComment!.lawyerId);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );

    return Future.value(result);
  }
}