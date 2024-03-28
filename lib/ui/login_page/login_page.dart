// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/ui/login_page/login_page_form.dart';
import 'package:todo_app/ui/register_page/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void _navigateToRegisterPage() {
    setState(() {
      formKey.currentState?.reset();
      _emailController.clear();
      _passController.clear();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPageHome(),
      ),
    );
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppThemeSettings appTheme = AppThemeSettings();
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              decoration: appTheme.getBackgroundTheme,
              child: Column(
                children: [
                  const _LoginPageHeader(),
                  50.height,
                  const _LoginPageImage(),
                  30.height,
                  LoginPageForm(
                    emailController: _emailController,
                    passwordController: _passController,
                    formKey: formKey,
                  ),
                  30.height,
                  _LoginToRegisterButton(
                    navigateToRegisterPage: _navigateToRegisterPage,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginPageHeader extends StatelessWidget {
  const _LoginPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AppThemeSettings appTheme = AppThemeSettings();
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      height: height / 14,
      width: width,
      decoration: appTheme.getHeaderTheme,
      padding: const EdgeInsets.only(left: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Login Page', style: appTheme.getHeaderTextTheme),
      ),
    );
  }
}

class _LoginPageImage extends StatelessWidget {
  const _LoginPageImage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      width: width,
      height: height / 7,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Image.asset(
        'assets/tvsimage.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _LoginToRegisterButton extends StatelessWidget {
  const _LoginToRegisterButton(
      {super.key, required this.navigateToRegisterPage});

  final Function() navigateToRegisterPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
            ),
            TextSpan(
              text: "Sign Up",
              style: const TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  fontFamily: 'Roboto'),
              recognizer: TapGestureRecognizer()
                ..onTap = navigateToRegisterPage,
            )
          ],
        ),
      ),
    );
  }
}
