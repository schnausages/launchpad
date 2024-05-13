import 'package:flutter/material.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';

class AuthAlertBox extends StatelessWidget {
  final Function signupTap;
  final Function signinTap;
  final bool isMobileWeb;

  const AuthAlertBox(
      {super.key,
      required this.signinTap,
      required this.signupTap,
      required this.isMobileWeb});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .9,
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
              color: AppStyles.panelColor,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🤔', style: AppStyles.poppinsBold22),
                  const SizedBox(width: 8.0),
                  Text('You\'re not signed up!',
                      style: AppStyles.poppinsBold22.copyWith(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10.0),
              BasicButton(
                  isMobile: PlatformServices.isWebMobile,
                  onClick: () {
                    signupTap();
                  },
                  label: 'SIGN UP')
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Have an account? ',
                  style: AppStyles.poppinsBold22.copyWith(fontSize: 16)),
              InkWell(
                onTap: () {
                  signinTap();
                },
                child: Text('Sign in',
                    style: AppStyles.poppinsBold22.copyWith(
                        fontSize: 22, decoration: TextDecoration.underline)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
