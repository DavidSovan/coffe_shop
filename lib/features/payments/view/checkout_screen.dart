import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:uc_coffee_shop/features/orders/viewmodel/order_viewmodel.dart';
import 'package:uc_coffee_shop/features/payments/view/payment_method_dialog.dart';
import 'package:uc_coffee_shop/features/payments/view/receipt_screen.dart';
import 'package:uc_coffee_shop/features/payments/viewmodel/payment_viewmodel.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderVM = Provider.of<OrderViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context);

    final order = orderVM.order;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long, color: CoffeeShopTheme.textLight, size: 24),
            const SizedBox(width: 8),
            const Text('Checkout'),
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
      ),
      backgroundColor: CoffeeShopTheme.cream,
      body: order == null
          ? const Center(child: Text('No order available'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CoffeeShopTheme.lightCream,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: CoffeeShopTheme.darkBrown.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ${order.id}', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: CoffeeShopTheme.primaryBrown,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text('Date: ${order.createdAt}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: order.details.length,
                      itemBuilder: (context, index) {
                        final d = order.details[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CoffeeShopTheme.lightCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CoffeeShopTheme.primaryBrown.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Product #${d.productId} x ${d.quantity}'),
                              Text('\$${d.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(color: CoffeeShopTheme.accent, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: paymentVM.state == PaymentState.creating || paymentVM.state == PaymentState.completing
                          ? null
                          : () async {
                              final created = await paymentVM.createPayment(
                                accessToken: authVM.user!.accessToken!,
                                userId: authVM.user!.id,
                                orderId: order.id,
                                amount: order.totalAmount,
                              );
                              if (!created) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(paymentVM.errorMessage ?? 'Failed to create payment')),
                                  );
                                }
                                return;
                              }

                              if (!context.mounted) return;
                              final method = await showDialog<String>(
                                context: context,
                                builder: (_) => const PaymentMethodDialog(),
                              );
                              if (method == null) return; // Cancelled

                              paymentVM.selectMethod(method);

                              final completed = await paymentVM.completePayment(
                                accessToken: authVM.user!.accessToken!,
                                userId: authVM.user!.id,
                                orderId: order.id,
                                amount: order.totalAmount,
                              );

                              if (!completed) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(paymentVM.errorMessage ?? 'Failed to complete payment')),
                                  );
                                }
                                return;
                              }

                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReceiptScreen(
                                    orderId: order.id,
                                    amount: paymentVM.payment!.amount,
                                    currency: paymentVM.payment!.currency,
                                    method: paymentVM.payment!.method,
                                    status: paymentVM.payment!.status,
                                    dateTime: paymentVM.payment!.createdAt,
                                  ),
                                ),
                              );
                            },
                      icon: paymentVM.state == PaymentState.creating || paymentVM.state == PaymentState.completing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(CoffeeShopTheme.textLight),
                              ),
                            )
                          : const Icon(Icons.payment),
                      label: Text(
                        paymentVM.state == PaymentState.pending
                            ? 'Payment Pending - Confirm Method'
                            : paymentVM.state == PaymentState.completed
                                ? 'Payment Completed'
                                : 'Pay Now',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoffeeShopTheme.primaryBrown,
                        foregroundColor: CoffeeShopTheme.textLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
