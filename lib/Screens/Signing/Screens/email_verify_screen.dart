import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Shared/components/components.dart';
import '../Cubit/signing_states.dart';
import 'login_screen.dart';
import '../Cubit/signing_cubit.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    SigningCubit c = SigningCubit.get(context);
    return BlocConsumer<SigningCubit, SigningStates>(
      listener: (context, state) {
        if (state is EmailVerificationSentSuccessState) {
          c.checkVerification(context);
        }
        if (state is EmailVerificationCompleteState) {
          Future.delayed(const Duration(seconds: 2)).then((value) {
            c.goToBuzz(context);
          });
        }
        if (state is EmailVerificationErrorState) {
          c.userDeleteFromAuth();
          c.userDeleteFromDatabase();
          toast(context: context, msg: "Registration Cancelled");
          navigateAndFinish(context, LoginScreen());
        }
      },
      builder: (context, state) {

        var userRef = FirebaseDatabase.instance.ref("users/${"${c.model.userName}--${c.model.uId}"}");

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                c.userDeleteFromDatabase();
                c.userDeleteFromAuth();
                c.done = false;
                toast(context: context, msg: "Registration Cancelled", toastDuration: const Duration(seconds: 3));
                navigateAndFinish(context, LoginScreen());
              },
            ),
          ),
          body: StreamBuilder(
              stream: userRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError && snapshot.data?.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  if (data["isEmailVerified"]) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Email is Successfully Verified",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 30,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (c.done) {
                      snapshot.data?.snapshot.ref.update({'isEmailVerified': true});
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(c.model.userEmail, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Check your inbox to verify your E-mail"),
                        const SizedBox(
                          height: 50,
                        ),
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        );
      },
    );
  }
}
