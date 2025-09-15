import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:uc_coffee_shop/features/orders/view/order_confirmation_screen.dart';
import 'package:uc_coffee_shop/features/orders/viewmodel/order_viewmodel.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/cart_viewmodel.dart';

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
            builder: (context) => const OrderConfirmationScreen(),
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
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartViewModel.cartItems.length,
              itemBuilder: (context, index) {
                final product = cartViewModel.cartItems.keys.elementAt(index);
                final quantity = cartViewModel.cartItems.values.elementAt(index);
                return ListTile(
                  leading: Image.network(product.imageUrl ?? ''),
                  title: Text(product.name ?? ''),
                  subtitle: Text('\$${product.price?.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          cartViewModel.removeFromCart(product);
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          cartViewModel.addToCart(product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${cartViewModel.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _checkout,
                        child: const Text('Checkout'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
