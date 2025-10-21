import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/language_provider.dart';
import '../../../shared/widgets/custom_button.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // Title
              const Text(
                'Choose Your Language',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Select your preferred language to continue using the app.',
                style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Language Options
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLanguageButton(
                        context,
                        'Eng',
                        'en',
                        languageProvider.currentLanguage == 'en',
                        () => languageProvider.changeLanguage('en'),
                      ),
                      const SizedBox(width: 24),
                      _buildLanguageButton(
                        context,
                        'اردو',
                        'ur',
                        languageProvider.currentLanguage == 'ur',
                        () => languageProvider.changeLanguage('ur'),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              // Continue Button
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  // Simple navigation for UI testing
                  Navigator.pushReplacementNamed(context, '/login');
                },
                width: double.infinity,
                backgroundColor: const Color(0xFF1A2B4C),
                textColor: Colors.white,
                height: 50,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String language,
    String code,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1A2B4C)
                : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            language,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF1A2B4C)
                  : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
