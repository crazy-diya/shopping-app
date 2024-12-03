import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/utils/app_colors.dart';
import 'package:shopingapp/utils/navigation_routes.dart';

import '../../../../core/services/dependency_injection.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  File? _imageFile;
  final _nameController = TextEditingController(text: "John Doe");
  final _emailController = TextEditingController(text: "john.doe@example.com");

  final _user = injection.call<FirebaseAuth>();
  final appShared = injection.call<AppSharedData>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
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
            ElevatedButton(onPressed: () {}, child: const Text("SAVE DATA!")),
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
              child: const Text("Logout!"),
            )
          ],
        ),
      ),
    );
  }
}
