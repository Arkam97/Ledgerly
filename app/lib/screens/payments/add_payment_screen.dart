import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/payment/create_payment_request.dart';
import '../../providers/payment_provider.dart';
import '../../providers/bill_provider.dart';
import '../../providers/customer_provider.dart';
import '../../services/ocr_service.dart';
import '../../services/payment_service.dart';

class AddPaymentScreen extends ConsumerStatefulWidget {
  final String? customerId;
  final String? customerName;

  const AddPaymentScreen({
    super.key,
    this.customerId,
    this.customerName,
  });

  @override
  ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _ocrService = OcrService();
  final _paymentService = PaymentService();
  
  DateTime _paymentDate = DateTime.now();
  String? _selectedCustomerId;
  String? _selectedBillId;
  File? _selectedImage;
  double? _ocrAmount;
  DateTime? _ocrDate;
  bool _isProcessingOcr = false;
  String? _ocrText;

  @override
  void initState() {
    super.initState();
    _selectedCustomerId = widget.customerId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isProcessingOcr = true;
      });

      try {
        // Process OCR
        final ocrResult = await _ocrService.extractTextFromImage(_selectedImage!);
        
        setState(() {
          _ocrAmount = ocrResult.amount;
          _ocrDate = ocrResult.date;
          _ocrText = ocrResult.text;
          _isProcessingOcr = false;
        });

        // Update form fields if OCR found values
        if (_ocrAmount != null) {
          _amountController.text = _ocrAmount!.toStringAsFixed(2);
        }
        if (_ocrDate != null) {
          _paymentDate = _ocrDate!;
        }

        // Upload file to backend
        final uploadResult = await _paymentService.uploadReceiptForOcr(_selectedImage!);
        
        // Show OCR results dialog
        if (mounted) {
          _showOcrResultsDialog(ocrResult, uploadResult);
        }
      } catch (e) {
        setState(() {
          _isProcessingOcr = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OCR Error: $e')),
          );
        }
      }
    }
  }

  void _showOcrResultsDialog(OcrResult ocrResult, Map<String, dynamic> uploadResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OCR Results'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_ocrAmount != null)
                Text('Amount: \$${_ocrAmount!.toStringAsFixed(2)}'),
              if (_ocrDate != null)
                Text('Date: ${_ocrDate!.toString().split(' ')[0]}'),
              const SizedBox(height: 16),
              const Text('Extracted Text:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                _ocrText ?? 'No text extracted',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _paymentDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a customer')),
        );
        return;
      }

      if (_selectedBillId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a bill')),
        );
        return;
      }

      // Get receipt file ID if image was uploaded
      String? receiptFileId;
      if (_selectedImage != null) {
        // This would be set from the upload result
        // For now, we'll need to handle this in the flow
      }

      final request = CreatePaymentRequest(
        billId: _selectedBillId!,
        customerId: _selectedCustomerId!,
        amount: double.parse(_amountController.text),
        paymentDate: _paymentDate,
        reference: _referenceController.text.trim().isEmpty
            ? null
            : _referenceController.text.trim(),
        receiptFileId: receiptFileId,
      );

      ref.read(createPaymentProvider(request).future).then((_) {
        ref.invalidate(paymentsProvider);
        ref.invalidate(billsProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment recorded successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final billsAsync = _selectedCustomerId != null
        ? ref.watch(billsProvider(BillFilter(
            customerId: _selectedCustomerId,
            status: 'open',
          )))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Receipt Image Section
              if (_selectedImage != null)
                Card(
                  child: Column(
                    children: [
                      Image.file(
                        _selectedImage!,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      if (_isProcessingOcr)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Receipt'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Customer Selection
              if (widget.customerId == null)
                customersAsync.when(
                  data: (customers) {
                    return DropdownButtonFormField<String>(
                      value: _selectedCustomerId,
                      decoration: const InputDecoration(
                        labelText: 'Customer *',
                        border: OutlineInputBorder(),
                      ),
                      items: customers.map((customer) {
                        return DropdownMenuItem(
                          value: customer.id,
                          child: Text(customer.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCustomerId = value;
                          _selectedBillId = null; // Reset bill selection
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a customer';
                        }
                        return null;
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading customers'),
                )
              else
                TextFormField(
                  initialValue: widget.customerName,
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    border: OutlineInputBorder(),
                    enabled: false,
                  ),
                ),
              const SizedBox(height: 16),

              // Bill Selection
              if (_selectedCustomerId != null && billsAsync != null)
                billsAsync.when(
                  data: (bills) {
                    if (bills.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No open bills for this customer'),
                        ),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedBillId,
                      decoration: const InputDecoration(
                        labelText: 'Bill *',
                        border: OutlineInputBorder(),
                      ),
                      items: bills.map((bill) {
                        return DropdownMenuItem(
                          value: bill.id,
                          child: Text(
                            '${bill.billNumber ?? 'Bill #${bill.id.substring(0, 8)}'} - Outstanding: \$${bill.outstandingAmount.toStringAsFixed(2)}',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBillId = value;
                          // Auto-fill amount with outstanding if not set
                          if (_amountController.text.isEmpty && value != null) {
                            final bill = bills.firstWhere((b) => b.id == value);
                            _amountController.text = bill.outstandingAmount.toStringAsFixed(2);
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a bill';
                        }
                        return null;
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading bills'),
                ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Payment Date *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_paymentDate.year}-${_paymentDate.month.toString().padLeft(2, '0')}-${_paymentDate.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Record Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

