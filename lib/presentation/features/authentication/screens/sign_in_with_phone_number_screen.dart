import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/core/utils/validator.dart';
import 'package:fahem/presentation/features/authentication/controllers/sign_in_with_phone_provider.dart';
import 'package:fahem/presentation/features/authentication/widgets/terms_of_use_and_privacy_policy.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {

  const SignInWithPhoneNumberScreen({super.key});

  @override
  State<SignInWithPhoneNumberScreen> createState() => _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState extends State<SignInWithPhoneNumberScreen> {
  late AppProvider appProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerPhoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SignInWithPhoneProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return AbsorbPointerWidget(
          absorbing: isLoading,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: WillPopScope(
              onWillPop: () => Future.value(!isLoading),
              child: Directionality(
                textDirection: Methods.getDirection(appProvider.isEnglish),
                child: Scaffold(
                  body: Background(
                    child: SafeArea(
                      child: Consumer<SignInWithPhoneProvider>(
                        builder: (context, provider, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(SizeManager.s16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Methods.getText(StringsManager.logInOrCreateAnAccount, appProvider.isEnglish).toCapitalized(),
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                      ),
                                      const SizedBox(height: SizeManager.s5),

                                      Text(
                                        Methods.getText(StringsManager.weWillSendYouACodeToConfirmTheMobileNumber, appProvider.isEnglish).toCapitalized(),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      Form(
                                        key: _formKey,
                                        child: CustomTextFormField(
                                          controller: _textEditingControllerPhoneNumber,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 11,
                                          labelText: '${Methods.getText(StringsManager.mobileNumber, appProvider.isEnglish).toCapitalized()} *',
                                          prefixIcon: const Icon(Icons.phone, color: ColorsManager.primaryColor),
                                          suffixIcon: IconButton(
                                            onPressed: () => _textEditingControllerPhoneNumber.clear(),
                                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                          ),
                                          validator: (val) {
                                            if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                            else if(!Validator.isPhoneNumberValid(val)) {return Methods.getText(StringsManager.phoneNumberIsIncorrect, appProvider.isEnglish).toCapitalized();}
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // Resend Code
                                      if(provider.resendCodeTimer != null && provider.resendCodeTimer! > 0) Text(
                                        '${Methods.getText(StringsManager.resendCodeIn, appProvider.isEnglish).toCapitalized()} ${provider.resendCodeTimer} ${Methods.getText(StringsManager.seconds, appProvider.isEnglish).toUpperCase()}',
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const TermsOfUseAndPrivacyPolicy(),
                              Container(
                                margin: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s16),
                                child: IgnorePointer(
                                  ignoring: (provider.resendCodeTimer != null && provider.resendCodeTimer! > 0),
                                  child: Opacity(
                                    opacity: !(provider.resendCodeTimer != null && provider.resendCodeTimer! > 0) ? 1 : 0.5,
                                    child: CustomButton(
                                      buttonType: ButtonType.text,
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if(_formKey.currentState!.validate()) {
                                          await provider.verifyPhoneNumber(context: context, phoneNumber: _textEditingControllerPhoneNumber.text.trim());
                                        }
                                      },
                                      text: Methods.getText(StringsManager.continueTxt, appProvider.isEnglish).toUpperCase(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    _textEditingControllerPhoneNumber.dispose();
    super.dispose();
  }
}