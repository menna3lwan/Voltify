import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/sign_up_cubit.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../../../../injection_container.dart';

class HomeScreen extends StatelessWidget {
  final UserEntity user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/voltify_logo.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: AppDimensions.sm),
            Text('Voltify', style: AppTextStyles.heading2),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
            tooltip: 'Sign Out',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.lg),
              _buildGreeting(),
              const SizedBox(height: AppDimensions.xxl),
              _buildEnergyOverview(),
              const SizedBox(height: AppDimensions.xxl),
              _buildUsageCards(),
              const SizedBox(height: AppDimensions.xxl),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          user.displayName,
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          'Here\'s your energy summary for today.',
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }

  Widget _buildEnergyOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xxl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Usage',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '18.4',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppDimensions.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'kWh',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              const Icon(Icons.trending_down_rounded, color: Colors.greenAccent, size: 16),
              const SizedBox(width: 4),
              Text(
                '12% less than yesterday',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.greenAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Monthly Summary', style: AppTextStyles.label),
        const SizedBox(height: AppDimensions.md),
        const Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.bolt_rounded,
                iconColor: Color(0xFF8B5CF6),
                label: 'This Month',
                value: '412 kWh',
                sub: 'Jun 2026',
              ),
            ),
            SizedBox(width: AppDimensions.md),
            Expanded(
              child: _StatCard(
                icon: Icons.receipt_long_rounded,
                iconColor: Color(0xFF0EA5E9),
                label: 'Estimated Bill',
                value: '\$58.40',
                sub: 'Due Jul 15',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        const Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.wb_sunny_rounded,
                iconColor: Color(0xFFF59E0B),
                label: 'Solar Generated',
                value: '120 kWh',
                sub: 'This month',
              ),
            ),
            SizedBox(width: AppDimensions.md),
            Expanded(
              child: _StatCard(
                icon: Icons.eco_rounded,
                iconColor: Color(0xFF22C55E),
                label: 'CO₂ Saved',
                value: '48 kg',
                sub: 'This month',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      ('HVAC System', '06:00 AM', '3.2 kWh', Icons.ac_unit_rounded),
      ('Water Heater', '07:30 AM', '1.8 kWh', Icons.water_rounded),
      ('Kitchen Appliances', '08:15 AM', '0.9 kWh', Icons.kitchen_rounded),
      ('EV Charging', '10:00 AM', '8.5 kWh', Icons.ev_station_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTextStyles.label),
        const SizedBox(height: AppDimensions.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: activities.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                      vertical: AppDimensions.md,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Icon(item.$4, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.$1, style: AppTextStyles.label),
                              Text(item.$2, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        Text(item.$3, style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        )),
                      ],
                    ),
                  ),
                  if (idx < activities.length - 1)
                    const Divider(height: 1, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppDimensions.huge),
      ],
    );
  }

  void _signOut(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<SignUpCubit>(),
          child: const SignUpScreen(),
        ),
      ),
      (_) => false,
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppDimensions.xs),
          Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
          Text(sub, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
