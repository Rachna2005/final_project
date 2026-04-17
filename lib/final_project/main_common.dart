import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/screens/map/map_screen.dart';
import 'ui/screens/pass/pass_screen.dart';
import 'ui/screens/profile/profile_screen.dart';
import 'ui/theme/theme.dart';

void mainCommon(List<InheritedProvider> providers) {
  runApp(
    MultiProvider(
      providers: providers,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
    ),
  );
}
// void mainCommon() {
//   runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [PassScreen(), MapScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    // 1- Get the globbal settings state
    // AppSettingsState settingsState = context.watch<AppSettingsState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        // backgroundColor: settingsState.theme.backgroundColor,
        body: _pages[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textDark,
          // selectedItemColor: settingsState.theme.color,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'Pass',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
