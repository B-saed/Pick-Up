import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pick_up/Screens/Signing/Screens/register_screen.dart';
import '../../../shared/components/components.dart';
import '../Cubit/signing_cubit.dart';
import '../Cubit/signing_states.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool comfortUI = true;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = SigningCubit.get(context);
    return BlocBuilder<SigningCubit,SigningStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      defaultTFF(
                        textEditingController: emailController,
                        kbType: TextInputType.emailAddress,
                        label: "Email",
                        prefixIcon: Icons.email,
                        onChange: (value) {
                          if (!comfortUI) {
                            formKey.currentState!.validate();
                          }
                        },
                        validator: (endValue) {
                          if (endValue!.isEmpty) {
                            comfortUI = false;
                            return "Email is empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      defaultTFF(
                        textEditingController: passwordController,
                        label: "Password",
                        isPass: c.obsecureText,
                        kbType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(c.suffixIcon),
                          onPressed: () {
                            c.changePasswordVisibility();
                            print(c.obsecureText);
                          },
                        ),
                        validator: (endValue) {
                          if (endValue!.isEmpty) {
                            comfortUI = false;
                            return "Pass is empty";
                          } else {
                            return null;
                          }
                        },
                        onChange: (value) {
                          if (!comfortUI) {
                            formKey.currentState!.validate();
                          }
                        },
                        onSubmit: (v) {
                          formKey.currentState!.validate();
                          print(v);
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        alignment: AlignmentDirectional.center,
                        child: MaterialButton(
                          minWidth: 150,
                          height: 50,
                          color: Colors.blue,
                          disabledColor: Colors.grey[300],
                          splashColor: Colors.tealAccent,
                          shape: const StadiumBorder(),
                          onPressed: c.isConnectedToInternet
                              ? () async {
                                  if (formKey.currentState!.validate()) {
                                    c.checkInternetConnection().then((value) {
                                      if (value) {
                                        c.userLogin(
                                          emailController.text,
                                          passwordController.text,
                                          context,
                                        );
                                      } else {
                                        toast(
                                            context: context,
                                            msg: "Check your internet connection",
                                            toastState: ToastState.warning);
                                      }
                                    });
                                  }
                                }
                              : null,
                          child: state is LoginLoadingState || state is LoginSuccessState || state is CheckingInternetConnectivityState
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account ?'),
                          TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: const Text('Register'))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
