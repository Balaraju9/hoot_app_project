import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Loaders {
  static Widget dotLottieLoader() {
    return Center(
        child:
            Lottie.asset('assets/Lottie/loader.json', height: 100, width: 100));
  }

  static Widget emptyLottieLoader() {
    return Center(
        child:
            Lottie.asset('assets/Lottie/empty.json', height: 300, width: 300));
  }

  static Widget circleShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
    );
  }

  static Widget squareShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  static Widget rectShimmerLoader(double radius) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }

  static Widget circleLottieLoader() {
    return Center(
        child: Lottie.asset('assets/Lottie/circle_loader.json',
            height: 75, width: 75));
  }

  static Widget audioWaveLottieLoader() {
    return Lottie.asset(
      "assets/Lottie/audio.json",
      height: 100,
    );
  }
}
