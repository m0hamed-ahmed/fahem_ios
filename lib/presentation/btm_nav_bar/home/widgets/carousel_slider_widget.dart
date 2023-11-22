import 'package:carousel_slider/carousel_slider.dart';
import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/sliders_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselSliderWidget extends StatefulWidget {

  const CarouselSliderWidget({super.key});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final CarouselController _carouselController = CarouselController();
  late SlidersProvider slidersProvider;

  @override
  void initState() {
    super.initState();
    slidersProvider = Provider.of<SlidersProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
            height: SizeManager.s200,
            initialPage: 0,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
          items: slidersProvider.sliders.map((slider) {
            return InkWell(
              onTap: slider.route == null ? null : () => Navigator.pushNamed(context, slider.route!),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(SizeManager.s10)),
                child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.slidersDirectory}/${slider.image}')),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}