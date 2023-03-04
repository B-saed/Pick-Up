import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pick_up/Screens/home_page.dart';

import 'Screens/Signing/Cubit/signing_cubit.dart';
import 'Screens/Signing/Cubit/signing_states.dart';
import 'Screens/Signing/Screens/login_screen.dart';
import 'Shared/bloc_observer.dart';
import 'firebase_options.dart';
import 'shared/components/constants.dart';
import 'shared/persistence/data_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BuzzBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Widget widget;
  uId = await DataStore.getValue(key: 'uId');

  if (uId != null) {
    widget = const PickUpHomePage();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startScreen: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({
    super.key,
    required this.startScreen,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color screenColor = Colors.white;
    var lightTheme = ThemeData(
      fontFamily: "Ubuntu",
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: screenColor,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: screenColor,
            statusBarIconBrightness: Brightness.dark
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: "Cairo",
          letterSpacing: 1.5,
        ),
      ),
      scaffoldBackgroundColor: screenColor,
    );
    // var darkTheme = ThemeData(
    //   fontFamily: "Geoma",
    //   appBarTheme: AppBarTheme(
    //     elevation: 0,
    //     color: screenColor,
    //     systemOverlayStyle: SystemUiOverlayStyle(
    //       statusBarColor: screenColor,
    //     ),
    //     titleTextStyle: const TextStyle(
    //       color: Colors.black,
    //       fontSize: 30,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: "Cronus",
    //       letterSpacing: 1.5,
    //     ),
    //   ),
    //   scaffoldBackgroundColor: screenColor,
    // );
    var currentTheme = lightTheme;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => SigningCubit()),
        ],
        child: BlocBuilder<SigningCubit,SigningStates>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Buzz',
              theme: currentTheme,
              debugShowCheckedModeBanner: false,
              home: startScreen,
            );
          },
        ));
  }
}
