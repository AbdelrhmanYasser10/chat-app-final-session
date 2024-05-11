import 'package:chat_app_final/screens/register_screen.dart';
import 'package:chat_app_final/utils/my_button/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/app_cubit/app_cubit.dart';
import '../layout/main_layout.dart';
import '../utils/my_text_form_field/my_text_form_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is LoginSuccessfully) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainLayout()),
                  (route) => false);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'chat with friends easily',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              MyFormField(
                                controller: _emailController,
                                prefixIcon: const Icon(Icons.email_outlined),
                                text: "Email",
                                validator: (value) {
                                  RegExp regex = RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$");
                                  if (!regex.hasMatch(value!)) {
                                    return "Invalid Email";
                                  }
                                  if (value.isEmpty) {
                                    return "Email can not be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              MyFormField(
                                controller: _passwordController,
                                isPassword: true,
                                isSecured: true,
                                prefixIcon: const Icon(Icons.lock),
                                text: "Password",
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return "Password must be more than 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen()),
                                    (route) => false);
                          },
                          child: const Text(
                            'Register',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    MyButton(
                      text: "Login",
                      onPressed: () {
                        cubit.login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
