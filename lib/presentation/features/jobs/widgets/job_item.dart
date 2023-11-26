import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobItem extends StatefulWidget {
  final JobModel jobModel;
  final int index;
  
  const JobItem({super.key, required this.jobModel, required this.index});

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  late AppProvider appProvider;
  late UserAccountProvider userAccountProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       color: ColorsManager.white,
       borderRadius: BorderRadius.circular(SizeManager.s10),
       border: Border.all(color: ColorsManager.grey300),
     ),
     child: Material(
       color: Colors.transparent,
       child: InkWell(
         onTap: () => Navigator.pushNamed(context, Routes.jobDetailsRoute, arguments: {ConstantsManager.jobModelArgument: widget.jobModel, ConstantsManager.tagArgument: ConstantsManager.jobsTag}),
         borderRadius: BorderRadius.circular(SizeManager.s10),
         child: Padding(
           padding: const EdgeInsets.all(SizeManager.s10),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(
                     // tag: widget.jobModel.image + ConstantsManager.jobsTag,
                     child: Container(
                       clipBehavior: Clip.antiAlias,
                       width: SizeManager.s80,
                       height: SizeManager.s80,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(SizeManager.s10),
                       ),
                       child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.jobsDirectory}/${widget.jobModel.image}')),
                     ),
                   ),
                   Expanded(
                     child: Container(
                       padding: const EdgeInsets.symmetric(vertical: SizeManager.s5, horizontal: SizeManager.s10),
                       height: SizeManager.s80,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             widget.jobModel.jobTitle,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                           ),
                           Text(
                             widget.jobModel.companyName,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: Theme.of(context).textTheme.bodyMedium,
                           ),
                           Text(
                             '${widget.jobModel.minSalary} - ${widget.jobModel.maxSalary} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: Theme.of(context).textTheme.bodyMedium,
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
                   const SizedBox(width: SizeManager.s90),
                   Expanded(
                     child: Wrap(
                       spacing: SizeManager.s5,
                       runSpacing: SizeManager.s5,
                       children: List.generate(widget.jobModel.features.length, (index) {
                         return Container(
                           padding: const EdgeInsets.symmetric(vertical: SizeManager.s1, horizontal: SizeManager.s10),
                           decoration: BoxDecoration(
                             color: ColorsManager.white,
                             borderRadius: BorderRadius.circular(SizeManager.s10),
                             border: Border.all(color: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor),
                           ),
                           child: FittedBox(
                             child: Text(
                               widget.jobModel.features[index],
                               style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                 color: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                                 fontWeight: FontWeightManager.bold,
                               ),
                             ),
                           ),
                         );
                       }),
                     ),
                   ),
                   const SizedBox(width: SizeManager.s10),
                   CustomButton(
                     buttonType: ButtonType.text,
                     onPressed: () {
                       if(userAccountProvider.userAccount == null) {
                         Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                           if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                         });
                       }
                       else {
                        Navigator.pushNamed(context, Routes.jobApplyRoute, arguments: {ConstantsManager.jobModelArgument: widget.jobModel, ConstantsManager.tagArgument: ConstantsManager.jobsTag});
                       }
                     },
                     text: Methods.getText(StringsManager.apply, appProvider.isEnglish).toUpperCase(),
                     width: null,
                     height: SizeManager.s30,
                     buttonColor: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                     borderRadius: SizeManager.s10,
                   ),
                 ],
               ),
             ],
           ),
         ),
       ),
     ),
   );
  }
}