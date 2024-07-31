import 'package:flutter/material.dart';
import 'package:track_mate/features/auth/pages/sign_in_page.dart';
import 'package:track_mate/features/auth/widgets/glass_box.dart';

import '../../../core/theme/color_palette.dart';
import '../widgets/auth_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    child: GlassBox(
                      height: 650.0,
                      child: Column(
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 40,),
                          AuthTextField(hint: 'Name', controller:passwordController,isObscure: false, icon: Icons.person_2,),
                          const SizedBox(height: 20,),
                          AuthTextField(hint: 'Email', controller:emailController,isObscure: false, icon: Icons.email,),
                          const SizedBox(height: 20,),
                          AuthTextField(hint: 'Password', controller:passwordController,isObscure: true, icon: Icons.lock,),
                          const SizedBox(height: 40,),
                          ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width,60),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              ),
                              child: const Text(
                                'Sign Up',
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
                                      builder: (context) => const SignInPage()));
                            },
                            child: RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style:Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white
                                  ),
                                  children: const [
                                    TextSpan(
                                        text: 'Sign In',
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
                )
            ),
          )
        ) ,
      ),
    );
  }
}
