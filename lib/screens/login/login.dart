import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golf_accelerator_app/screens/login/local_widgets/sign_in_button.dart';
import 'package:golf_accelerator_app/screens/login/local_widgets/text_field.dart';
import 'package:golf_accelerator_app/screens/onboarding/onboarding.dart';
import 'package:golf_accelerator_app/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUpMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/blackLogin.svg',),
                const SizedBox(height: 20,),
                CustomTextField(hintText: "Email Address"),
                const SizedBox(height: 20,),
                CustomTextField(hintText: "Password", obscureText: true,),

                AnimatedCrossFade(
                  firstChild: Container(), // Empty container for login mode
                  secondChild: const Column(
                    children: [
                      SizedBox(height: 20),
                      CustomTextField(hintText: "Confirm Password", obscureText: true),
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
                    gradient: LinearGradient(colors: [AppColors.blue, AppColors.lightBlue]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if(isSignUpMode){
                        // Sign up logic
                      } else {
                        // login logic
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
                              (Route<dynamic> route) => false, // This condition removes all previous routes.
                        );
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15,),

                SignInButton(text: 'Sign in With Google', image: Image.asset("assets/google1.png")),
                const SizedBox(height: 5,),
                SignInButton(text: 'Sign in With Facebook', image: SvgPicture.asset("assets/facebook 3.svg")),
                const SizedBox(height: 5,),
                SignInButton(text: 'Sign in With Apple', image: SvgPicture.asset("assets/apple-logo 1.svg")),
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
    );
  }
}