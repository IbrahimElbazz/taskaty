import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_config.dart';
import '../../core/translations.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final String locale;
  final bool isDestructive;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.locale = 'en',
    this.isDestructive = false,
  });

    @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = isDestructive 
        ? AppConfig.errorColor 
        : (backgroundColor ?? AppConfig.primaryColor);
    final defaultTextColor = textColor ?? CupertinoColors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: CupertinoButton(
        onPressed: isLoading ? null : onPressed,
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(AppConfig.radiusM),
        padding: EdgeInsets.symmetric(horizontal: AppConfig.paddingM),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CupertinoActivityIndicator(color: defaultTextColor),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18.sp, color: defaultTextColor),
                    SizedBox(width: AppConfig.paddingS),
                  ],
                  Text(
                    Translations.tr(text, locale: locale),
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: defaultTextColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final String locale;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final defaultBorderColor =
        borderColor ??
        (isDark ? AppConfig.darkBorderColor : AppConfig.borderColor);
    final defaultTextColor =
        textColor ??
        (isDark ? AppConfig.darkTextPrimaryColor : AppConfig.textPrimaryColor);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: defaultBorderColor),
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
        ),
        child: CupertinoButton(
          onPressed: isLoading ? null : onPressed,
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
          padding: EdgeInsets.symmetric(horizontal: AppConfig.paddingM),
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CupertinoActivityIndicator(color: defaultTextColor),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18.sp, color: defaultTextColor),
                      SizedBox(width: AppConfig.paddingS),
                    ],
                    Text(
                      Translations.tr(text, locale: locale),
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: defaultTextColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
