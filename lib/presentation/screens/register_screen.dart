import "package:bloc_app/presentation/bloc/auth/auth_even.dart";
import "package:bloc_app/presentation/widgets/textfile.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "../bloc/auth/auth_bloc.dart";
import "../bloc/auth/auth_state.dart";

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go("/login");
          },
        ),
        title: const Text("Register"),
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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  builder:
                      (_) => const Center(child: CircularProgressIndicator()),
                );
              } else {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng ký thành công!")),
                );
                context.go("/login");
              }
              if (state.generalError != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.generalError!)));
              }
            },
            builder: (context, state) {
              return Column(
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
                    child: const Text("Register"),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text("Already have an account? Login"),
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
