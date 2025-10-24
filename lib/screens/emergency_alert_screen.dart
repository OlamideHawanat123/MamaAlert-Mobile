import 'package:flutter/material.dart';
import '../services/emergency_service.dart';
import '../services/auth_service.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isTriggering = false;
  bool _alertSent = false;
  String? _errorMessage;
  String _patientId = '';
  final _patientIdController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndTriggerAlert() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Validate patient ID
    if (_patientIdController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a patient ID'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Emergency Alert'),
        content: Text(
          'This will notify:\n'
          '• Your emergency contact\n'
          '• Nearby available drivers\n'
          '• Your registered hospital\n\n'
          'Patient ID: ${_patientIdController.text.trim()}\n\n'
          'Are you sure you want to send an emergency alert?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _triggerEmergencyAlert();
    }
  }

  Future<void> _triggerEmergencyAlert() async {
    setState(() {
      _isTriggering = true;
      _errorMessage = null;
    });

    try {
      // Get user ID from auth service
      final userId = await AuthService.getUserId();
      
      if (userId == null) {
        throw Exception('Not logged in. Please login again.');
      }

      // Call emergency alert API
      await EmergencyService.triggerEmergencyAlert(
        patientId: _patientIdController.text.trim(), // Use entered patient ID
        latitude: 9.0820, // Demo coordinates - in production use GPS
        longitude: 8.6753,
      );

      setState(() {
        _alertSent = true;
        _isTriggering = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency alert sent successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      
      setState(() {
        _errorMessage = errorMsg;
        _isTriggering = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: $errorMsg'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alert'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_alertSent) ...[
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Emergency Assistance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Press the button below to notify:\n\n'
                  '• Your emergency contact\n'
                  '• Nearby drivers (within 10km)\n'
                  '• Your registered hospital',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Patient ID input
                TextFormField(
                  controller: _patientIdController,
                  decoration: const InputDecoration(
                    labelText: 'Patient ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Enter patient entity ID',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Patient ID is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: ElevatedButton(
                    onPressed: _isTriggering ? null : _confirmAndTriggerAlert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    child: _isTriggering
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emergency_share, size: 64),
                              SizedBox(height: 12),
                              Text(
                                'SEND EMERGENCY ALERT',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Alert Sent Successfully!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Help is on the way!\n\n'
                  'Your emergency contact and nearby drivers have been notified.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}