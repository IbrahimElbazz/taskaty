import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskaty/shared/widgets/custom_button.dart';
import 'package:taskaty/shared/widgets/custom_text_field.dart';
import 'package:taskaty/core/app_config.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_states.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark
          ? AppConfig.darkBackgroundColor
          : AppConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('نسيت كلمة المرور'),
        backgroundColor: isDark ? AppConfig.darkCardColor : AppConfig.cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('خطأ في إعادة تعيين كلمة المرور'),
                  content: Text(message),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthCubit>().clearError();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            },
            unauthenticated: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('تم الإرسال'),
                  content: const Text(
                    'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('حسناً'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppConfig.paddingL),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 60.h),

                      // Icon and Title
                      _buildHeader(),
                      SizedBox(height: AppConfig.paddingXXL),

                      // Email Field
                      _buildEmailField(),
                      SizedBox(height: AppConfig.paddingXL),

                      // Reset Password Button
                      _buildResetButton(),
                      SizedBox(height: AppConfig.paddingL),

                      // Back to Login
                      _buildBackToLogin(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppConfig.darkTextSecondaryColor
        : AppConfig.textSecondaryColor;

    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: AppConfig.warningColor,
            borderRadius: BorderRadius.circular(AppConfig.radiusXXL),
            boxShadow: [
              BoxShadow(
                color: AppConfig.warningColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.lock_rotation,
            size: 40.sp,
            color: CupertinoColors.white,
          ),
        ),
        SizedBox(height: AppConfig.paddingL),
        Text(
          'إعادة تعيين كلمة المرور',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppConfig.paddingM),
        Text(
          'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور',
          style: TextStyle(
            fontSize: 16.sp,
            color: secondaryTextColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      label: 'البريد الإلكتروني',
      hint: 'أدخل بريدك الإلكتروني',
      prefixIcon: Icon(CupertinoIcons.mail, color: AppConfig.primaryColor),
      keyboardType: TextInputType.emailAddress,
      isRequired: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال البريد الإلكتروني';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildResetButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CustomButton(
          onPressed: state.maybeWhen(
            loading: () => null,
            orElse: () => _resetPassword,
          ),
          text: state.maybeWhen(
            loading: () => 'جاري الإرسال...',
            orElse: () => 'إرسال رابط إعادة التعيين',
          ),
          isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
        );
      },
    );
  }

  Widget _buildBackToLogin() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'العودة لتسجيل الدخول',
        style: TextStyle(
          color: AppConfig.primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
