import 'package:flutter/material.dart';
import 'package:launchpad/services/auth_service.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/base_text_field.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  final bool? isWeb;
  final bool isSignUp;
  final Function? onAuthCancel;
  const AuthenticationPage(
      {super.key,
      this.onAuthCancel,
      this.isWeb = true,
      required this.isSignUp});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool isSignUp = false;

  bool hidePw = true;

  @override
  void initState() {
    isSignUp = widget.isSignUp;
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      widget.onAuthCancel!();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.close,
                            color: AppStyles.iconColor)),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSignUp = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: isSignUp
                              ? AppStyles.actionButtonColor
                              : AppStyles.panelColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('SIGN UP',
                          style: AppStyles.poppinsBold22.copyWith(
                              color: isSignUp ? Colors.white : Colors.white60)),
                    ),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSignUp = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: !isSignUp
                              ? AppStyles.actionButtonColor
                              : AppStyles.panelColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('SIGN IN',
                          style: AppStyles.poppinsBold22.copyWith(
                              color:
                                  !isSignUp ? Colors.white : Colors.white60)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: BasicTextField(
                  autofocus: true,
                  controller: emailController,
                  hintText: 'email',
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (isSignUp)
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: BasicTextField(
                  autofocus: false,
                  controller: usernameController,
                  hintText: 'username',
                ),
              ),
            if (isSignUp) const SizedBox(height: 18),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: BasicTextField(
                controller: passwordController,
                obscure: true,
                hintText: 'password',
              ),
            ),
            Consumer<AuthService>(
                builder: (ctx, auth, _) => BasicButton(
                    isMobile: PlatformServices.isWebMobile,
                    onClick: () async {
                      bool isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        if (isSignUp) {
                          await auth.signUpWithEmail(
                              email: emailController.text,
                              password: passwordController.value.text.trim(),
                              username: usernameController.value.text.trim());
                          // setState(() {});
                          //signup
                        } else {
                          //signin
                          await auth.signInWithEmail(
                              email: emailController.text,
                              password: passwordController.value.text.trim());
                          // setState(() {});
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            BaseSnackbar.buildSnackBar(context,
                                message: 'Missing required field',
                                success: false));
                      }
                    },
                    label: isSignUp ? 'SIGN UP' : "SIGN IN"))
          ],
        ),
      ),
    );
  }
}
