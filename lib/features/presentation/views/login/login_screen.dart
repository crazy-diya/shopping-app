import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';
import 'package:shopingapp/features/presentation/bloc/login/signin_cubit.dart';
import 'package:shopingapp/utils/navigation_routes.dart';

import '../../../../core/services/dependency_injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _bloc = injection.call<SignInCubit>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    const String pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully Login Data')),
              );
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.kHomeView, (route) => false);
            } else if (state is ApiFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fail')),
              );
            } else if (state is DioExceptionFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fail')),
              );
            } else if (state is ServerFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fail')),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Login to Shopping App",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            _bloc.signInUser(SignInEntity(
                                email: _emailController.text,
                                password: _passwordController.text));
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
