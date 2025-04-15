import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_eat_project/provider/cart_provider.dart';
import 'package:wall_eat_project/provider/store_provider.dart';
import 'package:wall_eat_project/provider/user_provider.dart';
import 'package:wall_eat_project/screen/cart_screen.dart';
import 'package:wall_eat_project/screen/order_screen.dart';
import 'package:wall_eat_project/screen/profil_screen.dart';
import 'package:wall_eat_project/screen/store_screen.dart';
import 'package:wall_eat_project/service/auth_service.dart';
import 'package:wall_eat_project/screen/store_map_screen.dart';

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
        _buildStoreList(context, storeProvider),
      ],
    );
  }

// Dans la classe _HomeContent (remplacer _buildStoreList)
  Widget _buildStoreList(BuildContext context, StoreProvider storeProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Magasins disponibles",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: storeProvider.stores.length,
          itemBuilder: (context, index) {
            final store = storeProvider.stores[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
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
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.store, size: 40),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              store.address,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.map),
                            tooltip: "Voir sur la carte",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StoreMapScreen(
                                    storeAddress: store.address,
                                    storeName: store.name,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
