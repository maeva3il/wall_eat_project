class Store {
  final String id;
  final String name;
  final String address;
  final List<String> productIds;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.productIds,
  });

  factory Store.fromFirestore(Map<String, dynamic> data, String id) {
    // On récupère les valeurs du map (productId uniquement)
    final productMap = data['products'] as Map<String, dynamic>? ?? {};
    final productIds = productMap.values.map((e) => e.toString()).toList();

    return Store(
      id: id,
      name: data['name'],
      address: data['address'],
      productIds: productIds,
    );
  }
}
