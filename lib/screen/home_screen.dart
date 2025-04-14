import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_eat_project/provider/cart_provider.dart';
import 'package:wall_eat_project/provider/store_provider.dart';
import 'package:wall_eat_project/provider/user_provider.dart';
import 'package:wall_eat_project/screen/cart_screen.dart';
import 'package:wall_eat_project/screen/order_screen.dart';
import 'package:wall_eat_project/screen/profil_screen.dart';
import 'package:wall_eat_project/screen/store.screen.dart';
import 'package:wall_eat_project/service/auth_service.dart';
import 'package:wall_eat_project/service/store_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des écrans correspondant aux onglets
  final List<Widget> _screens = [
    const _HomeContent(), // Accueil (liste des magasins)
    const CartScreen(), // Panier actuel
    const OrdersScreen(), // Historique des commandes
    const ProfileScreen(), // Profil utilisateur
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.initializeUser();

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    await storeProvider.fetchStores();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return const Text("Magasins");
      case 1:
        return const Text("Mon Panier");
      case 2:
        return const Text("Mes Commandes");
      case 3:
        return const Text("Mon Profil");
      default:
        return const Text("Accueil");
    }
  }

  List<Widget> _buildAppBarActions() {
    return [
      if (_selectedIndex !=
          1) // Affiche le badge panier sauf sur l'écran panier
        Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => _onItemTapped(1),
                ),
                if (cart.items.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.items.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      IconButton(
        icon: const Icon(Icons.exit_to_app),
        onPressed: () async {
          await AuthService().signOut();
        },
      ),
    ];
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Magasins',
        ),
        BottomNavigationBarItem(
          icon: Consumer<CartProvider>(
            builder: (context, cart, _) {
              return Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cart.items.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cart.items.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          label: 'Panier',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Commandes',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return ListView(
      children: [
        const SizedBox(height: 20),
        _buildStoreList(storeProvider),
      ],
    );
  }

  Widget _buildStoreList(StoreProvider storeProvider) {
    return Column(
      children: [
        const Text(
          "Magasins disponibles",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: storeProvider.stores.length,
          itemBuilder: (context, index) {
            final store = storeProvider.stores[index];
            return ListTile(
              title: Text(store.name),
              subtitle: Text(store.address),
              trailing: IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoreMapScreen(
                        storeName: store.name,
                        storeAddress: store.address,
                      ),
                    ),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoreScreen(
                      storeId: store.id,
                      storeName: store.name,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
