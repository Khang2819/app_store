import 'package:bloc_app/presentation/widgets/textfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../assets/app_vector.dart';
import '../../core/snackbar_utils.dart';
import '../../l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_even.dart';
import '../bloc/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
              // Chỉ lắng nghe khi trạng thái isLoading hoặc isSuccess thay đổi
              return previous.isLoading != current.isLoading ||
                  previous.isSuccess != current.isSuccess ||
                  previous.generalError != current.generalError;
            },
            listener: (context, state) {
              if (state.isLoading) {
                // show loading
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
                // Nếu có lỗi, hiển thị SnackBar lỗi
                if (state.generalError != null) {
                  SnackbarUtils.showError(context, state.generalError!);
                }
                // Nếu đăng nhập thành công
                else if (state.isSuccess) {
                  SnackbarUtils.showSuccess(context, 'Đăng nhập thành công!');
                  context.go('/home');
                }
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  SvgPicture.asset(AppVector.logo, width: 150, height: 150),
                  const SizedBox(height: 40),
                  Textfile(
                    labelText: "Email",
                    icon: Icon(Icons.email),
                    controller: emailController,
                    errorText: state.emailError,
                    onChanged: (value) {
                      context.read<AuthBloc>().add(EmailChanged(value));
                    },
                  ),
                  const SizedBox(height: 20),
                  Textfile(
                    labelText: "Password",
                    icon: Icon(Icons.lock),
                    isPassword: true,
                    controller: passwordController,
                    errorText: state.passwordError,
                    onChanged: (value) {
                      context.read<AuthBloc>().add(PasswordChanged(value));
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push('/forgot');
                      },
                      child: Text(
                        "Quên mật khẩu?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2A4ECA),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginWithEmailEvent(
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    child: Text(language.login, style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[300]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Hoặc đăng nhập với',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chưa có tài khoản?'),
                      TextButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
