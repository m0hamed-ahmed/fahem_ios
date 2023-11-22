import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  final Object? currentValue;
  final String hintText;
  final List<String> valuesText;
  final List<Object> valuesObject;
  final Function(Object?) onChanged;
  final bool isEnglish;

  const DropDownWidget({
    Key? key,
    required this.currentValue,
    required this.hintText,
    required this.valuesText,
    required this.valuesObject,
    required this.onChanged,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: DropdownButton(
        value: currentValue,
        onChanged: onChanged,
        iconEnabledColor: ColorsManager.primaryColor,
        isExpanded: true,
        underline: Container(),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
        hint: Text(
          hintText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        items: List.generate(valuesText.length, (index) => DropdownMenuItem(
          value: valuesObject[index],
          child: Align(
            alignment: isEnglish ? Alignment.centerLeft : Alignment.centerRight,
            child: Text(valuesText[index]),
          ),
        )),
      ),
    );
  }
}