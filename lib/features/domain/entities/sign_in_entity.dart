import '../../data/model/request/sign_in_model.dart';

class SignInEntity extends SignInModel {
  String? email;
  String? password;

  SignInEntity({
    this.email,
    this.password,
  });
}