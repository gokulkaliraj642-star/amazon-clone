import 'package:flutter/material.dart';

void main() {
  runApp(const AmazonMiniApp());
}

class AmazonMiniApp extends StatelessWidget {
  const AmazonMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Mini',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF131921),
          brightness: Brightness.light,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

//this is the auth gate developed by gokul
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loggedIn = false;
  String _userEmail = '';

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      return AmazonHomePage(
        userEmail: _userEmail,
        onLogout: () => setState(() => _loggedIn = false),
      );
    }

    return LoginPage(
      onLogin: (email) => setState(() {
        _userEmail = email;
        _loggedIn = true;
      }),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final ValueChanged<String> onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _brand = Color(0xFF131921);
  static const _accent = Color(0xFFFF9900);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    setState(() => _isLoading = false);

    widget.onLogin(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _brand,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: _accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final value = (v ?? '').trim();
                          if (value.isEmpty) return 'Enter email';
                          if (!value.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            tooltip: _obscure ? 'Show' : 'Hide',
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (v) {
                          final value = (v ?? '');
                          if (value.isEmpty) return 'Enter password';
                          if (value.length < 4) return 'Too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: _isLoading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Demo login: any email + any password (min 4 chars).',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.prime,
    required this.imageUrls,
    required this.photoIcon,
    required this.photoColor,
  });

  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final bool prime;
  final List<String> imageUrls;
  final IconData photoIcon;
  final Color photoColor;
}

class AmazonHomePage extends StatefulWidget {
  const AmazonHomePage({
    super.key,
    required this.userEmail,
    required this.onLogout,
  });

  final String userEmail;
  final VoidCallback onLogout;

  @override
  State<AmazonHomePage> createState() => _AmazonHomePageState();
}

class _AmazonHomePageState extends State<AmazonHomePage> {
  static const _brand = Color(0xFF131921);
  static const _accent = Color(0xFFFF9900);

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final Map<String, int> _cart = <String, int>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _products => const [
    Product(
      id: 'p1',
      title: 'Echo Dot (5th Gen) Smart Speaker',
      category: 'Electronics',
      price: 44.99,
      rating: 4.6,
      prime: true,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Alexa%20Amazon%20Echo%20Dot%203rd%20Gen%20Smart%20Speaker%20with%20Wall%20Mount%20%28Creative%20Commons%29%20%2851270472329%29.jpg?width=1200',
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            '%E3%82%B9%E3%83%9E%E3%83%BC%E3%83%88%E3%82%B9%E3%83%94%E3%83%BC%E3%82%AB%E3%83%BC.jpg?width=1200',
      ],
      photoIcon: Icons.speaker_rounded,
      photoColor: Color(0xFF3B82F6),
    ),
    Product(
      id: 'p2',
      title: 'Wireless Headphones with Noise Canceling',
      category: 'Electronics',
      price: 79.99,
      rating: 4.3,
      prime: true,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Headphones%201.jpg?width=1200',
      ],
      photoIcon: Icons.headphones_rounded,
      photoColor: Color(0xFF8B5CF6),
    ),
    Product(
      id: 'p3',
      title: 'Cotton Crewneck T‑Shirt (Pack of 2)',
      category: 'Fashion',
      price: 19.49,
      rating: 4.2,
      prime: false,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Wikipedia-T-shirt.jpg?width=1200',
      ],
      photoIcon: Icons.checkroom_rounded,
      photoColor: Color(0xFFEC4899),
    ),
    Product(
      id: 'p4',
      title: 'Stainless Steel Water Bottle, 1L',
      category: 'Home',
      price: 15.99,
      rating: 4.7,
      prime: true,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Stainless%20Steel%20Water%20Bottle.jpg?width=1200',
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Stainless%20steel%20water%20bottle.jpg?width=1200',
      ],
      photoIcon: Icons.water_drop_rounded,
      photoColor: Color(0xFF06B6D4),
    ),
    Product(
      id: 'p5',
      title: 'Beginner Yoga Mat (Non‑Slip)',
      category: 'Sports',
      price: 24.0,
      rating: 4.4,
      prime: true,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Yoga%20mat.jpg?width=1200',
      ],
      photoIcon: Icons.self_improvement_rounded,
      photoColor: Color(0xFF10B981),
    ),
    Product(
      id: 'p6',
      title: 'Fiction Bestseller Paperback',
      category: 'Books',
      price: 9.99,
      rating: 4.1,
      prime: false,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Paperback%20book%20with%20green%20cover.jpg?width=1200',
      ],
      photoIcon: Icons.menu_book_rounded,
      photoColor: Color(0xFFF97316),
    ),
    Product(
      id: 'p7',
      title: 'Smart LED Bulb (Color, 2 Pack)',
      category: 'Home',
      price: 18.5,
      rating: 4.5,
      prime: true,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Light%20Bulb.jpg?width=1200',
      ],
      photoIcon: Icons.lightbulb_rounded,
      photoColor: Color(0xFFF59E0B),
    ),
    Product(
      id: 'p8',
      title: 'Running Shoes (Breathable)',
      category: 'Sports',
      price: 52.99,
      rating: 4.0,
      prime: false,
      imageUrls: [
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Running%20shoes.jpg?width=1200',
        'https://commons.wikimedia.org/wiki/Special:FilePath/'
            'Marathon%20shoes.jpg?width=1200',
      ],
      photoIcon: Icons.directions_run_rounded,
      photoColor: Color(0xFFEF4444),
    ),
  ];

  Iterable<String> get _categories => const [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Books',
    'Sports',
  ];

  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((p) {
      final inCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQuery =
          query.isEmpty || p.title.toLowerCase().contains(query);
      return inCategory && matchesQuery;
    }).toList();
  }

  int _columnsForWidth(double width) {
    if (width >= 1200) return 5;
    if (width >= 960) return 4;
    if (width >= 700) return 3;
    if (width >= 520) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = _columnsForWidth(width);
    final products = _filteredProducts;
    final cartCount = _cart.values.fold<int>(0, (sum, qty) => sum + qty);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: _brand,
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Amazon Mini',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.userEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFFD0D6DD)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ..._categories.map(
                (c) => ListTile(
                  leading: Icon(c == 'All' ? Icons.grid_view : Icons.sell),
                  title: Text(c),
                  selected: _selectedCategory == c,
                  onTap: () {
                    setState(() => _selectedCategory = c);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.local_offer),
                title: const Text('Today\'s Deals'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text('Customer Service'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onLogout();
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: _brand,
        foregroundColor: Colors.white,
        titleSpacing: 12,
        title: Row(
          children: [
            const Icon(Icons.shopping_bag, color: _accent),
            const SizedBox(width: 8),
            const Text(
              'amazon',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.4),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 42,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _CartButton(
              count: cartCount,
              onPressed: () async {
                final navigator = Navigator.of(context);
                final result = await navigator.push<_CartResult>(
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      cart: Map<String, int>.from(_cart),
                      products: _products,
                    ),
                  ),
                );

                if (!mounted) return;
                if (result == null) return;
                setState(() {
                  _cart
                    ..clear()
                    ..addAll(result.cart);
                });
                if (result.ordered) {
                  final orderId = _generateOrderId();
                  if (!mounted) return;
                  await navigator.push<void>(
                    MaterialPageRoute(
                      builder: (_) => OrderSuccessPage(orderId: orderId),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const _PromoBanner(
                    title: 'Great Indian Festival',
                    subtitle: 'Up to 60% off • Limited time',
                    icon: Icons.local_fire_department,
                  ),
                  _CategoryChips(
                    categories: _categories.toList(growable: false),
                    selected: _selectedCategory,
                    onSelected: (v) => setState(() => _selectedCategory = v),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return _ProductCard(
                  product: product,
                  onAddToCart: () {
                    setState(() {
                      _cart.update(product.id, (q) => q + 1, ifAbsent: () => 1);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added: ${product.title}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }, childCount: products.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: columns <= 1 ? 1.35 : 0.78,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateOrderId() {
    final now = DateTime.now();
    final millis = now.millisecondsSinceEpoch;
    return 'AMZ-$millis';
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 26),
            Positioned(
              right: -6,
              top: -6,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 120),
                scale: count > 0 ? 1 : 0.9,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9900),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF232F3E), Color(0xFF131921)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9900),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFFD0D6DD)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories
          .map((c) {
            final isSelected = selected == c;
            return ChoiceChip(
              label: Text(c),
              selected: isSelected,
              onSelected: (_) => onSelected(c),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              selectedColor: const Color(0xFF232F3E),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0x22000000)),
            );
          })
          .toList(growable: false),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAddToCart});

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) =>
                _ProductDialog(product: product, onAddToCart: onAddToCart),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _ProductImageWithFallback(product: product),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _RatingStars(rating: product.rating),
                  const SizedBox(width: 6),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  if (product.prime) const _PrimePill(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Add'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9900),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimePill extends StatelessWidget {
  const _PrimePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF232F3E),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Prime',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final hasHalf = (rating - full) >= 0.5 && full < 5;
    final empty = 5 - full - (hasHalf ? 1 : 0);

    Widget star(IconData icon) =>
        Icon(icon, size: 16, color: Colors.amber[700]);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < full; i++) star(Icons.star),
        if (hasHalf) star(Icons.star_half),
        for (var i = 0; i < empty; i++) star(Icons.star_border),
      ],
    );
  }
}

