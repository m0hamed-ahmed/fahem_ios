import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsOfUseAndPrivacyPolicy extends StatefulWidget {

  const TermsOfUseAndPrivacyPolicy({super.key});

  @override
  State<TermsOfUseAndPrivacyPolicy> createState() => _TermsOfUseAndPrivacyPolicyState();
}

class _TermsOfUseAndPrivacyPolicyState extends State<TermsOfUseAndPrivacyPolicy> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(SizeManager.s16),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: SizeManager.s3,
        spacing: SizeManager.s3,
        children: [
          Text(
            Methods.getText(StringsManager.byContinuingYouAgreeToOur, appProvider.isEnglish).toCapitalized(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: SizeManager.s20,
            child: TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context, Routes.termsOfUseRoute);
              },
              style: TextButton.styleFrom(
                visualDensity: const VisualDensity(horizontal: -4),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                Methods.getText(StringsManager.termsOfUse, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.secondaryColor),
              ),
            ),
          ),
          Text(
            Methods.getText(StringsManager.and, appProvider.isEnglish),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: SizeManager.s20,
            child: TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context, Routes.privacyPolicyRoute);
              },
              style: TextButton.styleFrom(
                visualDensity: const VisualDensity(horizontal: -4),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                Methods.getText(StringsManager.privacyPolicy, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.secondaryColor),
              ),
            ),
          ),
          if(!appProvider.isEnglish) Text(
            'الخاصة بنا',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}