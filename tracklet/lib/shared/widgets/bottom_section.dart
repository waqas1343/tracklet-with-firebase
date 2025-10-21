import 'package:flutter/material.dart';

/// BottomSection: Reusable bottom section widget
///
/// Provides consistent bottom area styling with action buttons
class BottomSection extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const BottomSection({
    super.key,
    required this.children,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
