import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/bill_provider.dart';
import 'add_bill_screen.dart';

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider(const BillFilter()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
      ),
      body: billsAsync.when(
        data: (bills) {
          if (bills.isEmpty) {
            return const Center(
              child: Text('No bills yet. Create your first bill!'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(billsProvider);
            },
            child: ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      bill.billNumber ?? 'Bill #${bill.id.substring(0, 8)}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bill.customerName),
                        Text(
                          DateFormat('MMM dd, yyyy').format(bill.billDate),
                        ),
                        Text(
                          'Status: ${bill.status}',
                          style: TextStyle(
                            color: bill.status == 'open'
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.currency(symbol: '\$').format(bill.totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (bill.outstandingAmount > 0)
                          Text(
                            'Outstanding: ${NumberFormat.currency(symbol: '\$').format(bill.outstandingAmount)}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(billsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBillScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

