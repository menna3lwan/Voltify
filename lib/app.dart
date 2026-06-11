import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/sign_up_cubit.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'injection_container.dart';

class VoltifyApp extends StatelessWidget {
  const VoltifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voltify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => sl<SignUpCubit>(),
        child: const SignUpScreen(),
      ),
    );
  }
}
