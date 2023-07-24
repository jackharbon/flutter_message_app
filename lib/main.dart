import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:message_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('====> main | Firebase initialized');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  MyApp({super.key});

  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Message App',
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('pl', 'PL'), Locale('en', 'GB')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          primarySwatch: Colors.orange,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: _firebaseApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('====> main | error: ${snapshot.error.toString()}');
              return Text('====> main | ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              // print('====> main | login: ${snapshot.toString()}');
              return const LoginPage();
            } else {
              const Center(
                child: SpinKitFadingCircle(
                  color: Colors.amber,
                  size: 100.0,
                ),
              );
            }
            return const SpinKitFadingCircle(
              color: Colors.amber,
              size: 100.0,
            );
          },
        ));
  }
}
