import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        accentColor: Colors.tealAccent,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: const TextStyle(color: Colors.tealAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final List<IconData> _icons = [
    Icons.local_cafe,
    Icons.local_grocery_store,
    Icons.cleaning_services,
    Icons.fastfood,
    Icons.local_drink,
    Icons.local_dining,
    Icons.local_florist,
    Icons.local_pharmacy,
    Icons.local_library,
    Icons.local_hotel,
    Icons.local_laundry_service,
    Icons.local_printshop,
  ];
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  void _addItem() {
    if (_itemController.text.isNotEmpty) {
      setState(() {
        final random = Random();
        final randomIcon = _icons[random.nextInt(_icons.length)];
        _items.add({
          'text': _itemController.text,
          'icon': randomIcon,
          'quantity': 1 // Default quantity
        });
        _itemController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _updateIcon(int index, IconData icon) {
    setState(() {
      _items[index]['icon'] = icon;
    });
  }

  void _updateQuantity(int index, String quantity) {
    setState(() {
      _items[index]['quantity'] = int.tryParse(quantity) ?? 1;
    });
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _items.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = (_currentPage + 1) * _itemsPerPage;
    final List<Map<String, dynamic>> _currentItems = _items.sublist(
      startIndex,
      endIndex > _items.length ? _items.length : endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shopping_cart),
            Spacer(),
            Text(
              'Lista de Compras',
              style: TextStyle(
                fontFamily: 'Roboto', // Substitua por uma fonte de sua escolha
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar Item',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 60, // Defina a altura desejada aqui
                  child: ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Adicionar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _currentItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${startIndex + index + 1}. '),
                          DropdownButton<IconData>(
                            value: _currentItems[index]['icon'],
                            items: _icons.map((IconData icon) {
                              return DropdownMenuItem<IconData>(
                                value: icon,
                                child: Icon(icon),
                              );
                            }).toList(),
                            onChanged: (IconData? newIcon) {
                              if (newIcon != null) {
                                _updateIcon(startIndex + index, newIcon);
                              }
                            },
                          ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(_currentItems[index]['text']),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 50, // Defina a largura desejada aqui
                            child: TextField(
                              controller: TextEditingController(
                                text:
                                    _currentItems[index]['quantity'].toString(),
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Qtd',
                              ),
                              onChanged: (value) {
                                _updateQuantity(startIndex + index, value);
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(startIndex + index),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 0 ? _previousPage : null,
                  child: const Text('Anterior'),
                ),
                Text(
                  'Itens ${startIndex + 1} - ${endIndex > _items.length ? _items.length : endIndex} de ${_items.length}',
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: (_currentPage + 1) * _itemsPerPage < _items.length
                      ? _nextPage
                      : null,
                  child: const Text('Próximo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
