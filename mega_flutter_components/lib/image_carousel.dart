import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageCarousel extends StatefulWidget {
  final double height;
  final List<String> images;
  final double radius;
  final double elevation;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool indicator;
  final double viewportFraction;
  final BoxFit boxFit;
  final bool hasCard;
  final Color? backgroundColor;

  const ImageCarousel({
    required this.height,
    required this.images,
    this.radius = 5,
    this.elevation = 5,
    this.viewportFraction = 1,
    this.margin,
    this.padding,
    this.indicator = true,
    this.boxFit = BoxFit.fitWidth,
    this.hasCard = true,
    this.backgroundColor,
  });

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    if (widget.indicator) {
      _pageController.addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            controller: _pageController,
            children: widget.images.map((image) {
              return _CarouselImage(
                image: image,
                margin: widget.margin ?? const EdgeInsets.all(0),
                padding: widget.padding ?? const EdgeInsets.all(0),
                radius: widget.radius,
                elevation: widget.elevation,
                boxFit: widget.boxFit,
                hasCard: widget.hasCard,
                backgroundColor: widget.backgroundColor,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: widget.indicator,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
        )
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    final List<Widget> list = [];
    for (int i = 0; i < widget.images.length; i++) {
      list.add(_indicator(i == _currentPage.toInt()));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 7,
        width: isActive ? 14 : 7,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          color: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}

class _CarouselImage extends StatelessWidget {
  final String image;
  final double radius;
  final double elevation;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxFit boxFit;
  final bool hasCard;
  final Color? backgroundColor;

  const _CarouselImage({
    required this.image,
    this.radius = 5,
    this.elevation = 5,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.boxFit = BoxFit.cover,
    this.hasCard = true,
  });

  @override
  Widget build(BuildContext context) {
    if (hasCard) {
      return Card(
        color: backgroundColor ?? Theme.of(context).cardTheme.color,
        margin: margin ?? Theme.of(context).cardTheme.margin,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: boxFit,
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                );
              },
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
        ),
      );
    }

    return Container(
      color: backgroundColor ?? Theme.of(context).cardTheme.color,
      margin: margin ?? Theme.of(context).cardTheme.margin,
      padding: padding ?? const EdgeInsets.all(0),
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(image),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).cardTheme.color,
        ),
        loadingBuilder: (context, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!,
            ),
          );
        },
      ),
    );
  }
}
