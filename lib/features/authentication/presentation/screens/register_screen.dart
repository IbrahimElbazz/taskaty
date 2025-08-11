import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskaty/shared/widgets/custom_button.dart';
import 'package:taskaty/shared/widgets/custom_text_field.dart';
import 'package:taskaty/core/app_config.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _signUpWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );
    }
  }

  void _signInWithGoogle() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _signInWithApple() {
    context.read<AuthCubit>().signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark
          ? AppConfig.darkBackgroundColor
          : AppConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('إنشاء حساب'),
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
                  title: const Text('خطأ في إنشاء الحساب'),
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
                      SizedBox(height: 40.h),

                      // Logo and Title
                      _buildHeader(),
                      SizedBox(height: AppConfig.paddingXXL),

                      // Form Fields
                      _buildFormFields(),
                      SizedBox(height: AppConfig.paddingL),

                      // Sign Up Button
                      _buildSignUpButton(),
                      SizedBox(height: AppConfig.paddingL),

                      // Social Login
                      _buildSocialLogin(),
                      SizedBox(height: AppConfig.paddingXXL),

                      // Login Link
                      _buildLoginLink(),
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
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: AppConfig.primaryColor,
            borderRadius: BorderRadius.circular(AppConfig.radiusXXL),
            boxShadow: [
              BoxShadow(
                color: AppConfig.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.person_add_solid,
            size: 35.sp,
            color: CupertinoColors.white,
          ),
        ),
        SizedBox(height: AppConfig.paddingL),
        Text(
          'إنشاء حساب جديد',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppConfig.paddingS),
        Text(
          'انضم إلينا لإدارة مهامك بكفاءة',
          style: TextStyle(fontSize: 16.sp, color: secondaryTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          label: 'الاسم الكامل',
          hint: 'أدخل اسمك الكامل',
          prefixIcon: Icon(
            CupertinoIcons.person,
            color: AppConfig.primaryColor,
          ),
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال الاسم';
            }
            if (value.length < 2) {
              return 'الاسم يجب أن يكون حرفين على الأقل';
            }
            return null;
          },
        ),
        SizedBox(height: AppConfig.paddingM),
        CustomTextField(
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
        ),
        SizedBox(height: AppConfig.paddingM),
        CustomTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          hint: 'أدخل كلمة المرور',
          prefixIcon: Icon(CupertinoIcons.lock, color: AppConfig.primaryColor),
          obscureText: _obscurePassword,
          isRequired: true,
          suffixIcon: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Icon(
              _obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              color: AppConfig.textSecondaryColor,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال كلمة المرور';
            }
            if (value.length < 6) {
              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
            }
            return null;
          },
        ),
        SizedBox(height: AppConfig.paddingM),
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          hint: 'أعد إدخال كلمة المرور',
          prefixIcon: Icon(
            CupertinoIcons.lock_shield,
            color: AppConfig.primaryColor,
          ),
          obscureText: _obscureConfirmPassword,
          isRequired: true,
          suffixIcon: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            child: Icon(
              _obscureConfirmPassword
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash,
              color: AppConfig.textSecondaryColor,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى تأكيد كلمة المرور';
            }
            if (value != _passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CustomButton(
          onPressed: state.maybeWhen(
            loading: () => null,
            orElse: () => _signUpWithEmailAndPassword,
          ),
          text: state.maybeWhen(
            loading: () => 'جاري إنشاء الحساب...',
            orElse: () => 'إنشاء حساب',
          ),
          isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
        );
      },
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDivider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConfig.paddingM),
              child: Text(
                'أو',
                style: TextStyle(
                  color: AppConfig.textSecondaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Expanded(child: _buildDivider()),
          ],
        ),
        SizedBox(height: AppConfig.paddingL),
        Row(
          children: [
            Expanded(
              child: _SocialLoginButton(
                onPressed: _signInWithGoogle,
                icon: CupertinoIcons.globe,
                text: 'Google',
                color: AppConfig.errorColor,
              ),
            ),
            SizedBox(width: AppConfig.paddingM),
            Expanded(
              child: _SocialLoginButton(
                onPressed: _signInWithApple,
                icon: CupertinoIcons.device_phone_portrait,
                text: 'Apple',
                color: AppConfig.textPrimaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
    );
  }

  Widget _buildLoginLink() {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark
        ? AppConfig.darkTextSecondaryColor
        : AppConfig.textSecondaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
          style: TextStyle(color: secondaryTextColor, fontSize: 14.sp),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: AppConfig.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final Color color;

  const _SocialLoginButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? AppConfig.darkBorderColor
        : AppConfig.borderColor;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;

    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: isDark ? AppConfig.darkCardColor : AppConfig.cardColor,
        borderRadius: BorderRadius.circular(AppConfig.radiusM),
        border: Border.all(color: borderColor),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(AppConfig.radiusM),
        padding: EdgeInsets.symmetric(horizontal: AppConfig.paddingM),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(width: AppConfig.paddingS),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
