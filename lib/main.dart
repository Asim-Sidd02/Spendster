import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spendster/Screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:spendster/services/firestore_service.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'package:spendster/Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform, );
  await FirebaseAppCheck.instance.activate(
  // if targeting web
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(const MyApp());
}

class MyApp extends  StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();


}



  class _MyAppState extends State<MyApp>{

  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user)
    {
      if(user!=null && mounted){
        setState(() {
          isLogin = true;
        });
      }
    });

  }
  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLogin? const HomeScreen(): const WelcomeScreen(),
      ),
    );
  }


}
