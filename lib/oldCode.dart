

import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const PizzaApp());
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bella Napoli',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PizzaSelectionScreen(),
    );
  }
}

class PizzaSelectionScreen extends StatefulWidget {
  const PizzaSelectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PizzaSelectionScreenState createState() => _PizzaSelectionScreenState();
}

class _PizzaSelectionScreenState extends State<PizzaSelectionScreen> {
  bool isVegetarian = false;
  String selectedIngredient = '';

  final List<String> vegetarianIngredients = ['Pimiento', 'Tofu'];
  final List<String> nonVegetarianIngredients = ['Peperoni', 'Jamón', 'Salmón'];

  void _showIngredientSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isVegetarian ? 'Ingredientes Vegetarianos' : 'Ingredientes No Vegetarianos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: (isVegetarian ? vegetarianIngredients : nonVegetarianIngredients)
                .map((ingredient) => RadioListTile(
                      title: Text(ingredient),
                      value: ingredient,
                      groupValue: selectedIngredient,
                      onChanged: (value) {
                        setState(() {
                          selectedIngredient = value as String;
                        });
                        Navigator.of(context).pop();
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  void _showOrderSummary() {
    String pizzaType = isVegetarian ? 'Vegetariana' : 'No Vegetariana';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resumen de tu Orden'),
          content: Text(
              'Pizza $pizzaType con mozzarella, tomate y $selectedIngredient.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bella Napoli'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Quieres una pizza vegetariana?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(isVegetarian ? 'Sí' : 'No'),
              value: isVegetarian,
              onChanged: (value) {
                setState(() {
                  isVegetarian = value;
                  selectedIngredient = ''; // Reset ingredient selection
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showIngredientSelection,
              child: const Text('Elige un ingrediente'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedIngredient.isNotEmpty ? _showOrderSummary : null,
              child: const Text('Ver resumen de la pizza'),
            ),
          ],
        ),
      ),
    );
  }
}
