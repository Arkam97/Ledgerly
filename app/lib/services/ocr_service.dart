import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<OcrResult> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      final text = recognizedText.text;
      
      // Parse amount and date from text
      final amount = _extractAmount(text);
      final date = _extractDate(text);
      
      return OcrResult(
        text: text,
        amount: amount,
        date: date,
      );
    } catch (e) {
      throw Exception('OCR processing failed: $e');
    } finally {
      await _textRecognizer.close();
    }
  }

  double? _extractAmount(String text) {
    // Try to find currency amounts (supports various formats)
    final patterns = [
      r'[\$₹€£]?\s*(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)', // $1,234.56 or 1234.56
      r'(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)\s*[\$₹€£]', // 1,234.56$ or 1234.56
      r'amount[:\s]+[\$₹€£]?\s*(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)', // Amount: $1,234.56
      r'total[:\s]+[\$₹€£]?\s*(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)', // Total: $1,234.56
      r'paid[:\s]+[\$₹€£]?\s*(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)', // Paid: $1,234.56
    ];

    for (final pattern in patterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      final match = regex.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > 0) {
            return amount;
          }
        }
      }
    }

    return null;
  }

  DateTime? _extractDate(String text) {
    // Try various date formats
    final datePatterns = [
      r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})', // MM/DD/YYYY or DD/MM/YYYY
      r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})', // YYYY/MM/DD
      r'(\d{1,2})\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{2,4})', // DD MMM YYYY
    ];

    for (final pattern in datePatterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      final match = regex.firstMatch(text);
      if (match != null) {
        try {
          // Try parsing the date
          final dateStr = match.group(0);
          if (dateStr != null) {
            // Try common date formats
            final formats = [
              DateFormat('MM/dd/yyyy'),
              DateFormat('dd/MM/yyyy'),
              DateFormat('yyyy/MM/dd'),
              DateFormat('MM-dd-yyyy'),
              DateFormat('dd-MM-yyyy'),
              DateFormat('yyyy-MM-dd'),
              DateFormat('dd MMM yyyy'),
            ];

            for (final format in formats) {
              try {
                final date = format.parse(dateStr);
                // Only accept dates that are not too far in the future or past
                final now = DateTime.now();
                if (date.isBefore(now.add(const Duration(days: 365))) &&
                    date.isAfter(now.subtract(const Duration(days: 3650)))) {
                  return date;
                }
              } catch (_) {
                continue;
              }
            }
          }
        } catch (_) {
          continue;
        }
      }
    }

    return null;
  }

  void dispose() {
    _textRecognizer.close();
  }
}

class OcrResult {
  final String text;
  final double? amount;
  final DateTime? date;

  OcrResult({
    required this.text,
    this.amount,
    this.date,
  });
}

