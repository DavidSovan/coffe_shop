import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_coffee_shop/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:uc_coffee_shop/features/orders/viewmodel/order_viewmodel.dart';
import 'package:uc_coffee_shop/features/payments/view/payment_method_dialog.dart';
import 'package:uc_coffee_shop/features/payments/view/receipt_screen.dart';
import 'package:uc_coffee_shop/features/payments/viewmodel/payment_viewmodel.dart';
import 'package:uc_coffee_shop/theme/app_theme.dart';
import 'package:uc_coffee_shop/features/product/viewmodel/cart_viewmodel.dart';

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
          ? Container(
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
              child: const Center(
                child: Text(
                  'No order available',
                  style: TextStyle(
                    color: CoffeeShopTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                      border: Border.all(
                        color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: CoffeeShopTheme.primaryBrown,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: CoffeeShopTheme.darkBrown.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.receipt_long,
                                color: CoffeeShopTheme.textLight,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Summary',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: CoffeeShopTheme.primaryBrown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Order #${order.id}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: CoffeeShopTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CoffeeShopTheme.cream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: CoffeeShopTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: CoffeeShopTheme.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: CoffeeShopTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Order Date: ${order.createdAt.toString().split('.')[0]}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CoffeeShopTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
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
                        Row(
                          children: [
                            Icon(
                              Icons.coffee,
                              color: CoffeeShopTheme.primaryBrown,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Order Items',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: CoffeeShopTheme.primaryBrown,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...order.details.map((d) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CoffeeShopTheme.cream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: CoffeeShopTheme.primaryBrown.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.coffee,
                                  color: CoffeeShopTheme.primaryBrown,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product #${d.productId}',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: CoffeeShopTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${d.quantity} × \$${d.unitPrice.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: CoffeeShopTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: CoffeeShopTheme.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '\$${d.subtotal.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: CoffeeShopTheme.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CoffeeShopTheme.lightCream,
                          CoffeeShopTheme.cream,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: CoffeeShopTheme.darkBrown.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SizedBox(
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
                              // Clear cart after successful payment completion
                              Provider.of<CartViewModel>(context, listen: false).clearCart();
                              
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
                              ? 'Confirm Payment Method'
                              : paymentVM.state == PaymentState.creating
                                  ? 'Creating Payment...'
                                  : paymentVM.state == PaymentState.completing
                                      ? 'Processing Payment...'
                                      : paymentVM.state == PaymentState.completed
                                          ? 'Payment Completed'
                                          : 'Pay Now',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CoffeeShopTheme.primaryBrown,
                          foregroundColor: CoffeeShopTheme.textLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 6,
                          shadowColor: CoffeeShopTheme.darkBrown.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
    );
  }
}
