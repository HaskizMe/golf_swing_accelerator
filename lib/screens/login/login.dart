import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import 'package:golf_accelerator_app/screens/onboarding/golfer_skill.dart';
import 'package:golf_accelerator_app/screens/onboarding/welcome.dart';
import 'package:golf_accelerator_app/theme/app_colors.dart';
import 'package:golf_accelerator_app/utils/error_dialog.dart';

import 'local_widgets/sign_in_button.dart';
import 'local_widgets/text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isSignUpMode = false;
  bool isLoading = false;
  final AuthService _auth = AuthService();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }

  void navigateToHome(){
    // navigation logic
    setState(() => isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (Route<dynamic> route) => false, // This condition removes all previous routes.
    );
  }

  Future<void> signUpWithEmail() async {
    setState(() => isLoading = true);

    // Sign up logic
    if(_password.text != _confirmPassword.text){
      showErrorDialog(context: context, errorMessage: "Passwords Didn't Match", solution: "Make sure passwords match");
    } else{
      String? message = await _auth.signup(email: _email.text, password: _password.text, context: context);
      if(message == null) {
        setState(() {
          isSignUpMode = false;
        });
      } else {
        showErrorDialog(context: context, errorMessage: "Sign Up Failed", solution: message!);
      }
    }
    setState(() => isLoading = false);

  }

  Future<void> signInWithEmail() async {
    setState(() => isLoading = true);

    String? response = await _auth.signin(email: _email.text, password: _password.text, context: context);
    if(response == null) {
      navigateToHome();
    } else {
      showErrorDialog(context: context, errorMessage: "Sign In Failed", solution: response);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/blackLogin.svg',),
                    const SizedBox(height: 20,),
                    CustomTextField(hintText: "Email Address", controller: _email,),
                    const SizedBox(height: 20,),
                    CustomTextField(hintText: "Password", obscureText: true, controller: _password,),

                    AnimatedCrossFade(
                      firstChild: Container(), // Empty container for login mode
                      secondChild: Column(
                        children: [
                          const SizedBox(height: 20),
                          CustomTextField(hintText: "Confirm Password", obscureText: true, controller: _confirmPassword,),
                        ],
                      ),
                      crossFadeState: isSignUpMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),

                    const SizedBox(height: 15,),

                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.blue, AppColors.lightBlue]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if(isSignUpMode){
                            signUpWithEmail();
                          } else {
                            signInWithEmail();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          overlayColor: Colors.black,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          textStyle: const TextStyle(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            isSignUpMode ? "Sign Up" : "Sign In",
                            key: ValueKey(isSignUpMode),
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15,),

                    SignInButton(
                      text: 'Sign in With Google',
                      image: Image.asset("assets/google1.png"),
                      onTap: () async {
                        setState(() => isLoading = true);

                        UserCredential? userCredential = await _auth.signInWithGoogle();
                        if(userCredential != null){
                          navigateToHome();
                        }
                        setState(() => isLoading = false);

                      },
                    ),
                    const SizedBox(height: 5,),
                    SignInButton(
                      text: 'Sign in With Facebook',
                      image: SvgPicture.asset("assets/facebook 3.svg"),
                      onTap: () async {
                        setState(() => isLoading = true);

                        UserCredential? userCredential = await _auth.signInWithFacebook();
                        if(userCredential != null){
                          navigateToHome();
                        }
                        setState(() => isLoading = false);

                      },
                    ),
                    const SizedBox(height: 5,),
                    SignInButton(text: 'Sign in With Apple', image: SvgPicture.asset("assets/apple-logo 1.svg"), onTap: () {  },),
                    const SizedBox(height: 5,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isSignUpMode ? "Already have an account?" : "Are you a new user?"),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isSignUpMode = !isSignUpMode;
                            });
                          },
                          style: TextButton.styleFrom(
                            overlayColor: Colors.blue.withOpacity(0.1),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              isSignUpMode ? "Login Here" : "Sign Up",
                              key: ValueKey(isSignUpMode),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loader Overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white,),
              ),
            ),
        ],


      ),
    );
  }
}