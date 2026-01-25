import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firebase_service.dart';
import '../../../utils/app_config.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLeftDiopter;
  String? _selectedRightDiopter;
  String? _selectedBrand;
  String? _selectedModel;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lens Profile Setup'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.visibility,
                size: 100,
                color: Color(0xFF2196F3),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tell us about your lenses',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This information helps us provide accurate reminders and price alerts',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'Left Eye Diopter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedLeftDiopter,
                decoration: const InputDecoration(
                  hintText: 'Select your left eye diopter',
                  prefixIcon: Icon(Icons.visibility),
                ),
                items: AppConfig.commonDioters.map((diopter) {
                  return DropdownMenuItem(
                    value: diopter,
                    child: Text(diopter),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLeftDiopter = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your left eye diopter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Right Eye Diopter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedRightDiopter,
                decoration: const InputDecoration(
                  hintText: 'Select your right eye diopter',
                  prefixIcon: Icon(Icons.visibility),
                ),
                items: AppConfig.commonDioters.map((diopter) {
                  return DropdownMenuItem(
                    value: diopter,
                    child: Text(diopter),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRightDiopter = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your right eye diopter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Preferred Lens Brand',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedBrand,
                decoration: const InputDecoration(
                  hintText: 'Select your preferred brand',
                  prefixIcon: Icon(Icons.branding_watermark),
                ),
                items: AppConfig.commonLensBrands.map((brand) {
                  return DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _selectedModel = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your preferred brand';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Lens Model (Replacement Schedule)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedModel,
                decoration: const InputDecoration(
                  hintText: 'Select your lens model',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                items: AppConfig.commonLensModels.map((model) {
                  return DropdownMenuItem(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedModel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your lens model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _completeOnboarding,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Complete Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseService = FirebaseService();
      final user = FirebaseAuth.instance.currentUser!;

      await firebaseService.updateUserDocument(user.uid, {
        'diopter_left': _selectedLeftDiopter,
        'diopter_right': _selectedRightDiopter,
        'preferred_lens_brand': _selectedBrand,
        'preferred_lens_model': _selectedModel,
      });

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
