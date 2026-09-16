import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/email_auth_form.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: NeoCard(
            color: AppColors.paperCream,
            radius: 22,
            borderWidth: 2.0,
            shadowOffset: const Offset(4, 4),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.solidBlack, width: 2.0),
                  ),
                  child: const Icon(Icons.check_rounded, color: AppColors.solidBlack, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  "Welcome to EcoSprint!",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.solidBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.solidBlack.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 20),
                NeoButton(
                  text: "Enter Campus",
                  color: AppColors.butterYellow,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: PaperGridBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Plant & Gardener flat illustration matching reference
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const EcoPlantIllustration(),
                    ),
                    const SizedBox(height: 16),

                    // Title & Tagline matching reference
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Welcome to EcoSprint',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.solidBlack,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Quick challenges and real-world actions',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Authentication Form
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: EmailAuthForm(showSuccessDialog: _showSuccessDialog),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Flat vector illustration matching the plant & gardener in the reference image
class EcoPlantIllustration extends StatelessWidget {
  const EcoPlantIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.paperCream,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.solidBlack, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.solidBlack,
            offset: Offset(3.0, 3.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Terracotta Pot
          Positioned(
            bottom: 16,
            child: Container(
              width: 50,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.dustyCoral,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                border: Border.all(color: AppColors.solidBlack, width: 2.0),
              ),
            ),
          ),
          // Plant Stem & Leaves
          Positioned(
            bottom: 48,
            child: Container(
              width: 4,
              height: 35,
              color: AppColors.solidBlack,
            ),
          ),
          // Leaves (Sage green)
          Positioned(
            bottom: 58,
            left: 52,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 22,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.sageGreen,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.solidBlack, width: 1.5),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 66,
            right: 50,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 24,
                height: 13,
                decoration: BoxDecoration(
                  color: AppColors.sageGreen,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.solidBlack, width: 1.5),
                ),
              ),
            ),
          ),
          // Pink / Coral Blossoms matching reference
          Positioned(
            top: 18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBlossomDot(),
                const SizedBox(width: 4),
                _buildBlossomDot(size: 14, color: AppColors.dustyCoral),
                const SizedBox(width: 4),
                _buildBlossomDot(),
              ],
            ),
          ),
          Positioned(
            top: 32,
            left: 42,
            child: _buildBlossomDot(size: 9, color: AppColors.butterYellow),
          ),
          Positioned(
            top: 36,
            right: 44,
            child: _buildBlossomDot(size: 10, color: AppColors.dustyCoral),
          ),
        ],
      ),
    );
  }

  Widget _buildBlossomDot({double size = 11, Color color = AppColors.dustyCoral}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.solidBlack, width: 1.5),
      ),
    );
  }
}
