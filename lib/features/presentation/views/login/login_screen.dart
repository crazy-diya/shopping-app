import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/data/model/request/user_profile_request_model.dart';
import 'package:shopingapp/features/domain/entities/sign_in_entity.dart';
import 'package:shopingapp/features/presentation/bloc/login/signin_cubit.dart';
import 'package:shopingapp/utils/app_strings.dart';
import 'package:shopingapp/utils/app_validations.dart';
import 'package:shopingapp/utils/navigation_routes.dart';

import '../../../../core/services/dependency_injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _bloc = injection.call<SignInCubit>();
  final _appShared = injection.call<AppSharedData>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<SignInCubit, SignInState>(
          listener: (context, state) async {
            if (state is SignInSuccessState) {
              await _bloc.getUserDetails(
                UserProfileRequest(
                  uid: _appShared.getData(uID),
                ),
              );
            } else if (state is ProfileSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.successLogin)),
              );
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.kHomeView, (route) => false);
            } else if (state is ApiFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid Email or Password')),
              );
            } else if (state is DioExceptionFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fail')),
              );
            } else if (state is ServerFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Something Went wrong!')),
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
                        validator: AppValidations.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        obscureText: true,
                        validator: AppValidations.validatePassword,
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
                        child: const Text('Login'),
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
