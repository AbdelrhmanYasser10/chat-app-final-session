import 'dart:io';

import 'package:chat_app_final/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app_final/layout/main_layout.dart';
import 'package:chat_app_final/utils/my_text_form_field/my_text_form_field.dart';
import 'package:chat_app_final/utils/text_style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/my_button/my_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confPasswordController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is GetImageSuccessfully) {
          AppCubit.get(context).cropImage();
        }
        if (state is RegisterSuccessfully) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainLayout(),
            ),
          );
        }
        if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Register",
              style: AppTextStyle.appBarTextStyle(),
            ),
            elevation: 0.0,
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        cubit.finalImage == null
                            ? const CircleAvatar(
                                radius: 64.0,
                                backgroundImage: NetworkImage(
                                    "https://www.refugee-action.org.uk/wp-content/uploads/2016/10/anonymous-user.png"),
                              )
                            : CircleAvatar(
                                radius: 64.0,
                                backgroundImage: FileImage(
                                  File(
                                    cubit.finalImage!.path,
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              onPressed: () {
                                cubit.pickImage();
                              },
                              icon: Icon(
                                cubit.finalImage == null
                                    ? Icons.add
                                    : Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            controller: _emailController,
                            prefixIcon: const Icon(
                              Icons.email,
                            ),
                            hintText: "Email",
                            validation: (p0) {},
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          MyTextFormField(
                            controller: _usernameController,
                            prefixIcon: const Icon(
                              Icons.person,
                            ),
                            hintText: "Username",
                            validation: (p0) {},
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          MyTextFormField(
                            controller: _passwordController,
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            hintText: "Password",
                            validation: (p0) {},
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          MyTextFormField(
                            controller: _confPasswordController,
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            hintText: "Confirm Password",
                            validation: (p0) {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    state is RegisterLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue.shade900,
                            ),
                          )
                        : MyButton(
                            text: "Register",
                            onPressed: () {
                              cubit.register(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text,
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
