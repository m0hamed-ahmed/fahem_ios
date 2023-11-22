import 'package:fahem/core/resources/assets_manager.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(ImagesManager.backgroundScreen, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
        child,
      ],
    );
  }
}
