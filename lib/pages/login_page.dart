import 'package:chat_support/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:chat_support/widgets/custom_input.dart';
import 'package:chat_support/widgets/custom_label_footer.dart';
import 'package:chat_support/widgets/custom_label_header.dart';
import 'package:chat_support/widgets/custom_logo.dart';
import 'package:chat_support/widgets/custom_terminos.dart';
import 'dart:developer';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                CustomLogo(urlLogo: 'assets/logos/tag-logo.png'),
                CustomLabelHeader(text: 'Chat support'),
                SizedBox(height: 40),
                _FormLogin(),
                SizedBox(height: 20),
                CustomLabelFooter(
                  route: 'register',
                  question: '¿No tienes cuenta?',
                  action: 'Crear una cuenta ahora!',
                ),
                CustomTerminosCondiciones(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLogin extends StatefulWidget {
  const _FormLogin();

  @override
  State<_FormLogin> createState() => __FormLoginState();
}

class __FormLoginState extends State<_FormLogin> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outlined,
            placeholder: 'Password',
            textController: passwordController,
            isPassword: true,
          ),
          CustomButton(
            text: 'Login',
            onPressed: () {
              log(emailController.text);
              log(passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
