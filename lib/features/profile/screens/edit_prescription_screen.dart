import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/app_config.dart';
import '../../../utils/validators.dart';

class EditPrescriptionScreen extends StatefulWidget {
  const EditPrescriptionScreen({super.key});

  @override
  State<EditPrescriptionScreen> createState() => _EditPrescriptionScreenState();
}

class _EditPrescriptionScreenState extends State<EditPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _leftDiopter;
  String? _rightDiopter;
  String? _lensBrand;
  String? _lensModel;

  @override
  void initState() {
    super.initState();
    // Pre-fill with current values
    final userProvider = context.read<UserProvider>();
    _leftDiopter = userProvider.currentUser?.diopterLeft;
    _rightDiopter = userProvider.currentUser?.diopterRight;
    _lensBrand = userProvider.currentUser?.preferredLensBrand;
    _lensModel = userProvider.currentUser?.preferredLensModel;
  }

  Future<void> _save() async {
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
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescription updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update prescription'),
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
        title: const Text('Edit Prescription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Eye
              DropdownButtonFormField<String>(
                initialValue: _leftDiopter,
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
                validator: (value) =>
                    Validators.dropdown(value, fieldName: 'left eye diopter'),
              ),
              const SizedBox(height: 16),

              // Right Eye
              DropdownButtonFormField<String>(
                initialValue: _rightDiopter,
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
                validator: (value) =>
                    Validators.dropdown(value, fieldName: 'right eye diopter'),
              ),
              const SizedBox(height: 16),

              // Lens Brand
              DropdownButtonFormField<String>(
                initialValue: _lensBrand,
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
                validator: (value) =>
                    Validators.dropdown(value, fieldName: 'lens brand'),
              ),
              const SizedBox(height: 16),

              // Lens Model
              DropdownButtonFormField<String>(
                initialValue: _lensModel,
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
                validator: (value) =>
                    Validators.dropdown(value, fieldName: 'lens type'),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: 'Save Changes',
                onPressed: _save,
                isLoading: userProvider.isLoading,
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
