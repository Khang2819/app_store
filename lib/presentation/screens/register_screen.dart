import "package:bloc_app/presentation/bloc/auth/auth_even.dart";
import "package:bloc_app/presentation/widgets/textfile.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:loader_overlay/loader_overlay.dart";

import "../../core/snackbar_utils.dart";
import "../bloc/auth/auth_bloc.dart";
import "../bloc/auth/auth_state.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Register", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.go("/login");
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) {
                // Chỉ listen khi loading state thay đổi
                return previous.isLoading != current.isLoading ||
                    previous.isSuccess != current.isSuccess;
              },
              listener: (context, state) {
                if (state.isLoading) {
                  context.loaderOverlay.show();
                } else {
                  context.loaderOverlay.hide();
                  if (state.isSuccess) {
                    SnackbarUtils.showSuccess(context, "Đăng ký thành công!");
                    context.go("/login");
                  } else if (state.generalError != null) {
                    SnackbarUtils.showError(context, state.generalError!);
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Textfile(
                      labelText: "Name",
                      icon: Icon(Icons.person),
                      controller: nameController,
                      errorText: state.nameError,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(NameChanged(value));
                      },
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Textfile(
                      labelText: "Confirm Password",
                      icon: Icon(Icons.lock),
                      isPassword: true,
                      controller: confirmPasswordController,
                      errorText: state.confirmPasswordError,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(
                          ConfirmPasswordChanged(value),
                        );
                      },
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2A4ECA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          RegisterWithEmailEvent(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Đã có tài khoản"),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            "Đăng nhập",
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
