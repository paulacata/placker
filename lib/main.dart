import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:placker/providers/providers.dart';
import 'package:placker/screens/screens.dart'; 
import 'package:placker/services/services.dart';


void main() => runApp(AppState());


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //definició de proveidors
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => UiProvider()),
        ChangeNotifierProvider(create: ( _ ) => TasksService()),
        ChangeNotifierProvider(create: (context) => EtiquetaService(Provider.of<TasksService>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => PrioritatService(Provider.of<TasksService>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => SubjectsService(Provider.of<TasksService>(context, listen: false))),
        ChangeNotifierProvider(create: ( _ ) => FiltersService()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Placker',
      
      //definició de rutes
      initialRoute: 'Initial',
      routes: {
        'Initial': (_) => InitialScreen(),
        'Login': (_) => LoginScreen(),
        'Signup': (_) => SignupScreen(),
        'Home': (_) => HomeScreen(),
        'Empty': (_) => EmptyScreen(),
        'Calendar': (_) => CalendarScreen(dropdownValue: 'Mensual'),
        'List': (_) => ListScreen(),
        'Register': (_) => RegisterScreen(),
        'Profile': (_) => ProfileScreen(),               
        'AddTask': (_) => AddTaskScreen(),
        'AddSubject': (_) => AddSubjectScreen(),
        'AddEtiqueta': (_) => AddEtiquetaScreen(),
        'AddPrioritat': (_) => AddPrioritatScreen(),
        'ViewObjectives': (_) => ViewObjectivesScreen(),
        'TotsInformes': (_) => TotsInformesScreen(dropdownValue: 'Diari'),
      },

      scaffoldMessengerKey: NotificationService.messengerKey,

      //definició del tema
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),

      //per gestionar el tema de dates del calendari
      supportedLocales: const [Locale('es', 'ES')],
      locale: const Locale('es', 'ES'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],

    );
  }
}