import 'package:flutter/material.dart';
import 'register_super_admin_screen.dart';
import 'register_hospital_screen.dart';
import 'register_driver_admin_screen.dart';
import 'register_driver_screen.dart';
import 'register_patient_screen.dart';

class RegistrationSelectionScreen extends StatelessWidget {
  const RegistrationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Registration Type'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Register As',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select your role to create an account',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Super Admin (Public Access)
              _buildRoleCard(
                context,
                icon: Icons.admin_panel_settings,
                title: 'Super Admin',
                subtitle: 'System administrator - First time setup',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterSuperAdminScreen(),
                    ),
                  );
                },
                badge: 'Public Access',
              ),
              const SizedBox(height: 16),

              // Patient Registration
              _buildRoleCard(
                context,
                icon: Icons.pregnant_woman,
                title: 'Patient',
                subtitle: 'Pregnant woman - Registered by Hospital',
                color: Colors.pink,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPatientScreen(),
                    ),
                  );
                },
                badge: 'Hospital Access',
              ),
              const SizedBox(height: 16),

              // Hospital Registration
              _buildRoleCard(
                context,
                icon: Icons.local_hospital,
                title: 'Hospital',
                subtitle: 'Medical facility - Registered by Super Admin',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterHospitalScreen(),
                    ),
                  );
                },
                badge: 'Super Admin Access',
              ),
              const SizedBox(height: 16),

              // Driver Admin Registration
              _buildRoleCard(
                context,
                icon: Icons.business,
                title: 'Driver Admin',
                subtitle: 'Driver organization - Registered by Super Admin',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterDriverAdminScreen(),
                    ),
                  );
                },
                badge: 'Super Admin Access',
              ),
              const SizedBox(height: 16),

              // Driver Registration
              _buildRoleCard(
                context,
                icon: Icons.local_taxi,
                title: 'Driver',
                subtitle: 'Emergency responder - Registered by Driver Admin',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterDriverScreen(),
                    ),
                  );
                },
                badge: 'Driver Admin Access',
              ),

              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required String badge,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
