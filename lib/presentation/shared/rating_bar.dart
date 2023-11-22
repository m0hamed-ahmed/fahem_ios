import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingBar extends StatefulWidget {
  final double numberOfStars;
  final double starSize;
  final double padding;

  const RatingBar({
    Key? key,
    required this.numberOfStars,
    this.starSize = SizeManager.s15,
    this.padding = SizeManager.s2,
  }) : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late AppProvider appProvider;

  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index2) {
          if (index2.toDouble() >= widget.numberOfStars) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.padding),
              child: Image.asset(ImagesManager.ratingEmpty, width: widget.starSize, height: widget.starSize),
            );
          }
          else if (index2.toDouble() > widget.numberOfStars - 1 && index2.toDouble() < widget.numberOfStars) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.padding),
              child: Image.asset(appProvider.isEnglish ? ImagesManager.ratingHalfLeft : ImagesManager.ratingHalfRight, width: widget.starSize, height: widget.starSize),
            );
          }
          else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.padding),
              child: Image.asset(ImagesManager.ratingFull, width: widget.starSize, height: widget.starSize),
            );
          }
        }),
      ),
    );
  }
}