import 'package:flutter/foundation.dart';
import '../../routes/route_generator.dart';
import '../google/google_signin.dart';
import 'cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("AssignMate Login"),
          automaticallyImplyLeading: false,
        ),
      body: Center(
        child: SingleChildScrollView(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),

                const Text("Please login to continue",textScaleFactor: 1.5,),

                const SizedBox(height: 30,),

                //Email Field
                myTextField(
                    controller: emailController,
                    hint: "Email",
                    obscured: false
                ),

                const SizedBox(height: 15,),

                //password field
                myTextField(
                    controller: passwordController,
                    hint: 'Password',
                    obscured: true
                ),

                const SizedBox(height: 10,),

                //forgot Password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => { Navigator.pushNamed(context, RouteGenerator.passwordPage)},
                        child: const Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                //log in button
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: state is LoggingIn ? null : () async {
                        BlocProvider.of<LoginCubit>(context).tryLoggingIn();
                        FocusScope.of(context).unfocus();
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          );
                          BlocProvider.of<LoginCubit>(context).successful(true);
                        } on FirebaseAuthException catch(e) {
                          if(kDebugMode){
                            print(e);
                          }
                          BlocProvider.of<LoginCubit>(context).successful(false);
                          showDialog(context: context, builder: (context){
                            return const AlertDialog(
                              title: Text('Incorrect Email Or Password'),
                            );
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: state is! LoggingIn ? const Center(
                          child: Text("Sign in",
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ): const Center(
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 12,),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 50,),

                //google login
                GoogleSignInButton().buildGoogleSignInButton(context),

                const SizedBox(height: 50,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, RouteGenerator.signUpPage),
                      child: const Text('Register now',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
        ),
      ),
    );
  }

  Widget myTextField({required controller, required String hint, required bool obscured}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscured,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade900),
              borderRadius: BorderRadius.circular(10)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hint,
        ),
      ),
    );
  }
}
