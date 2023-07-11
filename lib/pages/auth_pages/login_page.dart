import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reusables/reusables.dart';
import 'package:um_core/um_core.dart';
import 'package:reusables/mixins/form_state_mixin.dart';
import 'package:user_management_web/pages/sidebar_with_panel/main_panel.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isTextObscured = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 100,
              horizontal: 20,
            ),
            child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .padding
                            .top)),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            title: 'Login',
                            fontSize: 32,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,),
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: emailController,
                          hint: "Enter you email",
                          label: "Email",
                          validator: InputValidator.email(
                            message: 'Enter valid email',
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppTextField(
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: passwordController,
                          obscure: isTextObscured,
                          label: "Password",
                          hint: "Enter your password",
                          suffix: GestureDetector(
                            onTap: () {
                              isTextObscured = !isTextObscured;
                              setState(() {});
                            },
                            child: isTextObscured
                                ? const Icon(CupertinoIcons.eye)
                                : const Icon(CupertinoIcons.eye_slash,
                              color: AppColors.primaryColor,),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        AppElevatedButton(
                          onPressed: submitter,
                          isFullWidth: true,
                          backgroundColor: AppColors.primaryColor,
                          child: const Text("Login"),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> onSubmit() async {
    try {
      await Awaiter.process(
          future: process(),
          arguments: "Signing In",
          context: context);
    } catch (e) {
      if (!mounted) return;
      PopUpDialog(e.toString(), isError: true,).show(context);
    }
  }

  Future<void> process() async {
    try {
      final List<AdminModel> data = await AdminFirestoreLoginService()
          .fetchAllList();
      String email = data[0].email;
      String password = data[0].email;
      String ? userId = AppData.getUserId('id');
      if (email == emailController.text &&
          password == passwordController.text) {
        if (userId == null) AppData.setUserId('admin');
        if (!mounted) return;
        AppNavigator.pushAndRemoveUntil(context, const MainPanelScreen());
      } else {
        if (email != emailController.text &&
            password == passwordController.text) {
          if (!mounted) return;
          const PopUpDialog('Email incorrect', isError: true,).show(context);
        } else {
          if (!mounted) return;
          const PopUpDialog('Password incorrect', isError: true,).show(context);
        }
      }
    } catch (_) {
      rethrow;
    }
  }

}
