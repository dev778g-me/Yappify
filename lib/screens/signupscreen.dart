import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:social/screens/wrapper.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final emailcontroll = TextEditingController();
  final passwordcontroll = TextEditingController();
  final biocontroll = TextEditingController();
  final namecontroll = TextEditingController();
  bool showing = false;
  bool isloading = false;
  signup() async {
    setState(() {
      isloading = true;
    });
    try {
      final User = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroll.text, password: passwordcontroll.text);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(User.user!.uid)
          .set({
        'email ': emailcontroll.text,
        'name': namecontroll.text,
        'bio': biocontroll.text,
        'followers': [],
        'following': [],
        'pfp': '',
        'id': User.user!.uid
      }).then((_) {
        Get.snackbar('Success', 'Logged in Successfully',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            snackPosition: SnackPosition.TOP);
      });
      Get.offAll(const Wrapper());
    } on FirebaseAuthException catch (e) {
      return Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP);
    }
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
                'Welcome User',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Please enter your details to Create Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              LottieBuilder.asset(
                'assets/login.json',
                height: 250,
              ),
              const SizedBox(
                height: 40,
              ),
              MaterialTextField(
                controller: namecontroll,
                keyboardType: TextInputType.name,
                hint: 'Name',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Iconsax.personalcard),

                // controller: _emailTextController,
                // validator: FormValidation.emailTextField,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialTextField(
                controller: biocontroll,
                keyboardType: TextInputType.text,
                hint: 'Bio',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Iconsax.message_favorite),

                // controller: _emailTextController,
                // validator: FormValidation.emailTextField,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialTextField(
                controller: emailcontroll,

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
                controller: passwordcontroll,
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
                  icon: Icon(
                    showing
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (namecontroll.text.isNotEmpty &&
                      emailcontroll.text.isNotEmpty &&
                      passwordcontroll.text.isNotEmpty &&
                      biocontroll.text.isNotEmpty) {
                    signup();
                  } else {
                    Get.snackbar('Error', 'Please Fill Out All Required Fields',
                        backgroundColor: Colors.red.withOpacity(0.1),
                        colorText: Colors.red,
                        snackPosition: SnackPosition.TOP);
                  }
                },
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
                          'Create Account',
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
            ],
          ),
        ),
      )),
    );
  }
}
