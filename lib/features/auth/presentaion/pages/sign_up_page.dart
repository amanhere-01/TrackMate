import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_mate/core/utils/show_snackbar.dart';
import 'package:track_mate/features/auth/bloc/auth_bloc.dart';
import 'package:track_mate/features/auth/presentaion/pages/sign_in_page.dart';
import 'package:track_mate/features/location/presentation/pages/home_page.dart';
import '../../../../core/theme/color_palette.dart';
import '../../../../core/widgets/loader.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/glass_box.dart';

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

  String validate(){
    if(nameController.text.isEmpty) return 'name';
    if(emailController.text.isEmpty) return 'email';
    if(passwordController.text.isEmpty) return 'password';
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthFailure){
            showSnackbar(context, state.message);
          } else if(state is AuthSuccess){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
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
                                AuthTextField(hint: 'Name', controller:nameController,isObscure: false, icon: Icons.person_2,),
                                const SizedBox(height: 20,),
                                AuthTextField(hint: 'Email', controller:emailController,isObscure: false, icon: Icons.email,),
                                const SizedBox(height: 20,),
                                AuthTextField(hint: 'Password', controller:passwordController,isObscure: true, icon: Icons.lock,),
                                const SizedBox(height: 40,),
                                ElevatedButton(
                                    onPressed: (){
                                      String emptyField = validate();
                                      if(emptyField=='null'){
                                        context.read<AuthBloc>().add(
                                            AuthSignUp(
                                                name: nameController.text.trim(),
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim()
                                            )
                                        );
                                      } else {
                                        showSnackbar(context, '$emptyField is empty!');
                                      }

                                    },
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
                        )
                    ),
                  )
                ) ,
              ),
              if(state is AuthLoading)
                const Loader()
            ]
          );
        },
      ),
    );
  }
}
