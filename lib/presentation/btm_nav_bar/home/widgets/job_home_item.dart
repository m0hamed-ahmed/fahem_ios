import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobHomeItem extends StatefulWidget {
  final JobModel jobModel;
  final int index;
  
  const JobHomeItem({super.key, required this.jobModel, required this.index});

  @override
  State<JobHomeItem> createState() => _JobHomeItemState();
}

class _JobHomeItemState extends State<JobHomeItem> {
  late AppProvider appProvider;
  
  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
   return Container(
     width: MediaQuery.of(context).size.width * 0.9,
     decoration: BoxDecoration(
       color: widget.index % 2 == 0 ? ColorsManager.primaryColor : ColorsManager.secondaryColor,
       borderRadius: BorderRadius.circular(SizeManager.s10),
     ),
     child: Material(
       color: Colors.transparent,
       child: InkWell(
         onTap: () => Navigator.pushNamed(context, Routes.jobDetailsRoute, arguments: {ConstantsManager.jobModelArgument: widget.jobModel, ConstantsManager.tagArgument: ConstantsManager.homeJobsTag}),
         borderRadius: BorderRadius.circular(SizeManager.s10),
         child: Padding(
           padding: const EdgeInsets.all(SizeManager.s10),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   GestureDetector(
                     onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.jobModel.image, ConstantsManager.directoryArgument: ApiConstants.jobsDirectory}),
                     child: SizedBox(
                       // tag: widget.jobModel.image + ConstantsManager.homeJobsTag,
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
                   ),
                   Expanded(
                     child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: SizeManager.s10, vertical: SizeManager.s5),
                       height: SizeManager.s80,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                             widget.jobModel.companyName,
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                             style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                           ),
                           Text(
                             widget.jobModel.jobLocation,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
               const SizedBox(height: SizeManager.s10),
               Text(
                 widget.jobModel.jobTitle,
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
               ),
               Text(
                 '${widget.jobModel.minSalary} - ${widget.jobModel.maxSalary} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
               ),
               const SizedBox(height: SizeManager.s16),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Expanded(
                     child: Row(
                       children: List.generate(widget.jobModel.features.length, (index) {
                         return Flexible(
                           child: Container(
                             padding: const EdgeInsets.symmetric(vertical: SizeManager.s1, horizontal: SizeManager.s10),
                             margin: const EdgeInsets.all(SizeManager.s5),
                             decoration: BoxDecoration(
                               color: ColorsManager.white,
                               borderRadius: BorderRadius.circular(SizeManager.s10),
                             ),
                             child: FittedBox(
                               child: Text(
                                 widget.jobModel.features[index],
                                 style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeightManager.black),
                               ),
                             ),
                           ),
                         );
                       }),
                     ),
                   ),
                   const SizedBox(width: SizeManager.s50),
                   Text(
                     Methods.formatDate(context: context, milliseconds: widget.jobModel.createdAt.millisecondsSinceEpoch),
                     style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
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