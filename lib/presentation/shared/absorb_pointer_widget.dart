import 'package:fahem/core/resources/colors_manager.dart';
import 'package:flutter/material.dart';

class AbsorbPointerWidget extends StatelessWidget {
  final bool absorbing;
  final Widget child;
  final AlignmentGeometry alignment;
  final bool isCircularProgressIndicator;

  const AbsorbPointerWidget({
    Key? key,
    required this.child,
    required this.absorbing,
    this.alignment = Alignment.center,
    this.isCircularProgressIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: Stack(
        alignment: alignment,
        children: [
          child,
          if(absorbing) Container(
            color: ColorsManager.white38,
            child: isCircularProgressIndicator ? const Center(
              child: CircularProgressIndicator(),
            ) : Container(),
          ),
        ],
      ),
    );
  }
}