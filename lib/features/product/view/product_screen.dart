import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:uc_coffee_shop/features/product/view/cart_screen.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/cart_viewmodel.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/product_viewmodel.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      if (authViewModel.user?.accessToken != null) {
        Provider.of<ProductViewModel>(context, listen: false)
            .fetchProducts(authViewModel.user!.accessToken!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      backgroundColor: CoffeeShopTheme.cream,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CoffeeShopTheme.lightCream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.coffee,
                color: CoffeeShopTheme.primaryBrown,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Coffee Menu',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (cartViewModel.cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: CoffeeShopTheme.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartViewModel.cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
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
      ),
      body: Container(
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
        child: productViewModel.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CoffeeShopTheme.lightCream,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CoffeeShopTheme.primaryBrown,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Brewing your coffee menu...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: CoffeeShopTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              )
            : productViewModel.error != null
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CoffeeShopTheme.lightCream,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CoffeeShopTheme.errorColor.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: CoffeeShopTheme.errorColor,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Oops! Something went wrong',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: CoffeeShopTheme.errorColor,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            productViewModel.error!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                              if (authViewModel.user?.accessToken != null) {
                                productViewModel.fetchProducts(authViewModel.user!.accessToken!);
                              }
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CoffeeShopTheme.primaryBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: productViewModel.products.length,
                      itemBuilder: (context, index) {
                        final product = productViewModel.products[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: CoffeeShopTheme.lightCream,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: CoffeeShopTheme.darkBrown.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          CoffeeShopTheme.lightBrown.withOpacity(0.1),
                                          CoffeeShopTheme.primaryBrown.withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          product.imageUrl ?? '',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: CoffeeShopTheme.lightBrown.withOpacity(0.1),
                                              child: const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.coffee,
                                                    size: 40,
                                                    color: CoffeeShopTheme.primaryBrown,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'No Image',
                                                    style: TextStyle(
                                                      color: CoffeeShopTheme.textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: CoffeeShopTheme.primaryBrown,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                              style: const TextStyle(
                                                color: CoffeeShopTheme.textLight,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name ?? 'Unknown Coffee',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: CoffeeShopTheme.textPrimary,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              cartViewModel.addToCart(product);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.check_circle,
                                                        color: CoffeeShopTheme.textLight,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          '${product.name} added to cart!',
                                                          style: const TextStyle(
                                                            color: CoffeeShopTheme.textLight,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor: CoffeeShopTheme.successColor,
                                                  duration: const Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add_shopping_cart,
                                              size: 16,
                                            ),
                                            label: const Text(
                                              'Add to Cart',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: CoffeeShopTheme.primaryBrown,
                                              foregroundColor: CoffeeShopTheme.textLight,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
