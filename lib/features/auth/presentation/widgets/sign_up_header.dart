import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/voltify_logo.png',
          width: AppDimensions.logoSize,
          height: AppDimensions.logoSize,
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
