import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:uc_coffee_shop/features/orders/viewmodel/order_viewmodel.dart';
import 'package:uc_coffee_shop/features/payments/view/checkout_screen.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/cart_viewmodel.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  void _checkout() async {
    setState(() {
      _isLoading = true;
    });

    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);

    final orderDetails = cartViewModel.cartItems.entries
        .map((entry) => {
              'product_id': entry.key.id,
              'quantity': entry.value,
              'unit_price': entry.key.price,
            })
        .toList();

    final orderData = {
      'user_id': authViewModel.user!.id,
      'details': orderDetails,
    };

    final success = await orderViewModel.createOrder(
        authViewModel.user!.accessToken!,
        orderData);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckoutScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create order'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      backgroundColor: CoffeeShopTheme.cream,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart,
              color: CoffeeShopTheme.textLight,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'My Cart',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CoffeeShopTheme.primaryBrown,
                CoffeeShopTheme.darkBrown,
              ],
            ),
          ),
        ),
        elevation: 4,
      ),
      body: cartViewModel.cartItems.isEmpty
          ? _buildEmptyCartState()
          : Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CoffeeShopTheme.cream,
                          CoffeeShopTheme.lightCream,
                        ],
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartViewModel.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartViewModel.cartItems.keys.elementAt(index);
                        final quantity = cartViewModel.cartItems.values.elementAt(index);
                        return _buildCartItem(product, quantity, cartViewModel);
                      },
                    ),
                  ),
                ),
                _buildCheckoutSection(cartViewModel),
              ],
            ),
    );
  }

  Widget _buildEmptyCartState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CoffeeShopTheme.cream,
            CoffeeShopTheme.lightCream,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: CoffeeShopTheme.lightCream,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: CoffeeShopTheme.primaryBrown,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CoffeeShopTheme.primaryBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some delicious coffee to get started!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CoffeeShopTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.coffee),
              label: const Text('Browse Menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoffeeShopTheme.primaryBrown,
                foregroundColor: CoffeeShopTheme.textLight,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(dynamic product, int quantity, CartViewModel cartViewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CoffeeShopTheme.lightCream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: CoffeeShopTheme.cream,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.coffee,
                        color: CoffeeShopTheme.primaryBrown,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Unknown Product',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CoffeeShopTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CoffeeShopTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Subtotal: \$${((product.price ?? 0) * quantity).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CoffeeShopTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                color: CoffeeShopTheme.cream,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: CoffeeShopTheme.primaryBrown.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: CoffeeShopTheme.primaryBrown,
                    onPressed: () {
                      cartViewModel.removeFromCart(product);
                    },
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CoffeeShopTheme.primaryBrown,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: CoffeeShopTheme.primaryBrown,
                    onPressed: () {
                      cartViewModel.addToCart(product);
                    },
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartViewModel cartViewModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CoffeeShopTheme.lightCream,
            CoffeeShopTheme.cream,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CoffeeShopTheme.lightCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items (${cartViewModel.cartItems.values.fold(0, (sum, qty) => sum + qty)})',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CoffeeShopTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${cartViewModel.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CoffeeShopTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: CoffeeShopTheme.primaryBrown.withOpacity(0.2),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CoffeeShopTheme.primaryBrown,
                        ),
                      ),
                      Text(
                        '\$${cartViewModel.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CoffeeShopTheme.primaryBrown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: _isLoading
                  ? Container(
                      decoration: BoxDecoration(
                        color: CoffeeShopTheme.lightCream,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: CoffeeShopTheme.primaryBrown.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CoffeeShopTheme.primaryBrown,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Processing your order...',
                              style: TextStyle(
                                color: CoffeeShopTheme.primaryBrown,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _checkout,
                      icon: const Icon(Icons.payment),
                      label: const Text('Proceed to Checkout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoffeeShopTheme.primaryBrown,
                        foregroundColor: CoffeeShopTheme.textLight,
                        elevation: 4,
                        shadowColor: CoffeeShopTheme.darkBrown.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
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
