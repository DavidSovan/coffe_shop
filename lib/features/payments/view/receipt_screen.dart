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
            Icon(Icons.receipt_long, color: CoffeeShopTheme.textLight, size: 22),
            SizedBox(width: 8),
            Text('Payment Receipt'),
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
        elevation: 4,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CoffeeShopTheme.lightCream,
                      CoffeeShopTheme.cream,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: CoffeeShopTheme.darkBrown.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade200,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Payment Successful!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: CoffeeShopTheme.primaryBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thank you for your coffee order',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CoffeeShopTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Receipt Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CoffeeShopTheme.lightCream,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CoffeeShopTheme.darkBrown.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.coffee,
                          color: CoffeeShopTheme.primaryBrown,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Receipt Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: CoffeeShopTheme.primaryBrown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildReceiptRow(
                      context,
                      'Order ID',
                      '#$orderId',
                      Icons.receipt_long,
                    ),
                    const SizedBox(height: 16),
                    _buildReceiptRow(
                      context,
                      'Amount Paid',
                      '$currency ${amount.toStringAsFixed(2)}',
                      Icons.attach_money,
                      isHighlighted: true,
                    ),
                    const SizedBox(height: 16),
                    _buildReceiptRow(
                      context,
                      'Payment Method',
                      _formatPaymentMethod(method),
                      method.toLowerCase() == 'cash' ? Icons.money : Icons.credit_card,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: CoffeeShopTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Status',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: CoffeeShopTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: status.toLowerCase() == 'completed'
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: status.toLowerCase() == 'completed'
                                  ? Colors.green.shade300
                                  : Colors.orange.shade300,
                            ),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: status.toLowerCase() == 'completed'
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildReceiptRow(
                      context,
                      'Date & Time',
                      _formatDateTime(dateTime),
                      Icons.access_time,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Could add share receipt functionality
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: CoffeeShopTheme.primaryBrown,
                        side: const BorderSide(color: CoffeeShopTheme.primaryBrown),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoffeeShopTheme.primaryBrown,
                        foregroundColor: CoffeeShopTheme.textLight,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: CoffeeShopTheme.darkBrown.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: CoffeeShopTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CoffeeShopTheme.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: isHighlighted
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
              : EdgeInsets.zero,
          decoration: isHighlighted
              ? BoxDecoration(
                  color: CoffeeShopTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isHighlighted
                  ? CoffeeShopTheme.accent
                  : CoffeeShopTheme.textPrimary,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Cash Payment';
      case 'credit_card':
        return 'Credit Card';
      default:
        return method.toUpperCase();
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final date = '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
    final time = '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }
}
