import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/core/utils/validator.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/controllers/instant_consultation_form_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationFormScreen extends StatefulWidget {

  const InstantConsultationFormScreen({super.key});

  @override
  State<InstantConsultationFormScreen> createState() => _InstantConsultationFormScreenState();
}

class _InstantConsultationFormScreenState extends State<InstantConsultationFormScreen> {
  late AppProvider appProvider;
  late InstantConsultationFormProvider instantConsultationFormProvider;
  late UserAccountProvider userAccountProvider;
  late SettingsProvider settingsProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerName = TextEditingController();
  final TextEditingController _textEditingControllerPhoneNumber = TextEditingController();
  final TextEditingController _textEditingControllerEmail = TextEditingController();
  final TextEditingController _textEditingControllerConsultation = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantConsultationFormProvider = Provider.of<InstantConsultationFormProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    _textEditingControllerName.text = '${userAccountProvider.userAccount!.firstName} ${userAccountProvider.userAccount!.familyName}';
    _textEditingControllerPhoneNumber.text = userAccountProvider.userAccount!.phoneNumber;
    _textEditingControllerEmail.text = userAccountProvider.userAccount!.emailAddress ?? ConstantsManager.empty;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<InstantConsultationFormProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return AbsorbPointerWidget(
          absorbing: isLoading,
          child: IgnorePointer(
            ignoring: isLoading,
            child: Directionality(
              textDirection: Methods.getDirection(appProvider.isEnglish),
              child: Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(SizeManager.s16),
                    child: Form(
                      key: _formKey,
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

                          Text(
                            '${Methods.getText(StringsManager.name, appProvider.isEnglish).toCapitalized()} *',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                          ),
                          const SizedBox(height: SizeManager.s5),
                          CustomTextFormField(
                            controller: _textEditingControllerName,
                            textInputAction: TextInputAction.next,
                            textDirection: Methods.getDirection(appProvider.isEnglish),
                            borderColor: ColorsManager.grey,
                            hintText: Methods.getText(StringsManager.pleaseWriteTheFullName, appProvider.isEnglish).toCapitalized(),
                            prefixIcon: const Icon(Icons.person_outlined, color: ColorsManager.grey),
                            suffixIcon: IconButton(
                              onPressed: () => _textEditingControllerName.clear(),
                              icon: const Icon(Icons.clear, color: ColorsManager.grey),
                            ),
                            validator: (val) {
                              if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                              return null;
                            },
                          ),

                          const SizedBox(height: SizeManager.s20),

                          Text(
                            '${Methods.getText(StringsManager.mobileNumber, appProvider.isEnglish).toCapitalized()} *',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                          ),
                          const SizedBox(height: SizeManager.s5),
                          CustomTextFormField(
                            controller: _textEditingControllerPhoneNumber,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            borderColor: ColorsManager.grey,
                            hintText: Methods.getText(StringsManager.mobileNumberConsistingOf11Digits, appProvider.isEnglish).toCapitalized(),
                            prefixIcon: const Icon(Icons.phone, color: ColorsManager.grey),
                            suffixIcon: IconButton(
                              onPressed: () => _textEditingControllerPhoneNumber.clear(),
                              icon: const Icon(Icons.clear, color: ColorsManager.grey),
                            ),
                            validator: (val) {
                              if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                              else if(!Validator.isPhoneNumberValid(val)) {return Methods.getText(StringsManager.phoneNumberIsIncorrect, appProvider.isEnglish).toCapitalized();}
                              return null;
                            },
                          ),

                          const SizedBox(height: SizeManager.s20),

                          Text(
                            Methods.getText(StringsManager.eMail, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                          ),
                          const SizedBox(height: SizeManager.s5),
                          CustomTextFormField(
                            controller: _textEditingControllerEmail,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            borderColor: ColorsManager.grey,
                            hintText: Methods.getText(StringsManager.eMail, appProvider.isEnglish).toCapitalized(),
                            prefixIcon: const Icon(Icons.email_outlined, color: ColorsManager.grey),
                            suffixIcon: IconButton(
                              onPressed: () => _textEditingControllerEmail.clear(),
                              icon: const Icon(Icons.clear, color: ColorsManager.grey),
                            ),
                            validator: (val) {
                              if(Validator.isEmpty(val!)) {return null;}
                              else if(!Validator.isEmailAddressValid(val)) {return Methods.getText(StringsManager.pleaseEnterAValidEmailAddress, appProvider.isEnglish).toCapitalized();}
                              return null;
                            },
                          ),

                          const SizedBox(height: SizeManager.s20),
                          Text(
                            '${Methods.getText(StringsManager.theInstantConsultation, appProvider.isEnglish).toCapitalized()} *',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                          ),
                          const SizedBox(height: SizeManager.s5),
                          CustomTextFormField(
                            controller: _textEditingControllerConsultation,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            textDirection: Methods.getDirection(appProvider.isEnglish),
                            borderColor: ColorsManager.grey,
                            hintText: '${Methods.getText(StringsManager.descriptionOfTheInstantConsultation, appProvider.isEnglish).toCapitalized()} (${Methods.getText(StringsManager.detailedAndClearExplanation, appProvider.isEnglish)})',
                            verticalPadding: SizeManager.s10,
                            suffixIcon: IconButton(
                              onPressed: () => _textEditingControllerConsultation.clear(),
                              icon: const Icon(Icons.clear, color: ColorsManager.grey),
                            ),
                            validator: (val) {
                              if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                              return null;
                            },
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
                                      '${settingsProvider.settings.instantConsultationPrice} ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: SizeManager.s50),

                          CustomButton(
                            buttonType: ButtonType.text,
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                TransactionModel transactionModel = TransactionModel(
                                  transactionId: 0,
                                  targetId: -1,
                                  userAccountId: userAccountProvider.userAccount!.userAccountId,
                                  name: _textEditingControllerName.text.trim(),
                                  phoneNumber: _textEditingControllerPhoneNumber.text.trim(),
                                  emailAddress: _textEditingControllerEmail.text.trim().isEmpty ? 'null' : _textEditingControllerEmail.text.trim(),
                                  bookingDateTimeStamp: 'null',
                                  textAr: _textEditingControllerConsultation.text.trim(),
                                  textEn: _textEditingControllerConsultation.text.trim(),
                                  transactionType: TransactionType.instantConsultation,
                                  isViewed: false,
                                  createdAt: DateTime.now(),
                                );
                                instantConsultationFormProvider.onPressedConsultNow(context, transactionModel);
                              }
                            },
                            text: Methods.getText(StringsManager.sendConsultation, appProvider.isEnglish).toTitleCase(),
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerPhoneNumber.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerConsultation.dispose();
    super.dispose();
  }
}