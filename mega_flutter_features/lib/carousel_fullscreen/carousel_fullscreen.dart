import 'package:flutter/material.dart';
import 'package:mega_flutter_base/mega_base_screen.dart';
import 'package:mega_flutter_components/image_carousel.dart';

class CarouselFullScreen extends MegaBaseScreen {
  static const routeName = '/CarouselFull';

  @override
  String get screenName => '';

  @override
  _CarouselFullScreenState createState() => _CarouselFullScreenState();
}

class _CarouselFullScreenState extends MegaBaseScreenState<CarouselFullScreen>
    with MegaBaseScreenMixin {
  @override
  Widget body(BuildContext context) {
    final images = ModalRoute.of(context)!.settings.arguments as List<String>;
    return Hero(
      tag: 'carousel-images-tag',
      child: ImageCarousel(
        height: MediaQuery.of(context).size.height * 0.8,
        images: images,
        padding: const EdgeInsets.all(10),
        hasCard: false,
        boxFit: BoxFit.contain,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
