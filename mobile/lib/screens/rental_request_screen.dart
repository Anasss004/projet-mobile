import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../services/rental_service.dart';

class RentalRequestScreen extends StatefulWidget {
  final Costume costume;

  const RentalRequestScreen({super.key, required this.costume});

  @override
  State<RentalRequestScreen> createState() => _RentalRequestScreenState();
}

class _RentalRequestScreenState extends State<RentalRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final RentalService _rentalService = RentalService();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez d\'abord sélectionner une date de début')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _submitRentalRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner les dates')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _rentalService.requestRental(
      costumeId: widget.costume.id!,
      startDate: _startDate!,
      endDate: _endDate!,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int _calculateDays() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays;
    }
    return 0;
  }

  double _calculateTotal() {
    final days = _calculateDays();
    return days * widget.costume.prixJournalier;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demande de Location', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.costume.nom,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Taille: ${widget.costume.taille}'),
                      Text('Prix: ${widget.costume.prixJournalier.toStringAsFixed(2)} €/jour'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Date de début',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectStartDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _startDate != null
                        ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                        : 'Sélectionner une date',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Date de fin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectEndDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _endDate != null
                        ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                        : 'Sélectionner une date',
                  ),
                ),
              ),
              if (_startDate != null && _endDate != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Durée:'),
                            Text(
                              '${_calculateDays()} jour(s)',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_calculateTotal().toStringAsFixed(2)} €',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRentalRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Confirmer la demande',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

