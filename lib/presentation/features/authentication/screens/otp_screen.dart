import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/authentication/controllers/otp_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late AppProvider appProvider;
  late OtpProvider otpProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    otpProvider = Provider.of<OtpProvider>(context, listen: false);

    otpProvider.resetAllDate();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<OtpProvider, bool>(
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
                      child: Selector<OtpProvider, String?>(
                        selector: (context, provider) => provider.myOtpCode,
                        builder: (context, myOtpCode, _) {
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
                                        Methods.getText(StringsManager.confirmPhoneNumber, appProvider.isEnglish).toTitleCase(),
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                      ),
                                      const SizedBox(height: SizeManager.s5),

                                      Text(
                                        '${Methods.getText(StringsManager.enterThe6DigitCodeSentTo, appProvider.isEnglish).toCapitalized()} ${widget.phoneNumber}',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // Code Text Field
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: PinCodeTextField(
                                          textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                                          appContext: context,
                                          keyboardType: TextInputType.number,
                                          animationType: AnimationType.scale,
                                          animationDuration: const Duration(milliseconds: 300),
                                          length: 6,
                                          enableActiveFill: true,
                                          cursorColor: ColorsManager.white,
                                          onChanged: (val) => otpProvider.changeMyOtpCode(val),
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius: BorderRadius.circular(SizeManager.s5),
                                            fieldWidth: ((MediaQuery.of(context).size.width - 32 - 32) / 6) > 50 ? SizeManager.s50 : (MediaQuery.of(context).size.width - 32 - 32) / 6,
                                            fieldHeight: SizeManager.s50,
                                            inactiveFillColor: ColorsManager.white,
                                            inactiveColor: ColorsManager.grey300,
                                            activeFillColor: ColorsManager.primaryColor,
                                            activeColor: ColorsManager.primaryColor,
                                            selectedFillColor: ColorsManager.primaryColor,
                                            selectedColor: ColorsManager.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Button
                              Container(
                                margin: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s16),
                                child: IgnorePointer(
                                  ignoring: !(myOtpCode != null && myOtpCode.length == 6),
                                  child: Opacity(
                                    opacity: (myOtpCode != null && myOtpCode.length == 6 ? 1 : 0.5),
                                    child: CustomButton(
                                      buttonType: ButtonType.text,
                                      onPressed: () async => await otpProvider.verifyCode(context: context, verificationId: widget.verificationId, phoneNumber: widget.phoneNumber),
                                      text: Methods.getText(StringsManager.confirm, appProvider.isEnglish).toUpperCase(),
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
}