import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_core/shop_core.dart';
import '../bloc/auth/auth_admin_bloc.dart';
import '../bloc/auth/auth_admin_event.dart';
import '../bloc/auth/auth_admin_state.dart';
import '../widgets/custom_text_field.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginAdminScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;

          return Row(
            children: [
              if (isDesktop)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                          Color(0xFF1A73E8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.3),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            AppVector.icon,
                            package: 'shop_core',
                            width: 420,
                            height: 150,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Quản lý hệ thống Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: _buildLoginForm(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return BlocConsumer<AuthAdminBloc, AuthAdminState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.isSuccess) {
          SnackbarUtils.showSuccess(context, 'Đăng nhập thành công', null);
          context.pushReplacement('/dashboard');
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Color(0xFF667eea).withOpacity(0.8),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Chào mừng trở lại! 👋",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Text(
                'Đăng nhập để tiếp tục quản trị',
                style: TextStyle(fontSize: 15, color: Colors.black45),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                icon: Icon(
                  Icons.email_outlined,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
              ),
              // Email
              const SizedBox(height: 25),

              // Password
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                isPassword: true,
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Quên mật khẩu',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: () {
                            context.read<AuthAdminBloc>().add(
                              LoginRequested(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A73E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
