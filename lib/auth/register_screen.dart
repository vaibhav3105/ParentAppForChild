import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2_apps/auth/login_screen.dart';
import 'package:firebase_2_apps/auth/verify_email_screen.dart';
import 'package:firebase_2_apps/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import '../utils/helper.dart';
import '../utils/styling.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  String? name = "";
  String? email = "";
  String? password = "";
  bool isLoading = false;
  bool isVisible = false;

  @override
  Future register(String email, String password, String userName) async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await Helper.saveUserLoggedInStatus(true);

        nextScreen(context, VerifyEmailScreen());

        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "email": email,
          "userName": name,
          "id": FirebaseAuth.instance.currentUser!.uid,
          "rules": [],
          "children": [],
          "daysBackup": 30
        });
      } on FirebaseAuthException catch (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message!,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Parent",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Create your account now to access child",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600]),
                ),
                // Image.asset("assets/register.png"),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Lottie.network(
                      "https://assets1.lottiefiles.com/packages/lf20_tpa51dr0.json",
                      height: 200,
                      width: 200),
                ),
                TextFormField(
                  onChanged: (newValue) {
                    name = newValue;
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (newValue) {
                    email = newValue;
                  },
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (newValue) {
                    password = newValue;
                  },
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password have atleast 6 characters";
                    }
                    return null;
                  },
                  obscureText: !isVisible,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? Icon(
                              Icons.visibility,
                              color: Colors.black,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      register(
                        email!.trim(),
                        password!.trim(),
                        name!.trim(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, LoginScreen());
                      },
                      child: Text(
                        "Sign In Now",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                if (isLoading)
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
