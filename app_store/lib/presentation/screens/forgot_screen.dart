// import 'package:shop_core/core/localization_utils.dart';
import 'package:bloc_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:bloc_app/presentation/bloc/auth/auth_even.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_core/l10n/app_localizations.dart';
import 'package:shop_core/shop_core.dart';

import '../bloc/auth/auth_state.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            language.forgot_password,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go("/login"),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.isSuccess) {
                SnackbarUtils.showSuccess(
                  context,
                  language.forgot_password_success, // <-- Sửa
                  language, // <-- Truyền
                );
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
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(language.reset_password, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                    language.reset_password_description,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: language.email,
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      errorText: LocalizationUtils.translateError(
                        state.emailError,
                        language,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<AuthBloc>().add(EmailChanged(value));
                    },
                    keyboardType: TextInputType.emailAddress,
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
                        ForgotPasswordEvent(email: emailController.text),
                      );
                      // Xử lý gửi email đặt lại mật khẩu
                    },
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            language.send_request,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
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
