import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_clone/router.dart';
import '../colors.dart';
import '../screens/mobile_layout_screen.dart';
import '../screens/web_layout_screen.dart';
import '../utils/responsive_layout.dart';
import 'common/global_keys.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          elevation: 0.0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onGenerateRoute: (settings)=>generateRoute(settings),
      home:ref.watch(userDataAuthProvider).when(
          data: (user){

            if(user ==null){
              return const LandingScreen();
            }else{
              userData= user;
              return const MobileLayoutScreen();
            }
          },



       error: (err,rec){
            return ErrorWidget(err);
       }, loading: (){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
      }),
    );
  }
}