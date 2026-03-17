import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF0D1117),
      highlightColor: const Color(0xFF1E2530),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Color(0xFF0D1117),
            border: Border(bottom: BorderSide(color: Color(0xFF111820))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 60, height: 14, color: Colors.white),
                const SizedBox(width: 8),
                Container(width: 40, height: 14, color: Colors.white),
              ]),
              const SizedBox(height: 8),
              Container(width: double.infinity, height: 14, color: Colors.white),
              const SizedBox(height: 4),
              Container(width: 220, height: 14, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
