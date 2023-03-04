import 'dart:async';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pick_up/Screens/Signing/Cubit/signing_states.dart';

import '../../../../Models/user_model.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/persistence/data_store.dart';
import '../../home_page.dart';
import '../Screens/login_screen.dart';
import '../Screens/register_screen.dart';

class SigningCubit extends Cubit<SigningStates> {
  SigningCubit() : super(SigningInitialState());

  static SigningCubit get(context) => BlocProvider.of<SigningCubit>(context)..monitorInternetConnection(context);

  bool isConnectedToInternet = false;

  Future<bool> checkInternetConnection() async {
    emit(CheckingInternetConnectivityState());
    isConnectedToInternet = await InternetConnectionChecker().hasConnection;
    return isConnectedToInternet;
  }

  void monitorInternetConnection(BuildContext context) {
    if (!InternetConnectionChecker().hasListeners) {
      InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            emit(InternetConnectedState());
            isConnectedToInternet = true;
            toast(context: context, msg: "Connected to Internet ", toastState: ToastState.success);
            break;
          case InternetConnectionStatus.disconnected:
            emit(InternetDisconnectedState());
            isConnectedToInternet = false;
            toast(context: context, msg: "Internet connection is lost", toastState: ToastState.warning);
            break;
        }
      });
    }
  }

  bool obsecureText = true;
  IconData suffixIcon = Icons.visibility_off;

  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordConfirmController = TextEditingController();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  void changePasswordVisibility() {
    if (obsecureText) {
      obsecureText = !obsecureText;
      suffixIcon = Icons.visibility;
      emit(ChangePasswordVisibilityState());
    } else {
      obsecureText = !obsecureText;
      suffixIcon = Icons.visibility_off;
      emit(ChangePasswordVisibilityState());
    }
  }

  late PickUpUser model;
  late UserCredential userCredential;

  void userRegister(BuildContext context, String userName, String userEmail, String password) {
    emit(RegisterLoadingState());
    //  User Create in FirebaseAuth
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: userEmail, password: password).then((value) {
      //  caching UserCredentials for late use
      userCredential = value;
      //local model initialization
      model = PickUpUser(
        uId: value.user?.uid as String,
        userName: userName,
        userEmail: value.user?.email as String,
        isEmailVerified: false,
        password: password,
        sha512: Crypt.sha512(password).toString(),
      );

      emit(RegisterSuccessState());

      //  User Create in Firestore
      // FirebaseFirestore.instance.collection("users").doc(model.uId).set(model.toMap()).then((value) {
      //   emit(UserCreateSuccessState(model.userEmail));
      //   //  Sending Verification Email
      //   userCredential.user!.sendEmailVerification().then((value) {
      //     emit(EmailVerificationSentSuccessState());
      //   }).catchError((error) {
      //     emit(EmailVerificationErrorState());
      //     userDeleteFromCollection();
      //     userDeleteFromAuth();
      //     print("Error while sendEmailVerification --> ${error.toString()}");
      //   });
      // }).catchError((error) {
      //   emit(UserCreateErrorState());
      //   print("Error while userCreate --> ${error.toString()}");
      // });

      ///  User Create in Realtime Datebase
      DatabaseReference userDbRef = FirebaseDatabase.instance.ref("users/${"${model.userName}--${model.uId}"}");
      userDbRef.set(model.toMap()).then((value) {
        emit(UserCreateSuccessState());
        userCredential.user!.sendEmailVerification().then((value) {
          emit(EmailVerificationSentSuccessState());
        }).catchError((error) {
          emit(EmailVerificationErrorState());
          userDeleteFromDatabase();
          userDeleteFromAuth();
          print("Error while sendEmailVerification --> ${error.toString()}");
        });
      }).catchError((error) {
        emit(UserCreateErrorState());
        print("Error while userCreate --> ${error.toString()}");
      });
    }).catchError((error) {
      if (error.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        toast(context: context, msg: "Email is in use - Login", toastState: ToastState.success);
        emit(SigningInitialState());
        navigateAndFinish(context, LoginScreen());
      } else {
        emit(RegisterErrorState());
        print("Error while userRegister --> ${error.toString()}");
      }
    });
  }

  bool done = false;

  void checkVerification(BuildContext context) async {
    emit(WaitingForVerificationState());
    Timer.periodic(const Duration(seconds: 2), (timer) {
      FirebaseAuth.instance.currentUser?.reload().then((value) {
        done = FirebaseAuth.instance.currentUser?.emailVerified as bool;
      });
      if (done) {
        emit(EmailVerificationCompleteState());
        // toast(context: context, msg: "Email Successfully Verified", toastState: ToastState.success);
        timer.cancel();
      }
    });
  }

  Future<void> goToBuzz(BuildContext context) async {
    DataStore.saveValue(key: 'uId', value: userCredential.user?.uid as String);
    await DataStore.getValue(key: 'uId').then((value) {
      uId = value;
      navigateAndFinish(context, const PickUpHomePage());
      //  Signing Cubit closes here.
    });
  }

  void userLogin(String userEmail, String password, BuildContext context) {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: password).then((value) async {
      userCredential = value;
      model = PickUpUser(
        uId: value.user?.uid as String,
        userName: "bb",
        userEmail: value.user?.email as String,
        isEmailVerified: value.user?.emailVerified as bool,
        password: password,
        sha512: Crypt.sha256(password).toString(),
      );
      emit(LoginSuccessState());

      /// supposing the user creating an account without verifying the email
      if (!model.isEmailVerified) {
        userDeleteFromAuth();
        userDeleteFromDatabase();
        toast(context: context, msg: "Email is not used - Sign up");
        navigateTo(context, RegisterScreen());
      } else {
        goToBuzz(context);
      }
    }).catchError((error) {
      if (error.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        toast(context: context, msg: "Email is not in use - Sign Up");
        navigateTo(context, RegisterScreen());
      }
      emit(LoginErrorState());
      print("Error while userLogin --> ${error.toString()}");
    });
  }

  void userDeleteFromAuth() {
    FirebaseAuth.instance.currentUser!.delete().then((nothing) {
      print("User -- ${model.userName} -- is deleted successfully from the FirebaseAuth");
      emit(UserDeleteFromAuthSuccessState());
    }).catchError((error) {
      print("Error while deleting User -- ${model.userName} -- from the FirebaseAuth --> ${error.toString()}");
      emit(UserDeleteFromAuthErrorState());
    });
  }

  void userDeleteFromDatabase() {
    FirebaseDatabase.instance.ref("users/${"${model.userName}--${model.uId}"}").remove().then((value) {
      print("User -- ${model.userName} -- is deleted successfully from the database");
      emit(UserDeleteFromDBSuccessState());
    }).catchError((error) {
      print("Error while deleting User -- ${model.userName} -- from the database --> ${error.toString()}");
      emit(UserDeleteFromDBErrorState());
    });
  }
}
