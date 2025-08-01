import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/LoginScreen.dart';
import 'package:inventory_management/models/usermodel.dart';
import 'package:inventory_management/showDialog.dart';

// import 'package:inventory_app/utilities/Show_Error_Dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _nameController = TextEditingController();
  final _unameController = TextEditingController();
  final _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
bool _isPasswordVisible = false;
  Future<void> _addUserToFirestore(myUser newUser) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': newUser.name,
        'username': newUser.username,
        'phone': newUser.phone,
        'imageUrl':
            'https://microbiology.ucr.edu/sites/default/files/styles/form_preview/public/blank-profile-pic.png?itok=4teBBoet', // Add logic to handle profile image upload
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added to Firestore')),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error adding users: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding user: $e')),
      );
    }
  }

  void initstate() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Registration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            Image.asset(
              "assets/images/register.png",
              height: MediaQuery.of(context).size.height * .3,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .700,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(107, 59, 225, .85),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18))),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        cursorColor: const Color.fromRGBO(107, 10, 225, 1),
                        controller: _nameController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_3_outlined,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          hintText: 'Enter your full name',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        cursorColor: const Color.fromRGBO(107, 10, 225, 1),
                        controller: _unameController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.supervised_user_circle_outlined,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          hintText: 'User Name',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        cursorColor: const Color.fromRGBO(107, 10, 225, 1),
                        controller: _phoneController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          hintText: 'Enter your Phone number',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: const Color.fromRGBO(107, 10, 225, 1),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            hintText: 'Enter your Email Here',
                            hintStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        cursorColor: const Color.fromRGBO(107, 10, 225, 1),
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          
                        
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          hintText: 'Enter your Password Here',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              backgroundColor: WidgetStateProperty.all(
                                  const Color.fromRGBO(107, 59, 225, 1)),
                              shape:
                                  WidgetStateProperty.all<RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ))),
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
        
                            print('caleb1');
        
                            myUser newUser = myUser(
                              name: _nameController.text,
                              username: _unameController.text,
                              phone: _phoneController.text,
                            );
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
        
                              print('caleb2');
        
                              final user = FirebaseAuth.instance.currentUser;
                              await user?.sendEmailVerification();
        
                              _addUserToFirestore(newUser);
                              _email.clear();
                              _nameController.clear();
                              _password.clear();
                              _unameController.clear();
                              _phoneController.clear();
        
        
        
                              if (user != null) {
                                showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Email Verification'),
                                      content: const Text(
                                          'Please check your email and verify your account.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            // Start checking email verification status
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              //
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'Weak-Password') {
                                // ignore: use_build_context_synchronously
                                showErrorDialog(context, 'Weak Password');
                              } else if (e.code == 'email-already-in-use') {
                                // ignore: use_build_context_synchronously
                                showErrorDialog(context, 'Email Already in Use');
                              } else if (e.code == 'invalid-email') {
                                // ignore: use_build_context_synchronously
                                showErrorDialog(context, 'Invalid Email Entered');
                              } else {
                                // ignore: use_build_context_synchronously
                                await showErrorDialog(context, 'Error ${e.code}');
                              }
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              await showErrorDialog(context, e.toString());
                            }
                          },
                          child: const Text('Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22)),
                        ),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          const Text(
                            'already have an account.. ',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            child: TextButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                    backgroundColor: WidgetStateProperty.all(
                                        const Color.fromRGBO(107, 59, 225, 1)),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView()));
                                },
                                child: const Text(
                                  'Login here ',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
