import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, BasicState<UserEntity>>(
      builder: (context, state) {
        // تحقق من حالة المستخدم عند بدء التطبيق
        if (state.status == StateStatus.initial) {
          context.read<UserCubit>().checkAuthState();
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == StateStatus.loading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // إذا كان المستخدم مسجل دخول (عادي أو Guest)
        if (state.data != null) {
          // return HomeScreen();
        }

        // إذا لم يكن مسجل دخول
        // return LoginScreen();

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
