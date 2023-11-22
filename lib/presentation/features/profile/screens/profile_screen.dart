import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
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
import 'package:fahem/domain/usecases/users/users_accounts/delete_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/edit_user_account_usecase.dart';
import 'package:fahem/presentation/features/profile/controllers/profile_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/drop_down_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AppProvider appProvider;
  late ProfileProvider profileProvider;
  late UserAccountProvider userAccountProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerFirstName = TextEditingController();
  final TextEditingController _textEditingControllerFamilyName = TextEditingController();
  final TextEditingController _textEditingControllerEmailAddress = TextEditingController();
  final TextEditingController _textEditingControllerReasonForRegistration = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    _textEditingControllerFirstName.text = userAccountProvider.userAccount!.firstName;
    _textEditingControllerFamilyName.text = userAccountProvider.userAccount!.familyName;
    _textEditingControllerEmailAddress.text = userAccountProvider.userAccount!.emailAddress ?? ConstantsManager.empty;
    _textEditingControllerReasonForRegistration.text = userAccountProvider.userAccount!.reasonForRegistration ?? ConstantsManager.empty;
    profileProvider.setGender(userAccountProvider.userAccount!.gender);
    profileProvider.setBirthDate(userAccountProvider.userAccount!.birthDate);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, child) {
        return AbsorbPointerWidget(
          absorbing: isLoading,
          child: WillPopScope(
            onWillPop: () async => await Future.value(!isLoading),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Directionality(
                textDirection: Methods.getDirection(appProvider.isEnglish),
                child: Scaffold(
                  body: Background(
                    child: SafeArea(
                      child: Consumer<ProfileProvider>(
                        builder: (context, provider, _) {
                          return Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(SizeManager.s16),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
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
                                                  Methods.getText(StringsManager.profile, appProvider.isEnglish).toTitleCase(),
                                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                                ),
                                              ),
                                            ],
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
                                          const SizedBox(height: SizeManager.s20),

                                          // Delete Button
                                          CustomButton(
                                            buttonType: ButtonType.postIcon,
                                            onPressed: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.areYouSureToDeleteTheAccount, appProvider.isEnglish).toCapitalized()).then((value) async {
                                              if(value) {
                                                DeleteUserAccountParameters parameters = DeleteUserAccountParameters(
                                                  userAccountId: userAccountProvider.userAccount!.userAccountId,
                                                );
                                                profileProvider.deleteAccount(context: context, deleteUserAccountParameters: parameters);
                                              }
                                            }),
                                            text: Methods.getText(StringsManager.deleteAccount, appProvider.isEnglish).toUpperCase(),
                                            iconData: Icons.delete,
                                            textColor: ColorsManager.red700,
                                            iconColor: ColorsManager.red700,
                                            buttonColor: ColorsManager.white,
                                            borderColor: ColorsManager.red700,
                                            borderWidth: SizeManager.s1_5,
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: SizeManager.s16),
                                    child: CustomButton(
                                      buttonType: ButtonType.text,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if(_formKey.currentState!.validate() && profileProvider.isAllDataValid()) {
                                          UserAccountModel userAccountModel = UserAccountModel(
                                            userAccountId: userAccountProvider.userAccount!.userAccountId,
                                            phoneNumber: userAccountProvider.userAccount!.phoneNumber,
                                            firstName: _textEditingControllerFirstName.text.trim(),
                                            familyName: _textEditingControllerFamilyName.text.trim(),
                                            gender: profileProvider.gender!,
                                            birthDate: profileProvider.birthDate!,
                                            emailAddress: _textEditingControllerEmailAddress.text.trim().isEmpty ? null : _textEditingControllerEmailAddress.text.trim(),
                                            reasonForRegistration: _textEditingControllerReasonForRegistration.text.trim().isEmpty ? null : _textEditingControllerReasonForRegistration.text.trim(),
                                            createdAt: userAccountProvider.userAccount!.createdAt,
                                          );
                                          EditUserAccountParameters parameters = EditUserAccountParameters(
                                            userAccountModel: userAccountModel
                                          );
                                          provider.editProfile(context: context, editUserAccountParameters: parameters);
                                        }
                                      },
                                      text: Methods.getText(StringsManager.edit, appProvider.isEnglish).toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
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