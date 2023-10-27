import 'package:flutter/material.dart';

void main() {
  runApp(RestaurantMenuApp());
}

class RestaurantMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 219, 9, 9), // Warna utama aplikasi
        backgroundColor: Colors.grey[200], // Warna latar belakang
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RestaurantMenuScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 230, 5, 16), // Warna latar belakang
            onPrimary: Colors.white, // Warna teks
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.white, // Warna teks tombol
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantMenuScreen extends StatefulWidget {
  @override
  _RestaurantMenuScreenState createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  List<MenuItem> menu = [
    MenuItem(
      name: 'Nasi Goreng',
      price: 10000,
      description: 'Nasi goreng dengan ayam dan sayuran',
      category: 'Makanan', // Tentukan kategori makanan
    ),
    MenuItem(
      name: 'Mie Goreng',
      price: 9000,
      description: 'Mie goreng dengan telur dan bumbu spesial',
      category: 'Makanan', // Tentukan kategori makanan
    ),
    MenuItem(
      name: 'Sate Ayam',
      price: 8000,
      description: 'Sate ayam dengan saus kacang',
      category: 'Makanan', // Tentukan kategori makanan
    ),
    MenuItem(
      name: 'Air Mineral',
      price: 3000,
      description: 'Air mineral botol',
      category: 'Minuman', // Tentukan kategori minuman
    ),
    MenuItem(
      name: 'Es Teh Manis',
      price: 4000,
      description: 'Es teh manis dalam gelas',
      category: 'Minuman', // Tentukan kategori minuman
    ),
    // Tambahkan item menu lainnya dengan kategori yang sesuai
  ];

  List<MenuItem> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Restoran'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShoppingCartScreen(cart: cart),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AuthScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            onQueryChanged: (query) {
              _filterMenu(query);
            },
          ),
          Expanded(
            child: MenuList(menu: menu, onAddToCart: _addToCart),
          ),
        ],
      ),
    );
  }

  void _addToCart(MenuItem menuItem) {
    setState(() {
      cart.add(menuItem);
    });
  }

  void _filterMenu(String query) {
    final filteredMenu = menu.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      menu = filteredMenu;
    });
  }
}

class MenuItem {
  final String name;
  final int price;
  final String description;
  final String category; // Tambahkan atribut kategori

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.category, // Inisialisasi atribut kategori
  });
}

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onQueryChanged;

  SearchBar({required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Cari Menu...',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: onQueryChanged,
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  final List<MenuItem> menu;
  final ValueChanged<MenuItem> onAddToCart;

  MenuList({required this.menu, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menu.length,
      itemBuilder: (context, index) {
        return MenuItemTile(menuItem: menu[index], onAddToCart: onAddToCart);
      },
    );
  }
}

class MenuItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final ValueChanged<MenuItem> onAddToCart;

  MenuItemTile({required this.menuItem, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        menuItem.name,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(
        menuItem.description,
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: Text(
        '\$${menuItem.price.toStringAsFixed(2)}',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      onTap: () {
        onAddToCart(menuItem);
      },
    );
  }
}

class ShoppingCartScreen extends StatelessWidget {
  final List<MenuItem> cart;

  ShoppingCartScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return CartItemTile(menuItem: cart[index]);
        },
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final MenuItem menuItem;

  CartItemTile({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(menuItem.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text('\$${menuItem.price.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 14)),
    );
  }
}
