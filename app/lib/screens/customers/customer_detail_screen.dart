import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/customer_provider.dart';
import '../../providers/bill_provider.dart';
import '../../screens/bills/add_bill_screen.dart';
import '../../screens/payments/add_payment_screen.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final String customerId;

  const CustomerDetailScreen({
    super.key,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsync = ref.watch(customerProvider(customerId));
    final billsAsync = ref.watch(billsProvider(BillFilter(
      customerId: customerId,
      status: 'open',
    )));

    return Scaffold(
      appBar: AppBar(
        title: customerAsync.when(
          data: (customer) => Text(customer.name),
          loading: () => const Text('Customer'),
          error: (_, __) => const Text('Customer'),
        ),
      ),
      body: customerAsync.when(
        data: (customer) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (customer.contact != null) ...[
                          const SizedBox(height: 8),
                          Text('Contact: ${customer.contact}'),
                        ],
                        if (customer.notes != null) ...[
                          const SizedBox(height: 8),
                          Text('Notes: ${customer.notes}'),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                billsAsync.when(
                  data: (bills) {
                    if (bills.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(
                            child: Text('No bills yet'),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: bills.map((bill) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              bill.billNumber ?? 'Bill #${bill.id.substring(0, 8)}',
                            ),
                            subtitle: Text(
                              '${DateFormat('MMM dd, yyyy').format(bill.billDate)} • ${bill.status}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  NumberFormat.currency(symbol: '\$').format(bill.totalAmount),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Outstanding: ${NumberFormat.currency(symbol: '\$').format(bill.outstandingAmount)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bill.outstandingAmount > 0
                                        ? Colors.orange
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_payment',
            onPressed: () {
              customerAsync.whenData((customer) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPaymentScreen(
                      customerId: customer.id,
                      customerName: customer.name,
                    ),
                  ),
                );
              });
            },
            child: const Icon(Icons.payment),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add_bill',
            onPressed: () {
              customerAsync.whenData((customer) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBillScreen(
                      customerId: customer.id,
                      customerName: customer.name,
                    ),
                  ),
                );
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

