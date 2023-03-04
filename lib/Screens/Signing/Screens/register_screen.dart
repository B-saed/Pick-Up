import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Shared/components/components.dart';
import '../Cubit/signing_cubit.dart';
import '../Cubit/signing_states.dart';
import 'email_verify_screen.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  String? passwordOne;
  bool comfortUI = true;

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var c = SigningCubit.get(context);
    return BlocConsumer<SigningCubit, SigningStates>(
      listener: (context, state) {
        if (state is UserCreateSuccessState) {
          navigateTo(context, const VerifyEmail());
        }
      },
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      defaultTFF(
                        textEditingController: c.registerNameController,
                        kbType: TextInputType.name,
                        label: "User Name",
                        prefixIcon: Icons.person,
                        onChange: (value) {
                          if (!comfortUI) {
                            formKey.currentState!.validate();
                          }
                        },
                        validator: (endValue) {
                          if (endValue!.isEmpty) {
                            comfortUI = false;
                            return "Name is empty";
                          } else {
                            return null;
                          }
                        },
                      ), // Name
                      const SizedBox(
                        height: 15,
                      ),
                      defaultTFF(
                        textEditingController: c.registerEmailController,
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
                            return "E-mail is empty";
                          } else if (!(endValue.contains("@") && endValue.contains("."))) {
                            comfortUI = false;
                            return "E-mail is not valid";
                          } else {
                            return null;
                          }
                        },
                      ), // Email
                      const SizedBox(height: 15),
                      defaultTFF(
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            comfortUI = false;
                            return "Pass is empty";
                          } else {
                            passwordOne = value;
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
                      ), // Password
                      const SizedBox(
                        height: 15,
                      ),
                      defaultTFF(
                        textEditingController: c.registerPasswordConfirmController,
                        label: "Confirm Password",
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
                            return "Confirm Password";
                          } else if (endValue != passwordOne) {
                            comfortUI = false;
                            return "Passwords Don't Match";
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
                      ), // Confirm Password
                      const SizedBox(
                        height: 40,
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
                                        c.userRegister(
                                          context,
                                          c.registerNameController.text,
                                          c.registerEmailController.text,
                                          c.registerPasswordConfirmController.text,
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
                          child: state is RegisterLoadingState ||
                                  state is RegisterSuccessState ||
                                  state is UserCreateSuccessState ||
                                  state is CheckingInternetConnectivityState
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Text('Already have an account ?'),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Login'))
                      ])
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
