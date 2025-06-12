import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/ProductModel.dart';

class ImageSlider extends ConsumerStatefulWidget {
  final List<dynamic> images;
  final double height;

   ImageSlider({required this.images,required this.height });

  @override
  ConsumerState<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends ConsumerState<ImageSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Image Slider
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Image.network(
                  widget.images[index].imageUrl ??
                      "https://th.bing.com/th/id/OIP.GnqZiwU7k5f_kRYkw8FNNwHaF3?rs=1&pid=ImgDetMain",
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) =>  Icon(
                        Icons.image_not_supported_outlined,
                        size: 50.h,
                        color: Colors.grey,
                      ),
                ),
              );
            },
          ),
        ),

        // Image Index Indicators
        Positioned(
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => Container(
                margin:  EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
