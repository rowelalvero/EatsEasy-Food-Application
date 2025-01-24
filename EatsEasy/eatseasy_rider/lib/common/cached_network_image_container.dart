import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/constants.dart';

class CachedNetworkImageContainer extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  const CachedNetworkImageContainer({super.key,
    required this.imagePath, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage( //image size fill
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: LoadingAnimationWidget.threeArchedCircle(
            color: kPrimary,
            size: 35
        ),// you can add pre loader iamge as well to show loading.
      ), //show progress  while loading image
      errorWidget: (context, url, error) => Image.asset("images/flutter.png"),
      //show no image available image on error loading
    );
  }
}
