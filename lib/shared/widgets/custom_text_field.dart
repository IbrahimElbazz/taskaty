import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_config.dart';
import '../../core/translations.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final String locale;
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.locale = 'en',
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppConfig.darkTextSecondaryColor
        : AppConfig.textSecondaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Translations.tr(label, locale: locale),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: AppConfig.paddingXS),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConfig.errorColor,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: AppConfig.paddingS),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppConfig.darkCardColor : AppConfig.cardColor,
            borderRadius: BorderRadius.circular(AppConfig.radiusM),
            border: Border.all(
              color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
            ),
          ),
          child: CupertinoTextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            maxLength: maxLength,
            enabled: enabled,
            onTap: onTap,
            placeholder: hint != null
                ? Translations.tr(hint!, locale: locale)
                : null,
            placeholderStyle: TextStyle(
              color: secondaryTextColor,
              fontSize: 16.sp,
            ),
            style: TextStyle(color: textColor, fontSize: 16.sp),
            padding: EdgeInsets.symmetric(
              horizontal: AppConfig.paddingM,
              vertical: AppConfig.paddingM,
            ),
            decoration: null,
            prefix: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: AppConfig.paddingM),
                    child: prefixIcon!,
                  )
                : null,
            suffix: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: AppConfig.paddingM),
                    child: suffixIcon!,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final VoidCallback? onChanged;
  final VoidCallback? onSubmitted;
  final String locale;

  const CustomSearchField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppConfig.darkTextSecondaryColor
        : AppConfig.textSecondaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppConfig.darkCardColor : AppConfig.cardColor,
        borderRadius: BorderRadius.circular(AppConfig.radiusL),
        border: Border.all(
          color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
        ),
      ),
      child: CupertinoSearchTextField(
        controller: controller,
        placeholder: placeholder ?? Translations.tr('search', locale: locale),
        placeholderStyle: TextStyle(color: secondaryTextColor, fontSize: 16.sp),
        style: TextStyle(color: textColor, fontSize: 16.sp),
        onChanged: (value) => onChanged?.call(),
        onSubmitted: (value) => onSubmitted?.call(),
        padding: EdgeInsets.symmetric(
          horizontal: AppConfig.paddingM,
          vertical: AppConfig.paddingS,
        ),
      ),
    );
  }
}
