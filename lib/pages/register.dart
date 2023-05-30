// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/shared/colors.dart';
import 'package:flower_app/shared/contants.dart';
import 'package:flower_app/shared/snackbar.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isVisable = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordchar = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;

  onPasswordChanged(String password) {
    isPasswordchar = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;

    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPasswordchar = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  register() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, "Error - Please try again later.");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextField(
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your username : ",
                            suffixIcon: Icon(Icons.person))),
                    const SizedBox(
                      height: 33,
                    ),
                    TextFormField(
                        validator: (email) {
                          return email!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Email : ",
                            suffixIcon: Icon(Icons.email))),
                    const SizedBox(
                      height: 33,
                    ),
                    TextFormField(
                        onChanged: (password) {
                          onPasswordChanged(password);
                        },
                        validator: (value) {
                          return value!.length < 8
                              ? "Enter at least 8 characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: isVisable ? true : false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Password : ",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisable = !isVisable;
                                  });
                                },
                                icon: isVisable
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)))),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPasswordchar ? Colors.green : Colors.white,
                            //  border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("At least 8 characters")
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPasswordHas1Number
                                ? Colors.green
                                : Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("At least 1 number")
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasUppercase ? Colors.green : Colors.white,
                            //  border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("Has Uppercase")
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasLowercase ? Colors.green : Colors.white,
                            //  border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("Has lowercase")
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasSpecialCharacters
                                ? Colors.green
                                : Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("Has Special Characters")
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          register();
                        } else {
                          showSnackBar(context, "Error");
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Register",
                              style: TextStyle(fontSize: 19),
                            ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(BTNgreen),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do not have an account?",
                            style: TextStyle(fontSize: 18)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: Text('sign in',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
