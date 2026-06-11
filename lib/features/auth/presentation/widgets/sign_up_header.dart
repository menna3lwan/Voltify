import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Header section: V logo, "Create Account" title, "Join Voltify today" subtitle.
class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ──── Logo: "V" on gradient rounded square ────
        Container(
          width: AppDimensions.logoSize,
          height: AppDimensions.logoSize,
          decoration: BoxDecoration(
            gradient: AppColors.logoGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Center(
            child: Text(
              'V',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                height: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),

        // ──── Title ────
        Text(
          AppStrings.createAccount,
          style: AppTextStyles.heading1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.xs),

        // ──── Subtitle ────
        Text(
          AppStrings.welcomeDescription,
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
