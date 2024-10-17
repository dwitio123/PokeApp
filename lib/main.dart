import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/compare_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'blocs/pokemon_bloc.dart';
import 'repositories/pokemon_repository.dart';
import 'screens/pokemon_list_dialog.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/detail': (context) =>
            DetailScreen(ModalRoute.of(context)!.settings.arguments as String),
        '/pokemon_list': (context) => BlocProvider(
            create: (context) =>
                PokemonBloc(PokemonRepository())..add(LoadPokemonList()),
            child: const PokemonListDialog()),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BlocProvider(
      create: (context) =>
          PokemonBloc(PokemonRepository())..add(LoadPokemonList()),
      child: const HomeScreen(),
    ),
    BlocProvider(
      create: (context) =>
          PokemonBloc(PokemonRepository())..add(LoadPokemonList()),
      child: const CompareScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: "Compare",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
