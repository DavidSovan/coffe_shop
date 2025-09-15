import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/auth/view/login_screen.dart';
import 'package:uc_coffee_shop/features/auth/viewmodel/auth_viewmodel.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final auth = Provider.of<AuthViewModel>(context, listen: false);
              final success = await auth.logout();
              if (success) {
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(auth.errorMessage.isNotEmpty ? auth.errorMessage : 'Logout failed')),
                );
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text('Product Screen')),
    );
  }
}
