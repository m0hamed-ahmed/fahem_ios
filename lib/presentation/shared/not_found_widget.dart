import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class NotFoundWidget extends StatefulWidget {
  final String text;

  const NotFoundWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<NotFoundWidget> createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends State<NotFoundWidget> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(SizeManager.s16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(ImagesManager.notFound, width: SizeManager.s200, height: SizeManager.s200),
            Text(
              Methods.getText(widget.text, appProvider.isEnglish).toCapitalized(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20),
            ),
          ],
        ),
      ),
    );
  }
}