import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskaty/core/app_config.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_states.dart';
import '../../../authentication/data/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark
          ? AppConfig.darkBackgroundColor
          : AppConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Taskaty'),
        backgroundColor: isDark ? AppConfig.darkCardColor : AppConfig.cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
            width: 0.5,
          ),
        ),
        trailing: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return state.maybeWhen(
              authenticated: (user) => CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showUserMenu(context, user),
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  backgroundColor: AppConfig.primaryColor,
                  child: user.photoURL == null
                      ? Text(
                          user.displayName?.substring(0, 1).toUpperCase() ??
                              'U',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CupertinoActivityIndicator()),
            loading: () => const Center(child: CupertinoActivityIndicator()),
            authenticated: (user) => _buildHomeContent(context, user),
            unauthenticated: () =>
                const Center(child: Text('يرجى تسجيل الدخول')),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('خطأ: $message'),
                  SizedBox(height: AppConfig.paddingM),
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('خطأ في التطبيق'),
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
                    child: const Text('عرض التفاصيل'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUserMenu(BuildContext context, UserModel user) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('مرحباً، ${user.displayName ?? 'المستخدم'}'),
        message: Text(user.email),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to profile screen
            },
            child: const Text('الملف الشخصي'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to settings screen
            },
            child: const Text('الإعدادات'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().signOut();
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, UserModel user) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppConfig.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, user),
            SizedBox(height: AppConfig.paddingXL),

            // Quick Stats
            _buildQuickStats(context),
            SizedBox(height: AppConfig.paddingXL),

            // Quick Actions
            _buildQuickActions(context),
            SizedBox(height: AppConfig.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConfig.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConfig.primaryColor, AppConfig.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConfig.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppConfig.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: CupertinoColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConfig.radiusL),
            ),
            child: user.photoURL != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppConfig.radiusL),
                    child: Image.network(user.photoURL!, fit: BoxFit.cover),
                  )
                : Icon(
                    CupertinoIcons.person_fill,
                    size: 30.sp,
                    color: CupertinoColors.white,
                  ),
          ),
          SizedBox(width: AppConfig.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً، ${user.displayName ?? 'المستخدم'}!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.white,
                  ),
                ),
                SizedBox(height: AppConfig.paddingXS),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CupertinoColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائيات سريعة',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: AppConfig.paddingM),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: CupertinoIcons.check_mark_circled,
                title: 'المهام الكلية',
                value: '0',
                color: AppConfig.primaryColor,
              ),
            ),
            SizedBox(width: AppConfig.paddingM),
            Expanded(
              child: _StatCard(
                icon: CupertinoIcons.check_mark_circled_solid,
                title: 'المكتملة',
                value: '0',
                color: AppConfig.successColor,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConfig.paddingM),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: CupertinoIcons.clock,
                title: 'قيد التنفيذ',
                value: '0',
                color: AppConfig.warningColor,
              ),
            ),
            SizedBox(width: AppConfig.paddingM),
            Expanded(
              child: _StatCard(
                icon: CupertinoIcons.exclamationmark_circle,
                title: 'متأخرة',
                value: '0',
                color: AppConfig.errorColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: AppConfig.paddingM),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: CupertinoIcons.add_circled,
                title: 'إضافة مهمة',
                subtitle: 'إنشاء مهمة جديدة',
                onTap: () {
                  // TODO: Navigate to add task screen
                },
              ),
            ),
            SizedBox(width: AppConfig.paddingM),
            Expanded(
              child: _ActionCard(
                icon: CupertinoIcons.list_bullet,
                title: 'عرض المهام',
                subtitle: 'إدارة جميع المهام',
                onTap: () {
                  // TODO: Navigate to tasks list screen
                },
              ),
            ),
          ],
        ),
        SizedBox(height: AppConfig.paddingM),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: CupertinoIcons.calendar,
                title: 'التقويم',
                subtitle: 'عرض المهام حسب التاريخ',
                onTap: () {
                  // TODO: Navigate to calendar screen
                },
              ),
            ),
            SizedBox(width: AppConfig.paddingM),
            Expanded(
              child: _ActionCard(
                icon: CupertinoIcons.chart_bar,
                title: 'التقارير',
                subtitle: 'إحصائيات مفصلة',
                onTap: () {
                  // TODO: Navigate to reports screen
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppConfig.darkCardColor : AppConfig.cardColor;
    final secondaryTextColor = isDark
        ? AppConfig.darkTextSecondaryColor
        : AppConfig.textSecondaryColor;

    return Container(
      padding: EdgeInsets.all(AppConfig.paddingM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppConfig.radiusL),
        border: Border.all(
          color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28.sp, color: color),
          SizedBox(height: AppConfig.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: AppConfig.paddingXS),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppConfig.darkCardColor : AppConfig.cardColor;
    final textColor = isDark
        ? AppConfig.darkTextPrimaryColor
        : AppConfig.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppConfig.darkTextSecondaryColor
        : AppConfig.textSecondaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConfig.paddingM),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppConfig.radiusL),
          border: Border.all(
            color: isDark ? AppConfig.darkBorderColor : AppConfig.borderColor,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.sp, color: AppConfig.primaryColor),
            SizedBox(height: AppConfig.paddingS),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConfig.paddingXS),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11.sp, color: secondaryTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
