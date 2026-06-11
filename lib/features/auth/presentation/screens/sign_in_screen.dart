import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../cubit/sign_in_cubit.dart';
import '../cubit/sign_in_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SignInCubit>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<SignInCubit, SignInState>(
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
                      _buildHeader(),
                      const SizedBox(height: AppDimensions.xxxl),
                      _buildFormSection(),
                      const SizedBox(height: AppDimensions.xxl),
                      _buildActionSection(),
                      const SizedBox(height: AppDimensions.xl),
                      _buildSignUpNavigation(),
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

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/voltify_logo.png',
          width: AppDimensions.logoSize,
          height: AppDimensions.logoSize,
        ),
        const SizedBox(height: AppDimensions.xl),
        Text(
          AppStrings.signInTitle,
          style: AppTextStyles.heading1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          AppStrings.signInSubtitle,
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (prev, curr) =>
          prev.isPasswordVisible != curr.isPasswordVisible ||
          prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return Column(
          children: [
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
            CustomTextField(
              controller: _passwordController,
              label: AppStrings.password,
              hintText: AppStrings.passwordHint,
              obscureText: !state.isPasswordVisible,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
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
                    context.read<SignInCubit>().togglePasswordVisibility(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionSection() {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.signInButton,
          isLoading: state.isLoading,
          onPressed: state.isLoading ? null : _onSignIn,
        );
      },
    );
  }

  Widget _buildSignUpNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.dontHaveAccount, style: AppTextStyles.bodyMedium),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text(AppStrings.createAccount, style: AppTextStyles.link),
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, SignInState state) {
    if (state.isSuccess && state.user != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeScreen(user: state.user!),
        ),
        (_) => false,
      );
    } else if (state.isFailure && state.errorMessage != null) {
      _showSnackBar(message: state.errorMessage!, isError: true);
      context.read<SignInCubit>().clearError();
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
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.white),
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
