import 'package:flutter/material.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';

class PaymentMethodDialog extends StatefulWidget {
  const PaymentMethodDialog({super.key});

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  String _selected = 'credit_card';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CoffeeShopTheme.cream,
              CoffeeShopTheme.lightCream,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CoffeeShopTheme.primaryBrown,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CoffeeShopTheme.darkBrown.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.payment,
                  color: CoffeeShopTheme.textLight,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Payment Method',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: CoffeeShopTheme.primaryBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Payment method options
              _buildPaymentOption(
                'cash',
                'Cash',
                Icons.money,
                'Pay with cash at pickup',
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'credit_card',
                'Credit Card',
                Icons.credit_card,
                'Pay with your credit/debit card',
              ),
              const SizedBox(height: 32),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: CoffeeShopTheme.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context, _selected),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Payment'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    IconData icon,
    String description,
  ) {
    final isSelected = _selected == value;
    return GestureDetector(
      onTap: () => setState(() => _selected = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? CoffeeShopTheme.primaryBrown.withOpacity(0.1) : CoffeeShopTheme.lightCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? CoffeeShopTheme.primaryBrown : CoffeeShopTheme.primaryBrown.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? CoffeeShopTheme.primaryBrown : CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? CoffeeShopTheme.textLight : CoffeeShopTheme.primaryBrown,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CoffeeShopTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CoffeeShopTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v!),
              activeColor: CoffeeShopTheme.primaryBrown,
            ),
          ],
        ),
      ),
    );
  }
}
