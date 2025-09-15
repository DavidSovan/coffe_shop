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
    return AlertDialog(
      title: const Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            value: 'cash',
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v!),
            title: const Text('Cash'),
          ),
          RadioListTile<String>(
            value: 'credit_card',
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v!),
            title: const Text('Card'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selected),
          style: ElevatedButton.styleFrom(backgroundColor: CoffeeShopTheme.primaryBrown,
            foregroundColor: CoffeeShopTheme.textLight),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
