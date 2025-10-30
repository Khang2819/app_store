import "package:bloc_app/presentation/bloc/auth/auth_even.dart";
import "package:bloc_app/presentation/widgets/textfile.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:loader_overlay/loader_overlay.dart";

import "../../core/localization_utils.dart";
import "../../core/snackbar_utils.dart";
import "../../l10n/app_localizations.dart";
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
    final language = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(language.register, style: TextStyle(color: Colors.black)),
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
                    SnackbarUtils.showSuccess(
                      context,
                      language.register_success, // <-- Sửa
                      language, // <-- Truyền
                    );
                    context.go("/login");
                  } else if (state.generalError != null) {
                    final translatedError = LocalizationUtils.translateError(
                      state.generalError,
                      language,
                    );
                    SnackbarUtils.showError(
                      context,
                      translatedError ?? language.unknown_error, // <-- Sửa
                      language, // <-- Truyền
                    );
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Textfile(
                      labelText: language.name,
                      icon: Icon(Icons.person),
                      controller: nameController,
                      errorText: LocalizationUtils.translateError(
                        state.nameError,
                        language,
                      ),
                      onChanged: (value) {
                        context.read<AuthBloc>().add(NameChanged(value));
                      },
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Textfile(
                      labelText: language.confirm_password,
                      icon: Icon(Icons.lock),
                      isPassword: true,
                      controller: confirmPasswordController,
                      errorText: LocalizationUtils.translateError(
                        state.confirmPasswordError,
                        language,
                      ),
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
                      child: Text(
                        language.register,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(language.already_have_account),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            language.login,
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
