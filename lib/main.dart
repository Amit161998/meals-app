import 'package:flutter/material.dart';
import 'package:mealsaapln/data_dummy/dummy_data.dart';
import 'package:mealsaapln/screens/filters_screen.dart';
import 'package:mealsaapln/screens/meal_detail_screen.dart';
import 'package:mealsaapln/screens/tabs_screen.dart';
// import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import 'models/meal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegeterian': false
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> favouritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        if (_filters['vegeterian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final extdIndex = favouritedMeals.indexWhere((meal) => meal.id == mealId);

    if (extdIndex >= 0) {
      setState(() {
        favouritedMeals.removeAt(extdIndex);
      });
    } else {
      setState(() {
        favouritedMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isMealFavourite(String id) {
    return favouritedMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 223, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 24,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      // home: , //applying the category screen widget to material app home
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabScreen(favouritedMeals),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(_availableMeals),
        MealDeatilsScreen.routeName: (ctx) => MealDeatilsScreen(_toggleFavourite, _isMealFavourite),
        FilterScreen.routeName: (ctx) => FilterScreen(_filters, _setFilters),
      },

      // onGenerateRoute: (settings) {
      //   print(settings.arguments);
      //   // return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
      // },

      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (ctx) => CategoriesScreen(),
      //   );
      // },
    );
  }
}
