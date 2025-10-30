import 'package:bloc_app/presentation/widgets/textfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../assets/app_vector.dart';
import '../../core/localization_utils.dart';
import '../../core/snackbar_utils.dart';
import '../../l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_even.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    final translatedError = LocalizationUtils.translateError(
                      state.generalError,
                      language,
                    );
                    SnackbarUtils.showError(
                      context,
                      translatedError ??
                          language.unknown_error, // <-- Sửa ở đây
                      language, // <-- Truyền language vào
                    );
                  }
                  // Nếu đăng nhập thành công
                  else if (state.isSuccess) {
                    SnackbarUtils.showSuccess(
                      context,
                      language.login_success, // <-- SỬA Ở ĐÂY
                      language, // <-- Truyền language vào
                    );
                    context.read<CartBloc>().add(LoadCart());
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
                      labelText: language.email,
                      icon: Icon(Icons.email),
                      controller: emailController,
                      errorText: LocalizationUtils.translateError(
                        state.emailError,
                        language,
                      ),
                      onChanged: (value) {
                        context.read<AuthBloc>().add(EmailChanged(value));
                      },
                    ),
                    const SizedBox(height: 20),
                    Textfile(
                      labelText: language.password,
                      icon: Icon(Icons.lock),
                      isPassword: true,
                      controller: passwordController,
                      errorText: LocalizationUtils.translateError(
                        state.passwordError,
                        language,
                      ),
                      onChanged: (value) {
                        context.read<AuthBloc>().add(PasswordChanged(value));
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go("/forgot"),
                        child: Text(
                          language.forgot_password,
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
                      child: Text(
                        language.login,
                        style: TextStyle(fontSize: 16),
                      ),
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
                            language.or_login_with,
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
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginWithGoogle());
                            },
                            child: SvgPicture.asset(
                              AppVector.google,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () {
                              // Xử lý đăng nhập với Facebook
                            },
                            child: SvgPicture.asset(
                              AppVector.facebook,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(language.dont_have_account),
                        TextButton(
                          onPressed: () => context.go("/register"),
                          child: Text(
                            language.register,
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
      ),
    );
  }
}
