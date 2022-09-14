import 'package:chat_support/widgets/custom_terminos.dart';
import 'package:flutter/material.dart';

import 'package:chat_support/widgets/custom_button.dart';
import 'package:chat_support/widgets/custom_input.dart';
import 'package:chat_support/widgets/custom_label_footer.dart';
import 'package:chat_support/widgets/custom_label_header.dart';
import 'package:chat_support/widgets/custom_logo.dart';
import 'dart:developer';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
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
                CustomLabelHeader(text: 'Register'),
                SizedBox(height: 40),
                _FormRegister(),
                SizedBox(height: 20),
                CustomLabelFooter(
                  route: 'login',
                  question: '¿Ya estas registrado?',
                  action: 'Ingresar ahora!',
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

class _FormRegister extends StatefulWidget {
  const _FormRegister();

  @override
  State<_FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<_FormRegister> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.person,
            placeholder: 'Username',
            keyboardType: TextInputType.text,
            textController: usernameController,
          ),
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
            text: 'Register',
            onPressed: () {
              log(usernameController.text);
              log(emailController.text);
              log(passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
