import 'package:flutter/material.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  final int orderId;
  final double amount;
  final String currency;
  final String method;
  final String status;
  final DateTime dateTime;

  const ReceiptScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.receipt, color: CoffeeShopTheme.textLight, size: 22),
            SizedBox(width: 8),
            Text('Receipt'),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CoffeeShopTheme.primaryBrown, CoffeeShopTheme.darkBrown],
            ),
          ),
        ),
      ),
      backgroundColor: CoffeeShopTheme.cream,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CoffeeShopTheme.lightCream,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CoffeeShopTheme.darkBrown.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID', style: Theme.of(context).textTheme.bodyLarge),
                      Text('#$orderId', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount Paid', style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        '$currency ${amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: CoffeeShopTheme.primaryBrown,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Method', style: Theme.of(context).textTheme.bodyLarge),
                      Text(method.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status', style: Theme.of(context).textTheme.bodyLarge),
                      Chip(
                        label: Text(status.toUpperCase()),
                        backgroundColor:
                            status.toLowerCase() == 'completed' ? Colors.green.shade100 : Colors.orange.shade100,
                        labelStyle: TextStyle(
                          color: status.toLowerCase() == 'completed' ? Colors.green.shade800 : Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date/Time', style: Theme.of(context).textTheme.bodyLarge),
                      Text(dateTime.toLocal().toString()),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoffeeShopTheme.primaryBrown,
                  foregroundColor: CoffeeShopTheme.textLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