class _ProductDialog extends StatelessWidget {
  const _ProductDialog({required this.product, required this.onAddToCart});

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      title: Row(
        children: [
          const Icon(Icons.shopping_bag),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _ProductImageWithFallback(product: product),
            ),
          ),
          const SizedBox(height: 10),
          Text('Category: ${product.category}'),
          const SizedBox(height: 6),
          Row(
            children: [
              _RatingStars(rating: product.rating),
              const SizedBox(width: 8),
              Text(product.rating.toStringAsFixed(1)),
              const Spacer(),
              if (product.prime) const _PrimePill(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Price: \$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Demo app: products are mock data. Add to cart to see the badge update.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: () {
            onAddToCart();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Add to cart'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF9900),
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.cart, required this.products});

  final Map<String, int> cart;
  final List<Product> products;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const _brand = Color(0xFF131921);
  static const _accent = Color(0xFFFF9900);

  late final Map<String, Product> _productById = <String, Product>{
    for (final p in widget.products) p.id: p,
  };

  Map<String, int> get _cart => widget.cart;

  double get _total {
    double sum = 0;
    _cart.forEach((productId, qty) {
      final product = _productById[productId];
      if (product == null) return;
      sum += product.price * qty;
    });
    return sum;
  }

  int get _count => _cart.values.fold<int>(0, (s, q) => s + q);

  @override
  Widget build(BuildContext context) {
    final items = _cart.entries
        .where((e) => e.value > 0 && _productById.containsKey(e.key))
        .toList(growable: false);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(
          context,
        ).pop(_CartResult(ordered: false, cart: Map<String, int>.from(_cart)));
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
        appBar: AppBar(
          backgroundColor: _brand,
          foregroundColor: Colors.white,
          title: Text('Cart ($_count)'),
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () {
              Navigator.of(context).pop(
                _CartResult(ordered: false, cart: Map<String, int>.from(_cart)),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: items.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                itemBuilder: (context, index) {
                  final entry = items[index];
                  final product = _productById[entry.key]!;
                  final qty = entry.value;
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 94,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: _ProductImageWithFallback(
                                product: product,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _QtyStepper(
                            value: qty,
                            onDecrement: () => setState(() {
                              final next = (qty - 1).clamp(0, 999);
                              if (next == 0) {
                                _cart.remove(product.id);
                              } else {
                                _cart[product.id] = next;
                              }
                            }),
                            onIncrement: () => setState(() {
                              _cart[product.id] = (qty + 1).clamp(1, 999);
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemCount: items.length,
              ),
        bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: Offset(0, -8),
                color: Color(0x22000000),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: items.isEmpty
                      ? null
                      : () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Place order?'),
                              content: Text(
                                'Pay \$${_total.toStringAsFixed(2)} for $_count item(s).',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: _accent,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('Buy'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            Navigator.of(context).pop(
                              const _CartResult(
                                ordered: true,
                                cart: <String, int>{},
                              ),
                            );
                          }
                        },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Buy now'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _CartResult {
  const _CartResult({required this.ordered, required this.cart});

  final bool ordered;
  final Map<String, int> cart;
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Remove',
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w900)),
        IconButton(
          tooltip: 'Add',
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(title: const Text('Order')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Order placed successfully',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Order ID: $orderId',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Continue shopping'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductPhoto extends StatelessWidget {
  const _ProductPhoto({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final base = product.photoColor;
    final shortTitle = product.title.length > 34
        ? '${product.title.substring(0, 34)}…'
        : product.title;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(Colors.white.withValues(alpha: 0.18), base),
            Color.alphaBlend(Colors.black.withValues(alpha: 0.08), base),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -26,
            top: -18,
            child: Icon(
              product.photoIcon,
              size: 170,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          product.photoIcon,
                          color: Colors.black87,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          shortTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImageWithFallback extends StatefulWidget {
  const _ProductImageWithFallback({required this.product});

  final Product product;

  @override
  State<_ProductImageWithFallback> createState() =>
      _ProductImageWithFallbackState();
}

class _ProductImageWithFallbackState extends State<_ProductImageWithFallback> {
  int _index = 0;

  @override
  void didUpdateWidget(covariant _ProductImageWithFallback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.product.imageUrls;
    if (urls.isEmpty || _index >= urls.length) {
      return _ProductPhoto(product: widget.product);
    }

    final url = urls[_index];
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        );
      },
      errorBuilder: (context, error, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _index++);
        });
        return _ProductPhoto(product: widget.product);
      },
    );
  }
}
