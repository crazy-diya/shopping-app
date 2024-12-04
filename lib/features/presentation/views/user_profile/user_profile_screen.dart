import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/data/model/response/user_profile_response_model.dart';
import 'package:shopingapp/features/presentation/bloc/profile/profile_cubit.dart';
import 'package:shopingapp/utils/app_colors.dart';
import 'package:shopingapp/utils/navigation_routes.dart';

import '../../../../core/services/dependency_injection.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _user = injection.call<FirebaseAuth>();
  final appShared = injection.call<AppSharedData>();
  final _bloc = injection.call<ProfileCubit>();

  File? _imageFile;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: "john.doe@example.com");

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _editField(
      BuildContext context, String title, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter $title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {}); // Update UI after editing
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = appShared.getData(name);
    _emailController.text = appShared.getData(email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccessState) {
              appShared.setData(name, state.userProfileResponse!.name!);
              appShared.setData(email, state.userProfileResponse!.email!);
              // setState(() {
              //   _emailController.text = state.userProfileResponse!.email!;
              //   _nameController.text = state.userProfileResponse!.name!;
              // });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Image.network(
                            appShared.getData(image),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("Name"),
                  subtitle: Text(_nameController.text),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _editField(context, "Name", _nameController),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Email"),
                  subtitle: Text(_emailController.text),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _editField(context, "Email", _emailController),
                ),
                const Divider(),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      _bloc.updateUserDetails(
                        UserProfileResponse(
                          name: _nameController.text,
                          email: _emailController.text,
                        ),
                      );
                    },
                    child: const Text("SAVE DATA!")),
                ElevatedButton(
                  onPressed: () async {
                    await _user.signOut().then(
                      (value) {
                        appShared.clearData(uID);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.kLoginView,
                          (route) => false,
                        );
                      },
                    );
                  },
                  child: Text("Logout!"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
