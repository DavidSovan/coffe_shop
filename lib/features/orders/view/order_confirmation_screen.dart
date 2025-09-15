import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/orders/viewmodel/order_viewmodel.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${orderViewModel.order!.id}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Total Amount: \$${orderViewModel.order!.totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${orderViewModel.order!.createdAt}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orderViewModel.order!.details.length,
                itemBuilder: (context, index) {
                  final detail = orderViewModel.order!.details[index];
                  return ListTile(
                    title: Text('Product ID: ${detail.productId}'),
                    subtitle: Text(
                        '${detail.quantity} x \$${detail.unitPrice.toStringAsFixed(2)}'),
                    trailing: Text('\$${detail.subtotal.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
