import 'dart:math';

import 'package:flutter/material.dart';

class RoundedShadow extends StatelessWidget {
  final Widget? child;
  final Color? shadowColor;

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  const RoundedShadow({
    super.key,
    this.child,
    this.shadowColor,
    this.topLeftRadius = 48,
    this.topRightRadius = 48,
    this.bottomLeftRadius = 48,
    this.bottomRightRadius = 48,
  });

  const RoundedShadow.fromRadius(double radius,
      {super.key, this.child, this.shadowColor})
      : topLeftRadius = radius,
        topRightRadius = radius,
        bottomLeftRadius = radius,
        bottomRightRadius = radius;

  @override
  Widget build(BuildContext context) {
    //Create a border radius, the only applies to the bottom
    var r = BorderRadius.only(
      topLeft: Radius.circular(
        topLeftRadius,
      ),
      topRight: Radius.circular(
        topRightRadius,
      ),
      bottomLeft: Radius.circular(
        bottomLeftRadius,
      ),
      bottomRight: Radius.circular(
        bottomRightRadius,
      ),
    );
    var sColor = shadowColor ?? const Color(0x20000000);

    var maxRadius = [
      topLeftRadius,
      topRightRadius,
      bottomLeftRadius,
      bottomRightRadius
    ].reduce(max);
    return Container(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: [
          BoxShadow(color: sColor, blurRadius: maxRadius * .5),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: child,
      ),
    );
  }
}
