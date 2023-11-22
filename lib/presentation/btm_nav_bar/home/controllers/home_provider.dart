import 'package:fahem/data/data_source/static/governorates_data.dart';
import 'package:fahem/data/data_source/static/main_category_data.dart';
import 'package:fahem/data/models/static/government_model.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProvider with ChangeNotifier {

  void onTapMainCategory({required BuildContext context, required int index}) {
    if(index == 2) {
      LegalAccountantsProvider legalAccountantsProvider = Provider.of<LegalAccountantsProvider>(context, listen: false);
      legalAccountantsProvider.changeSelectedLegalAccountants(legalAccountantsProvider.legalAccountants);
      GovernmentModel governmentModel = governoratesData[1];
      legalAccountantsProvider.setSelectedGovernmentModel(governmentModel);
      Navigator.pushNamed(context, mainCategoryData[index].route);
    }
    else {
      Navigator.pushNamed(context, mainCategoryData[index].route);
    }
  }
}