import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/sign_up_cubit.dart';
import '../cubit/sign_up_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/sign_up_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<SignUpCubit>().signUp(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<SignUpCubit, SignUpState>(
        listener: _handleStateChanges,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
                vertical: AppDimensions.screenPaddingV,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppDimensions.xxl),

                      // ──── Header Section ────
                      const SignUpHeader(),
                      const SizedBox(height: AppDimensions.xxxl),

                      // ──── Form Section ────
                      _buildFormSection(),
                      const SizedBox(height: AppDimensions.xxl),

                      // ──── Action Section ────
                      _buildActionSection(),
                      const SizedBox(height: AppDimensions.xl),

                      // ──── Sign In Navigation ────
                      _buildSignInNavigation(),
                      const SizedBox(height: AppDimensions.xxl),
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

  Widget _buildFormSection() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (prev, curr) =>
          prev.isPasswordVisible != curr.isPasswordVisible ||
          prev.isConfirmPasswordVisible != curr.isConfirmPasswordVisible ||
          prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return Column(
          children: [
            // Full Name
            CustomTextField(
              controller: _fullNameController,
              label: AppStrings.fullName,
              hintText: AppStrings.fullNameHint,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: Validators.validateFullName,
              enabled: !state.isLoading,
            ),
            const SizedBox(height: AppDimensions.lg),

            // Email
            CustomTextField(
              controller: _emailController,
              label: AppStrings.email,
              hintText: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmail,
              enabled: !state.isLoading,
            ),
            const SizedBox(height: AppDimensions.lg),

            // Phone Number
            CustomTextField(
              controller: _phoneController,
              label: AppStrings.phoneNumber,
              hintText: AppStrings.phoneNumberHint,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: Validators.validatePhoneNumber,
              enabled: !state.isLoading,
            ),
            const SizedBox(height: AppDimensions.lg),

            // Password
            CustomTextField(
              controller: _passwordController,
              label: AppStrings.password,
              hintText: AppStrings.passwordHint,
              obscureText: !state.isPasswordVisible,
              textInputAction: TextInputAction.next,
              validator: Validators.validatePassword,
              enabled: !state.isLoading,
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textHint,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () =>
                    context.read<SignUpCubit>().togglePasswordVisibility(),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Confirm Password
            CustomTextField(
              controller: _confirmPasswordController,
              label: AppStrings.confirmPassword,
              hintText: AppStrings.confirmPasswordHint,
              obscureText: !state.isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !state.isLoading,
              validator: (value) => Validators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textHint,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () => context
                    .read<SignUpCubit>()
                    .toggleConfirmPasswordVisibility(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionSection() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.createAccountButton,
          isLoading: state.isLoading,
          onPressed: state.isLoading ? null : _onCreateAccount,
        );
      },
    );
  }

  Widget _buildSignInNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: AppTextStyles.bodyMedium,
        ),
        GestureDetector(
          onTap: () {
            // Navigate to Sign In screen (not in scope).
          },
          child: Text(
            AppStrings.signIn,
            style: AppTextStyles.link,
          ),
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, SignUpState state) {
    if (state.isSuccess) {
      _showSnackBar(
        message: AppStrings.signUpSuccess,
        isError: false,
      );
    } else if (state.isFailure && state.errorMessage != null) {
      _showSnackBar(
        message: state.errorMessage!,
        isError: true,
      );
      context.read<SignUpCubit>().clearError();
    }
  }

  void _showSnackBar({required String message, required bool isError}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        margin: const EdgeInsets.all(AppDimensions.lg),
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }
}
