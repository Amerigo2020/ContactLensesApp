import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/app_config.dart';
import '../../../utils/validators.dart';

class PrescriptionSetupScreen extends StatefulWidget {
  const PrescriptionSetupScreen({super.key});

  @override
  State<PrescriptionSetupScreen> createState() => _PrescriptionSetupScreenState();
}

class _PrescriptionSetupScreenState extends State<PrescriptionSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _leftDiopter;
  String? _rightDiopter;
  String? _lensBrand;
  String? _lensModel;

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    final uid = authProvider.firebaseUser?.uid;
    if (uid == null) return;

    try {
      await userProvider.updatePrescription(
        uid: uid,
        diopterLeft: _leftDiopter!,
        diopterRight: _rightDiopter!,
        lensBrand: _lensBrand!,
        lensModel: _lensModel!,
      );

      if (mounted) {
        Navigator.of(context).pushNamed('/onboarding/reminders');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save prescription'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Prescription'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Indicator
                LinearProgressIndicator(
                  value: 0.33,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 32),
                
                const Text(
                  'Step 1 of 3',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Set up your prescription',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Left Eye
                DropdownButtonFormField<String>(
                  value: _leftDiopter,
                  decoration: const InputDecoration(
                    labelText: 'Left Eye (OS)',
                    prefixIcon: Icon(Icons.remove_red_eye),
                  ),
                  items: AppConfig.commonDioters.map((diopter) {
                    return DropdownMenuItem(
                      value: diopter,
                      child: Text(diopter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _leftDiopter = value;
                    });
                  },
                  validator: (value) => Validators.dropdown(value, fieldName: 'left eye diopter'),
                ),
                const SizedBox(height: 16),
                
                // Right Eye
                DropdownButtonFormField<String>(
                  value: _rightDiopter,
                  decoration: const InputDecoration(
                    labelText: 'Right Eye (OD)',
                    prefixIcon: Icon(Icons.remove_red_eye),
                  ),
                  items: AppConfig.commonDioters.map((diopter) {
                    return DropdownMenuItem(
                      value: diopter,
                      child: Text(diopter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _rightDiopter = value;
                    });
                  },
                  validator: (value) => Validators.dropdown(value, fieldName: 'right eye diopter'),
                ),
                const SizedBox(height: 16),
                
                // Lens Brand
                DropdownButtonFormField<String>(
                  value: _lensBrand,
                  decoration: const InputDecoration(
                    labelText: 'Lens Brand',
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  items: AppConfig.commonLensBrands.map((brand) {
                    return DropdownMenuItem(
                      value: brand,
                      child: Text(brand),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _lensBrand = value;
                    });
                  },
                  validator: (value) => Validators.dropdown(value, fieldName: 'lens brand'),
                ),
                const SizedBox(height: 16),
                
                // Lens Model
                DropdownButtonFormField<String>(
                  value: _lensModel,
                  decoration: const InputDecoration(
                    labelText: 'Lens Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: AppConfig.commonLensModels.map((model) {
                    return DropdownMenuItem(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _lensModel = value;
                    });
                  },
                  validator: (value) => Validators.dropdown(value, fieldName: 'lens type'),
                ),
                const SizedBox(height: 40),
                
                CustomButton(
                  text: 'Continue',
                  onPressed: _continue,
                  isLoading: userProvider.isLoading,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
