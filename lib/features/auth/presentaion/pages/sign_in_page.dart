import 'package:flutter/material.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/features/auth/pages/sign_up_page.dart';
import 'package:track_mate/features/auth/widgets/auth_text_field.dart';

import '../widgets/glass_box.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/core/assets/images/auth_background.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child:  GlassBox(
                  height: 520.0,
                  child: Column(
                    children: [
                      const Text(
                          'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 40,),
                      AuthTextField(hint: 'Email', controller:emailController,isObscure: false, icon: Icons.email_outlined,),
                      const SizedBox(height: 20,),
                      AuthTextField(hint: 'Password', controller:passwordController,isObscure: true, icon: Icons.lock_outline,),
                      const SizedBox(height: 40,),
                      ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width,60),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 20,
                              color: ColorPalette.primary,
                              fontWeight: FontWeight.w500
                          ),
                        )
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style:Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white
                            ),
                            children: const [
                              TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.primary
                                  )
                              )
                            ]
                          ),
                        ),
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
