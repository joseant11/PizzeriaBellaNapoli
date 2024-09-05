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
        fontFamily: 'Raleway', // Puedes agregar una fuente más estilizada
      ),
      home: const PizzaSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PizzaSelectionScreen extends StatefulWidget {
  const PizzaSelectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PizzaSelectionScreenState createState() => _PizzaSelectionScreenState();
}

class _PizzaSelectionScreenState extends State<PizzaSelectionScreen> with SingleTickerProviderStateMixin {
  bool isVegetarian = false;
  String selectedIngredient = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Map<String, String>> vegetarianIngredients = [
    {'name': 'Pimiento', 'icon': '🌶️'},
    {'name': 'Tofu', 'icon': '🥗'},
  ];
  final List<Map<String, String>> nonVegetarianIngredients = [
    {'name': 'Peperoni', 'icon': '🍕'},
    {'name': 'Jamón', 'icon': '🥓'},
    {'name': 'Salmón', 'icon': '🐟'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showIngredientSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isVegetarian ? 'Ingredientes Vegetarianos' : 'Ingredientes No Vegetarianos',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: (isVegetarian ? vegetarianIngredients : nonVegetarianIngredients)
                .map((ingredient) => ListTile(
                      leading: Text(ingredient['icon']!, style: const TextStyle(fontSize: 24)),
                      title: Text(ingredient['name']!),
                      selected: selectedIngredient == ingredient['name'],
                      onTap: () {
                        setState(() {
                          selectedIngredient = ingredient['name']!;
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
        return ScaleTransition(
          scale: _animation,
          child: AlertDialog(
            title: const Text(
              '¡Tu Pizza está Lista!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Pizza $pizzaType con mozzarella, tomate y $selectedIngredient.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('¡Delicioso!', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        );
      },
    );
    _controller.forward(from: 0.0); // Dispara la animación cuando se muestra el resumen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bella Napoli'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '¿Quieres una pizza vegetariana?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text(isVegetarian ? 'Sí' : 'No', style: const TextStyle(color: Colors.black)),
                  value: isVegetarian,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isVegetarian = value;
                      selectedIngredient = ''; // Reinicia la selección de ingredientes
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showIngredientSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Elige un ingrediente', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: selectedIngredient.isNotEmpty ? _showOrderSummary : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIngredient.isNotEmpty ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Ver resumen de la pizza', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}