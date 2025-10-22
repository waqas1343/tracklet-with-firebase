// Shimmer Loader - Skeleton loading state
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Shimmer.fromColors(
      baseColor: theme.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: theme.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Summary Card Shimmer
class SummaryCardShimmer extends StatelessWidget {
  const SummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Provider.of<ThemeProvider>(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: Provider.of<ThemeProvider>(context).shadowMd,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoader(width: 100, height: 16),
              ShimmerLoader(width: 40, height: 40),
            ],
          ),
          SizedBox(height: 16),
          ShimmerLoader(width: 120, height: 32),
          SizedBox(height: 8),
          ShimmerLoader(width: 80, height: 12),
        ],
      ),
    );
  }
}

// Activity Feed Shimmer
class ActivityFeedShimmer extends StatelessWidget {
  const ActivityFeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              ShimmerLoader(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(width: double.infinity, height: 14),
                    SizedBox(height: 8),
                    ShimmerLoader(width: 150, height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// User Row Shimmer
class UserRowShimmer extends StatelessWidget {
  const UserRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          ShimmerLoader(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(width: double.infinity, height: 16),
                SizedBox(height: 8),
                ShimmerLoader(width: 200, height: 12),
              ],
            ),
          ),
          ShimmerLoader(width: 80, height: 32),
        ],
      ),
    );
  }
}
