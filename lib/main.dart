import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:letter_generator/Connectivity/DevHelp.dart';
import 'package:letter_generator/Screens/FirstInputScreen.dart';
import 'package:provider/provider.dart';
import 'Providers/ProviderClass.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderClassChange()),
      ],
      child: const MyApp(),
    ),
  );
}


ThemeData lightTheme1 = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3A3D85),
    primary: const Color(0xFF3A3D85),
    secondary: const Color(0xFF00D9F6),
    surface: const Color(0xFFF5F5F5),
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3A3D85),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3A3D85),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letter Generator',
      theme: lightTheme1,
      home: const LetterGenerator(),
    );
  }
}

class LetterGenerator extends StatefulWidget {
  const LetterGenerator({super.key});

  @override
  State<LetterGenerator> createState() => LetterGeneratorState();
}

class LetterGeneratorState extends State<LetterGenerator> {
  DevHelp help = DevHelp();

  late Stream<InternetConnectionStatus> connectionStream;
  bool isConnected = false;

  @override
  void initState() {

    super.initState();

    connectionStream = InternetConnectionChecker.instance.onStatusChange;

    connectionStream.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (mounted) {
        setState(() {
          isConnected = connected;
          // help.sendMessageToTelegram('app opened');
        });
      }
    });
  }

  // Future<bool> checkInternetConnection() async {
  //   // return await InternetConnectionChecker().hasConnection;
  //   final bool t = await InternetConnectionChecker.instance
  //       .hasConnection;
  //   return t;
  // }

  @override
  Widget build(BuildContext context) {

    if (isConnected) {
      return FirstInputScreen();
    }
    else {
      return Scaffold(
        appBar: AppBar(title: Text('Letter Generator',
        style: TextStyle(fontWeight: FontWeight.bold),),),
        body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 5,
              ),
            ),
              SizedBox(height: 30,),
              Text('Connect to Internet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
        ),
      );
    }
  }
}
