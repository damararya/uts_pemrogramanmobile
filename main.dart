import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(RestaurantMenuApp());
}

class RestaurantMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
      theme: ThemeData(
        primaryColor: Color(0xFFDB0909), // Warna utama aplikasi
        backgroundColor: Colors.grey[200], // Warna latar belakang
        // Menambahkan gaya teks aplikasi
        textTheme: TextTheme(
          headline6: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          subtitle1: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}

class CartTotal extends StatelessWidget {
  final List<MenuItem> cart;

  CartTotal({required this.cart});

  @override
  Widget build(BuildContext context) {
    // Hitung total harga
    int totalCents =
        cart.fold(0, (total, menuItem) => total + menuItem.priceInCents);

    // Format total harga dalam mata uang yang sesuai
    final totalFormatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
        .format(totalCents / 100.0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total Harga: $totalFormatted',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang di Aplikasi Restoran'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Tambahkan gambar atau elemen dekoratif di sini
            Image.network('URL_GAMBAR_LOGO_GOOGLE', width: 150, height: 150),
            SizedBox(height: 20), // Spasi antara gambar dan tombol

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RestaurantMenuScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFE60510),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
              child: Text(
                'LOGIN',
              ),
            ),
          ],
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
      priceInCents: 10000,
      description: 'Nasi goreng dengan ayam dan sayuran',
      category: 'Makanan',
    ),
    MenuItem(
      name: 'Mie Goreng',
      priceInCents: 9000,
      description: 'Mie goreng dengan telur dan bumbu spesial',
      category: 'Makanan',
    ),
    MenuItem(
      name: 'Nasi Uduk',
      priceInCents: 11000,
      description: 'Nasi dengan ikan, telur, dan semur jengkol',
      category: 'Makanan',
    ),
    MenuItem(
      name: 'Mie Ayam',
      priceInCents: 8500,
      description: 'Mie dengan potongan ayam dan pangsit',
      category: 'Makanan',
    ),
    MenuItem(
      name: 'Es Teh Manis',
      priceInCents: 3000,
      description: 'Minuman teh manis dingin',
      category: 'Minuman',
    ),
    MenuItem(
      name: 'Sate Ayam',
      priceInCents: 15000,
      description: 'Sate ayam dengan bumbu kacang',
      category: 'Makanan',
    ),
    // Tambahkan menu lain di sini
  ];

  List<MenuItem> cart = [];
  String query = ""; // Menyimpan kata kunci pencarian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Restoran'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _navigateToShoppingCart,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _navigateToLogin,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            onQueryChanged: _filterMenu,
          ),
          Expanded(
            child: MenuList(menu: _filteredMenu, onAddToCart: _addToCart),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mengatur kata kunci pencarian
  void _filterMenu(String query) {
    setState(() {
      this.query = query;
    });
  }

  // Fungsi untuk mengambil daftar menu yang sesuai dengan kata kunci pencarian
  List<MenuItem> get _filteredMenu {
    if (query.isEmpty) {
      return menu; // Jika tidak ada kata kunci, tampilkan semua menu
    } else {
      return menu.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void _addToCart(MenuItem menuItem) {
    setState(() {
      cart.add(menuItem);
    });
  }

  void _navigateToShoppingCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShoppingCartScreen(cart: cart),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthScreen(),
      ),
    );
  }
}

class MenuItem {
  final String name;
  final int priceInCents;
  final String description;
  final String category;

  MenuItem({
    required this.name,
    required this.priceInCents,
    required this.description,
    required this.category,
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
    final priceFormatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
        .format(menuItem.priceInCents / 100.0);

    return ListTile(
      title: Text(
        menuItem.name,
        style: Theme.of(context)
            .textTheme
            .headline6, // Menggunakan gaya teks yang telah ditentukan di tema
      ),
      subtitle: Text(
        menuItem.description,
        style: Theme.of(context)
            .textTheme
            .subtitle1, // Menggunakan gaya teks yang telah ditentukan di tema
      ),
      trailing: Text(
        priceFormatted,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
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

  void _navigateToPayment(BuildContext context) {
    int totalCents =
        cart.fold(0, (total, menuItem) => total + menuItem.priceInCents);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PaymentScreen(totalAmount: totalCents, cartItems: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return CartItemTile(menuItem: cart[index]);
              },
            ),
          ),
          CartTotal(cart: cart),
          ElevatedButton(
            onPressed: () {
              _navigateToPayment(
                  context); // Panggil fungsi _navigateToPayment()
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFE60510),
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              textStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            child: Text(
              'Bayar',
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final int totalAmount;
  final List<MenuItem> cartItems;

  PaymentScreen({required this.totalAmount, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Di sini Anda dapat mengimplementasikan logika pembayaran sesuai kebutuhan Anda.
    // Anda dapat menggunakan metode pembayaran pihak ketiga atau metode lainnya.

    // Contoh sederhana untuk menampilkan total harga dan item-item yang dibeli:
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Total Harga: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(totalAmount / 100.0)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Item yang dibeli:',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartItems[index].name),
                  subtitle: Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                        .format(cartItems[index].priceInCents / 100.0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final MenuItem menuItem;

  CartItemTile({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final priceFormatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
        .format(menuItem.priceInCents / 100.0);

    return ListTile(
      title: Text(
        menuItem.name,
        style: Theme.of(context)
            .textTheme
            .headline6, // Menggunakan gaya teks yang telah ditentukan di tema
      ),
      subtitle: Text(
        priceFormatted,
        style: Theme.of(context)
            .textTheme
            .subtitle1, // Menggunakan gaya teks yang telah ditentukan di tema
      ),
    );
  }
}
