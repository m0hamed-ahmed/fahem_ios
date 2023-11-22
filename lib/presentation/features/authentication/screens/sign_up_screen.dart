import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/core/utils/validator.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/authentication/controllers/sign_up_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class SignUpScreen extends StatefulWidget {
  final String phoneNumber;

  const SignUpScreen({super.key, required this.phoneNumber});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AppProvider appProvider;
  late SignUpProvider signUpProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerFirstName = TextEditingController();
  final TextEditingController _textEditingControllerFamilyName = TextEditingController();
  final TextEditingController _textEditingControllerEmailAddress = TextEditingController();
  final TextEditingController _textEditingControllerReasonForRegistration = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    signUpProvider.resetAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SignUpProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, child) {
        return AbsorbPointerWidget(
          absorbing: isLoading,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: WillPopScope(
              onWillPop: () => isLoading ? Future.value(false) : Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToBack, appProvider.isEnglish).toCapitalized()),
              child: Directionality(
                textDirection: Methods.getDirection(appProvider.isEnglish),
                child: Scaffold(
                  body: Background(
                    child: SafeArea(
                      child: Consumer<SignUpProvider>(
                        builder: (context, provider, _) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(SizeManager.s16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Methods.getText(StringsManager.theLastStepToCreateYourAccount, appProvider.isEnglish).toTitleCase(),
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                        ),
                                        const SizedBox(height: SizeManager.s5),

                                        Text(
                                          Methods.getText(StringsManager.addYourBasicInformationToStartFahem, appProvider.isEnglish).toCapitalized(),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: SizeManager.s20),

                                        // Name *
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextFormField(
                                                controller: _textEditingControllerFirstName,
                                                textInputAction: TextInputAction.next,
                                                textDirection: Methods.getDirection(appProvider.isEnglish),
                                                labelText: '${Methods.getText(StringsManager.firstName, appProvider.isEnglish).toCapitalized()} *',
                                                prefixIcon: const Icon(Icons.person_outlined, color: ColorsManager.primaryColor),
                                                suffixIcon: IconButton(
                                                  onPressed: () => _textEditingControllerFirstName.clear(),
                                                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                                ),
                                                validator: (val) {
                                                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: SizeManager.s10),
                                            Expanded(
                                              child: CustomTextFormField(
                                                controller: _textEditingControllerFamilyName,
                                                textInputAction: TextInputAction.next,
                                                textDirection: Methods.getDirection(appProvider.isEnglish),
                                                labelText: '${Methods.getText(StringsManager.familyName, appProvider.isEnglish).toCapitalized()} *',
                                                prefixIcon: const Icon(Icons.person_outlined, color: ColorsManager.primaryColor),
                                                suffixIcon: IconButton(
                                                  onPressed: () => _textEditingControllerFamilyName.clear(),
                                                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                                ),
                                                validator: (val) {
                                                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: SizeManager.s20),

                                        // Email Address
                                        CustomTextFormField(
                                          controller: _textEditingControllerEmailAddress,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.emailAddress,
                                          labelText: '${Methods.getText(StringsManager.eMail, appProvider.isEnglish).toCapitalized()} (${Methods.getText(StringsManager.optional, appProvider.isEnglish)})',
                                          prefixIcon: const Icon(Icons.email_outlined, color: ColorsManager.primaryColor),
                                          suffixIcon: IconButton(
                                            onPressed: () => _textEditingControllerEmailAddress.clear(),
                                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                          ),
                                        ),
                                        const SizedBox(height: SizeManager.s20),

                                        // Reason For Registration
                                        CustomTextFormField(
                                          controller: _textEditingControllerReasonForRegistration,
                                          textInputAction: TextInputAction.done,
                                          textDirection: Methods.getDirection(appProvider.isEnglish),
                                          labelText: '${Methods.getText(StringsManager.theReasonForRegistration, appProvider.isEnglish).toCapitalized()} (${Methods.getText(StringsManager.optional, appProvider.isEnglish)})',
                                          prefixIcon: const Icon(Icons.edit, color: ColorsManager.primaryColor),
                                          suffixIcon: IconButton(
                                            onPressed: () => _textEditingControllerReasonForRegistration.clear(),
                                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                          ),
                                        ),
                                        const SizedBox(height: SizeManager.s20),

                                        // Gender *
                                        Container(
                                          height: SizeManager.s45,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(SizeManager.s15),
                                            border: Border.all(color: ColorsManager.primaryColor),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: SizeManager.s45,
                                                  padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                                                  color: ColorsManager.primaryColor,
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        ImagesManager.profileIc,
                                                        width: SizeManager.s15,
                                                        height: SizeManager.s15,
                                                        color: ColorsManager.white,
                                                      ),
                                                      const SizedBox(width: SizeManager.s10),
                                                      Flexible(
                                                        child: Text(
                                                          '${Methods.getText(StringsManager.gender, appProvider.isEnglish).toCapitalized()} *',
                                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: ColorsManager.white,
                                                    borderRadius: BorderRadiusDirectional.only(
                                                      topEnd: Radius.circular(SizeManager.s15),
                                                      bottomEnd: Radius.circular(SizeManager.s15),
                                                    ),
                                                  ),
                                                  child: DropDownWidget(
                                                    currentValue: provider.gender,
                                                    hintText: Methods.getText(StringsManager.chooseGender, appProvider.isEnglish).toCapitalized(),
                                                    valuesObject: Gender.values,
                                                    valuesText: Gender.values.map((gender) => Gender.fromGender(context, gender)).toList(),
                                                    onChanged: (val) => provider.changeGender(val as Gender?),
                                                    isEnglish: appProvider.isEnglish,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: SizeManager.s20),

                                        // Birth Date *
                                        Container(
                                          height: SizeManager.s45,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(SizeManager.s15),
                                            border: Border.all(color: ColorsManager.primaryColor),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: SizeManager.s45,
                                                  padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                                                  color: ColorsManager.primaryColor,
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        ImagesManager.dateIc,
                                                        width: SizeManager.s15,
                                                        height: SizeManager.s15,
                                                        color: ColorsManager.white,
                                                      ),
                                                      const SizedBox(width: SizeManager.s10),
                                                      Flexible(
                                                        child: Text(
                                                          '${Methods.getText(StringsManager.birthDate, appProvider.isEnglish).toCapitalized()} *',
                                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  height: SizeManager.s45,
                                                  decoration: const BoxDecoration(
                                                    color: ColorsManager.white,
                                                    borderRadius: BorderRadiusDirectional.only(
                                                      topEnd: Radius.circular(SizeManager.s15),
                                                      bottomEnd: Radius.circular(SizeManager.s15),
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await DatePicker.showSimpleDatePicker(
                                                          context,
                                                          initialDate: provider.birthDate ?? DateTime.now(),
                                                          firstDate: DateTime(1900, 1, 1),
                                                          lastDate: DateTime.now(),
                                                          dateFormat: "dd-MMMM-yyyy",
                                                          locale: DateTimePickerLocale.values[1],
                                                          reverse: true,
                                                          textColor: ColorsManager.primaryColor,
                                                          titleText: Methods.getText(StringsManager.birthDate, appProvider.isEnglish).toCapitalized(),
                                                          cancelText: Methods.getText(StringsManager.cancel, appProvider.isEnglish).toCapitalized(),
                                                          confirmText: Methods.getText(StringsManager.ok, appProvider.isEnglish).toCapitalized(),
                                                          itemTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                                        ).then((dateTime) {
                                                          if(dateTime != null) {
                                                            provider.changeBirthDate(dateTime);
                                                          }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                                                        child: Align(
                                                          alignment: AlignmentDirectional.centerStart,
                                                          child: Text(
                                                            provider.birthDate == null
                                                                ? Methods.getText(StringsManager.dayMonthYear, appProvider.isEnglish)
                                                                : intl.DateFormat('dd-MM-yyyy').format(provider.birthDate!),
                                                            style: provider.birthDate == null
                                                              ? Theme.of(context).textTheme.titleMedium
                                                              : Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Button
                                Container(
                                  margin: const EdgeInsets.all(SizeManager.s16),
                                  child: IgnorePointer(
                                    ignoring: !provider.isAllDataValid(),
                                    child: Opacity(
                                      opacity: provider.isAllDataValid() ? 1 : 0.5,
                                      child: CustomButton(
                                        buttonType: ButtonType.text,
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if(_formKey.currentState!.validate() && provider.isAllDataValid()) {
                                            UserAccountModel userAccountModel = UserAccountModel(
                                              userAccountId: 0,
                                              phoneNumber: widget.phoneNumber,
                                              firstName: _textEditingControllerFirstName.text.trim(),
                                              familyName: _textEditingControllerFamilyName.text.trim(),
                                              emailAddress: _textEditingControllerEmailAddress.text.trim().isEmpty ? null : _textEditingControllerEmailAddress.text.trim(),
                                              reasonForRegistration: _textEditingControllerReasonForRegistration.text.trim().isEmpty ? null : _textEditingControllerReasonForRegistration.text.trim(),
                                              gender: provider.gender!,
                                              birthDate: provider.birthDate!,
                                              createdAt: DateTime.now(),
                                            );
                                            provider.signUp(context: context, userAccountModel: userAccountModel);
                                          }
                                        },
                                        text: Methods.getText(StringsManager.createAccount, appProvider.isEnglish).toUpperCase(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
    _textEditingControllerFirstName.dispose();
    _textEditingControllerFamilyName.dispose();
    _textEditingControllerEmailAddress.dispose();
    _textEditingControllerReasonForRegistration.dispose();
    super.dispose();
  }
}