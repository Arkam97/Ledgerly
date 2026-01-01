import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../customers/customers_screen.dart';
import '../bills/bills_screen.dart';
import '../payments/payments_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardSummary = ref.watch(dashboardSummaryProvider);
    final outstandingByCustomer = ref.watch(outstandingByCustomerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledgerly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(outstandingByCustomerProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Outstanding Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Outstanding',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      dashboardSummary.when(
                        data: (summary) => Text(
                          NumberFormat.currency(symbol: '\$').format(summary.totalOutstanding),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0f766e),
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text('Error: $error'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Outstanding by Customer (Collapsible)
              const Text(
                'Outstanding by Customer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              outstandingByCustomer.when(
                data: (customers) {
                  if (customers.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text('No outstanding balances'),
                        ),
                      ),
                    );
                  }
                  return ExpansionPanelList.radio(
                    children: customers.map((customer) {
                      return ExpansionPanelRadio(
                        value: customer.customerId,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(customer.customerName),
                            subtitle: Text(
                              '${customer.openBillsCount} open bill(s)',
                            ),
                            trailing: Text(
                              NumberFormat.currency(symbol: '\$').format(customer.totalOutstanding),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0f766e),
                              ),
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (customer.lastBillDate != null)
                                Text(
                                  'Last Bill: ${DateFormat('MMM dd, yyyy').format(customer.lastBillDate!)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              const SizedBox(height: 16),
                              const Text(
                                'Bills:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...customer.bills.map((bill) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(
                                      bill.billNumber ?? 'Bill #${bill.billId.substring(0, 8)}',
                                    ),
                                    subtitle: Text(
                                      DateFormat('MMM dd, yyyy').format(bill.billDate),
                                    ),
                                    trailing: Text(
                                      NumberFormat.currency(symbol: '\$').format(bill.outstandingAmount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Error: $error'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomersScreen(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BillsScreen(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentsScreen(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}

