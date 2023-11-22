import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogItem extends StatefulWidget {
  final LogModel logModel;

  const LogItem({super.key, required this.logModel});

  @override
  State<LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<LogItem> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appProvider.isEnglish ? widget.logModel.textEn : widget.logModel.textAr,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            Methods.formatDate(context: context, milliseconds: widget.logModel.createdAt.millisecondsSinceEpoch),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
          ),
        ),
      ],
    );
  }
}