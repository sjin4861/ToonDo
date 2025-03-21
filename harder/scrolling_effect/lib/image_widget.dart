import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Card(
        child: Image.network(
          'https://picsum.photos/id/${index + 12}/200/200',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
