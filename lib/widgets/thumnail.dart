import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Thumbnail extends StatelessWidget {
  final String url;
  final String avgColor;
  const Thumbnail({Key? key, required this.url, required this.avgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: url,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 350),
        ),
        color: Color(int.parse(code(avgColor))));
  }

  String code(String code) {
    return '0xff' + code.substring(1);
  }
}
