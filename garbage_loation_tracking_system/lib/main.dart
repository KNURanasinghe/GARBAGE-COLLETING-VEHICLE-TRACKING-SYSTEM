import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'Screens/homepage.dart';
import 'Screens/login.dart';
import 'Screens/signUp.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //user keep login for 1h
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp( MyApp(token: pref.getString('token'),));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({super.key,required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: token == null
          ? const SignUpPage()
          : (JwtDecoder.isExpired(token) == false)
              ? HomeScreen(token: token)
              : const LoginPage(),
    );
  }
}
