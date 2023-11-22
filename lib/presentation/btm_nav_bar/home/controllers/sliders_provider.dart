import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/data/models/sliders/slider_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/sliders/get_all_sliders_usecase.dart';
import 'package:flutter/material.dart';

class SlidersProvider with ChangeNotifier {
  final GetAllSlidersUseCase _getAllSlidersUseCase;

  SlidersProvider(this._getAllSlidersUseCase);

  Future<Either<Failure, List<SliderModel>>> getAllSlidersImpl() async {
    return await _getAllSlidersUseCase.call(const NoParameters());
  }

  List<SliderModel> _sliders = [];
  List<SliderModel> get sliders => _sliders;
  setSliders(List<SliderModel> sliders) => _sliders = sliders;
}