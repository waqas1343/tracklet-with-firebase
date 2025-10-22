import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool circularBack; // 👈 new property
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.circularBack = false, // 👈 default false
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      leadingWidth: circularBack ? 50 : 40, // 👈 spacing adjust
      titleSpacing: circularBack ? 0 : null,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                child: Container(
                  decoration: circularBack
                      ? BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: titleColor ?? AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: titleColor ?? AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
