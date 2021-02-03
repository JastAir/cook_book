import 'package:cook_book/common/app_style.dart';
import 'package:cook_book/common/widgets/loading_container_view.dart';
import 'package:cook_book/screens/dashboard/dashboard_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'common/simple_bloc_observer.dart';

// final FirebaseOptions firebaseOptions = const FirebaseOptions(
//   appId: '1:448618578101:ios:0b650370bb29e29cac3efc',
//   apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
//   projectId: 'react-native-firebase-testing',
//   messagingSenderId: '448618578101',
// );

Future<void> main() async {
  EquatableConfig.stringify = true;
  Bloc.observer = SimpleBlocObserver();

  // firebase
  WidgetsFlutterBinding.ensureInitialized();

  // db
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cook Book',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: createMaterialColor(Colors.red[400]),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Для работы приложения необходим интернет!"),
              ),
            );
          }
          return DashboardScreen();
        },
      ),
    );
  }
}
