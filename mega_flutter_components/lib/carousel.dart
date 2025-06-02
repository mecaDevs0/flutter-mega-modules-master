import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final double height;
  final List<Widget> widgets;
  final bool indicator;
  final double viewportFraction;
  final Function()? onLoadMore;
  final Key carouselKey;

  const Carousel({
    required this.height,
    required this.widgets,
    required this.carouselKey,
    this.viewportFraction = 1,
    this.indicator = true,
    this.onLoadMore,
  }) : super(key: carouselKey);

  @override
  CarouselState createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  late PageController _pageController;
  double _currentPage = 0;
  List<Widget> widgets = [];

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: 1,
    );

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });

    this.widgets.addAll(widget.widgets);
    _addLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            pageSnapping: false,
            controller: _pageController,
            children: this.widgets,
          ),
        ),
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
    for (int i = 0; i < widget.widgets.length; i++) {
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

  void _addLoadMore() {
    if (widget.onLoadMore != null) {
      widgets.add(
        GestureDetector(
          onTap: widget.onLoadMore,
          child: Container(
            height: 207,
            child: const Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: Center(
                  child: Icon(
                    Icons.more_horiz,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void insertItems(List<Widget> newItems) {
    setState(() {
      widgets.removeLast();
      widgets.addAll(newItems);
      _addLoadMore();
      _pageController.jumpToPage(_currentPage.toInt() + 2);
    });
  }

  void clean() {
    setState(() {
      widgets.clear();
    });
  }
}
