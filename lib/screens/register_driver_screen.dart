import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterDriverScreen extends StatefulWidget {
  const RegisterDriverScreen({super.key});

  @override
  State<RegisterDriverScreen> createState() => _RegisterDriverScreenState();
}

class _RegisterDriverScreenState extends State<RegisterDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _driverAdminIdController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _licenseController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _driverAdminIdController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Remove '+' prefix from phone number for backend compatibility
      String cleanPhoneNumber = _phoneController.text.trim().replaceAll('+', '');
      
      await AuthService.registerDriver(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: cleanPhoneNumber,
        password: _passwordController.text,
        licenseNumber: _licenseController.text.trim(),
        vehicleType: _vehicleTypeController.text.trim(),
        vehicleNumber: _vehicleNumberController.text.trim(),
        driverAdminId: _driverAdminIdController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver registered successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Driver'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)), validator: (v) => v == null || !v.contains('@') ? 'Invalid' : null),
            const SizedBox(height: 16),

            TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
              ),
              validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(controller: _licenseController, decoration: const InputDecoration(labelText: 'License Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),

            TextFormField(controller: _vehicleTypeController, decoration: const InputDecoration(labelText: 'Vehicle Type', border: OutlineInputBorder(), prefixIcon: Icon(Icons.directions_car), hintText: 'e.g., Car, Motorcycle'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),

            TextFormField(controller: _vehicleNumberController, decoration: const InputDecoration(labelText: 'Vehicle Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.confirmation_number)), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),

            TextFormField(controller: _driverAdminIdController, decoration: const InputDecoration(labelText: 'Driver Admin ID', border: OutlineInputBorder(), prefixIcon: Icon(Icons.admin_panel_settings)), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 32),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : const Text('Register Driver', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
