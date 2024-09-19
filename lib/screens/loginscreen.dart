// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import 'package:material_text_fields/material_text_fields.dart';
import 'package:social/screens/signupscreen.dart';
import 'package:social/screens/wrapper.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool showing = false;
  bool isloading = false;

  signin() async {
    setState(() {
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
      Get.snackbar('Success', 'Logged In Successfully',
          duration: Duration(seconds: 1), snackStyle: SnackStyle.GROUNDED);
      Get.offAll(const Wrapper());
    } catch (e) {}
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Icon(
              //   Iconsax.cloud,
              //   size: 100,
              // ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Text(
                'Please enter your details to sign in',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              LottieBuilder.asset('assets/login.json'),
              const SizedBox(
                height: 40,
              ),

              MaterialTextField(
                controller: emailcontroller,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                hint: 'Email',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email_outlined),

                // controller: _emailTextController,
                // validator: FormValidation.emailTextField,
              ),

              const SizedBox(
                height: 20,
              ),
              MaterialTextField(
                obscureText: showing ? false : true,
                controller: passwordcontroller,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                hint: 'Password',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.password_rounded),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showing = !showing;
                      });
                    },
                    icon: showing
                        ? Icon(Icons.remove_red_eye_outlined)
                        : const Icon(Icons.remove_red_eye)),

                // controller: _emailTextController,
                // validator: FormValidation.emailTextField,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: signin,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50)),
                  alignment: Alignment.center,
                  child: isloading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Dont Have Account ?',
                    style: TextStyle(color: Colors.white),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Signupscreen();
                      }));
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                          color: Color(0XffF42D92),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
