import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/models/usermodel.dart';

class ProfileEditPage extends StatelessWidget {
  final myUser user;
  const ProfileEditPage(this.user, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(107, 59, 225, 1),
        title: Row(
          children: [
            SizedBox(
              width: 12,
            ),
            const Text('Edit Profile'),
          ],
        ),
      ),
      body: ProfileEditForm(user: user),
    );
  }
}

class ProfileEditForm extends StatefulWidget {
  final myUser user;

  const ProfileEditForm({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  late FirebaseFirestore _firestore;

  late File _pickedImage; // Use File for selected image

  late ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _pickedImage = File('');
    _initializeControllers();
    _firestore = FirebaseFirestore.instance;
  }

  void _initializeControllers() {
    _fullNameController.text = widget.user.name;
    _phoneController.text = widget.user.phone;
    _usernameController.text = widget.user.username;
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: _pickImage,
            child: Container(
              alignment: Alignment.center,
              height: 150.0,
              width: 150,
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(107, 59, 225, 1)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: _pickedImage.path.isEmpty
                  ? const Icon(Icons.camera_alt,
                      size: 60.0, color: Color.fromRGBO(107, 59, 225, 1))
                  : Image.file(
                      _pickedImage, // Use the File object here
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _fullNameController,
            cursorColor: const Color.fromRGBO(107, 59, 225, 1),
            decoration: const InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(107, 59, 225, 1)))),
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _phoneController,
            cursorColor: const Color.fromRGBO(107, 59, 225, 1),
            decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(107, 59, 225, 1)))),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _usernameController,
            cursorColor: const Color.fromRGBO(107, 59, 225, 1),
            decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(107, 59, 225, 1)))),
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 16.0),
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromRGBO(107, 59, 225, 1))),
              onPressed: () async {
                Map<String, dynamic> updateUserInfo = {};
                if (_fullNameController != widget.user.name) {
                  updateUserInfo['name'] = _fullNameController.text;
                }
                if (_phoneController.text != widget.user.phone.toString()) {
                  updateUserInfo['phone'] = _phoneController.text;
                }

                if (_usernameController.text != widget.user.username) {
                  updateUserInfo['username'] = _usernameController.text;
                }

                // Upload the new image if selected
                if (_pickedImage.existsSync() &&
                    _pickedImage.path != widget.user.imageUrl) {
                  final String fileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  final Reference storageReference = FirebaseStorage.instance
                      .ref()
                      .child('Users_images/$fileName.jpg');
                  final UploadTask uploadTask =
                      storageReference.putFile(_pickedImage);

                  TaskSnapshot taskSnapshot = await uploadTask;
                  String imageUrl = await taskSnapshot.ref.getDownloadURL();
                  updateUserInfo['imageUrl'] = imageUrl; // Update the image URL
                }

                try {
                  await _firestore
                      .collection('users')
                      .doc(widget.user.uid)
                      .update(updateUserInfo);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile  updated successfully'),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, true);
                } catch (error) {
                  // ignore: avoid_print
                  print('Error updating User Info: $error');
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error updating product'),
                    ),
                  );
                }
                setState(() {
                  _pickedImage = File(''); // Clear the picked image
                });
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              )),
        ],
      )),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  myUser? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

 Future<void> _fetchUserData() async {
  print('[DEBUG] _fetchUserData() started');
  
  User? firebaseUser = _auth.currentUser;
  print('[DEBUG] Current user: ${firebaseUser?.uid ?? 'null'}');

  if (firebaseUser != null) {
    print('[DEBUG] Starting Firestore fetch...');
    try {
      DocumentSnapshot userDataSnapshot = 
          await _firestore.collection('users').doc(firebaseUser.uid).get()
              .timeout(const Duration(seconds: 10));
      
      print('[DEBUG] Firestore fetch completed');
      
      if (userDataSnapshot.exists) {
        print('[DEBUG] Document exists, updating state');
        setState(() {
          _user = myUser(
            uid: firebaseUser.uid,
            name: userDataSnapshot['name'],
            username: userDataSnapshot['username'],
            phone: userDataSnapshot['phone'],
            imageUrl: userDataSnapshot['imageUrl'],
          );
        });
        print('[DEBUG] State updated successfully');
      } else {
        print('[DEBUG] ERROR: Document does not exist');
      }
    } catch (e) {
      print('[DEBUG] EXCEPTION during fetch: $e');
    }
  } else {
    print('[DEBUG] No authenticated user');
  }
  print('[DEBUG] _fetchUserData() completed');
}

  Future<void> _loadUserProfile() async {
    // Load user profile data and update _userProfile
    // Use your data fetching mechanism, such as Firestore

    setState(() {
      _fetchUserData();
    });
  }

  void _navigateToProfileEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(_user!),
      ),
    );
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(107, 59, 225, 1),
        title: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            const Text('Profile page'),
          ],
        ),
      ),
      body: Center(
        child: _user != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(107, 59, 225, 1),
                      radius: 120,
                      backgroundImage: NetworkImage(_user!.imageUrl),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Text(
                            'Full Name            ${_user!.name}',
                            style: const TextStyle(fontSize: 20),
                          )),
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Text(
                            'User Name          ${_user!.username}',
                            style: const TextStyle(fontSize: 20),
                          )),
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Text(
                            'Phone                   ${_user!.phone}',
                            style: const TextStyle(fontSize: 20),
                          )),
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _navigateToProfileEdit();
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromRGBO(107, 59, 225, 1),
                      )),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: const Center(
                              child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ))),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
    );
  }
}
