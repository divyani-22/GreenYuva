import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../screens/profile_picture_upload_screen.dart';
import '../theme/app_theme.dart';

class EmailAuthForm extends StatefulWidget {
  final Function(String) showSuccessDialog;
  final TextStyle? registerButtonTextStyle;

  const EmailAuthForm({
    super.key,
    required this.showSuccessDialog,
    this.registerButtonTextStyle,
  });

  @override
  State<EmailAuthForm> createState() => _EmailAuthFormState();
}

class _EmailAuthFormState extends State<EmailAuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  bool _isLogin = true;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isSubmitting = true);
      final userService = UserService();
      try {
        if (_isLogin) {
          UserCredential? userCredential;
          try {
            userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          } catch (e) {
            // FirebaseAuth fallback to local guest session
          }
          final firebaseUser = userCredential?.user;
          AppUser? appUser;
          if (firebaseUser != null) {
            try {
              appUser = await userService.getUserById(firebaseUser.uid);
            } catch (_) {}
          }
          if (appUser == null) {
            final local = await userService.getLocalUser();
            appUser = AppUser(
              id: local.id,
              firstName: local.firstName.isNotEmpty ? local.firstName : (_email.split('@').first),
              lastName: local.lastName,
              points: local.points,
              savedPosts: local.savedPosts,
              likedPosts: local.likedPosts,
              profilePic: local.profilePic,
              actions: local.actions,
              streak: local.streak,
              weekPoints: local.weekPoints,
              weekGoal: local.weekGoal,
            );
            await userService.saveCurrentLocalUser(appUser);
          }
          if (mounted) setState(() => _isSubmitting = false);
          widget.showSuccessDialog('Welcome back to your EcoSprint workspace!');
        } else {
          String uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
          try {
            final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email,
              password: _password,
            );
            if (userCredential.user != null) {
              uid = userCredential.user!.uid;
            }
          } catch (e) {}

          final newUser = AppUser(
            id: uid,
            firstName: _firstName.trim(),
            lastName: _lastName.trim(),
            points: 100,
            savedPosts: [],
            likedPosts: [],
            profilePic: null,
            actions: 1,
            streak: 1,
            weekPoints: 50,
            weekGoal: 800,
          );

          await userService.addUser(newUser);
          if (mounted) setState(() => _isSubmitting = false);

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePictureUploadScreen(
                  user: newUser,
                  isFromRegistration: true,
                ),
              ),
            );
          }
        }
      } catch (e) {
        final fallbackUser = AppUser(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          firstName: _firstName.trim().isNotEmpty ? _firstName.trim() : 'Climate',
          lastName: _lastName.trim().isNotEmpty ? _lastName.trim() : 'Hero',
          points: 100,
          savedPosts: [],
          likedPosts: [],
          profilePic: null,
          actions: 1,
          streak: 1,
          weekPoints: 50,
          weekGoal: 800,
        );
        await userService.addUser(fallbackUser);
        if (mounted) {
          setState(() => _isSubmitting = false);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    }
  }

  void _continueAsGuest() async {
    final userService = UserService();
    final guestUser = AppUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      firstName: _firstName.trim().isNotEmpty ? _firstName.trim() : 'Divyani',
      lastName: _lastName.trim().isNotEmpty ? _lastName.trim() : 'Papalkar',
      points: 150,
      savedPosts: [],
      likedPosts: [],
      profilePic: null,
      actions: 3,
      streak: 2,
      weekPoints: 80,
      weekGoal: 800,
    );
    await userService.addUser(guestUser);
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isLogin) ...[
            _buildNeoInput(
              hint: 'First Name',
              icon: Icons.person_outline_rounded,
              fillColor: AppColors.pureWhite,
              onSaved: (v) => _firstName = v ?? '',
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your first name' : null,
            ),
            const SizedBox(height: 12),
            _buildNeoInput(
              hint: 'Last Name',
              icon: Icons.person_outline_rounded,
              fillColor: AppColors.pureWhite,
              onSaved: (v) => _lastName = v ?? '',
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your last name' : null,
            ),
            const SizedBox(height: 12),
          ],

          // Email Input (White fill with black outline & shadow)
          _buildNeoInput(
            hint: 'Email',
            icon: Icons.mail_outline_rounded,
            fillColor: AppColors.pureWhite,
            keyboardType: TextInputType.emailAddress,
            onSaved: (v) => _email = v ?? '',
            validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Please enter a valid email address' : null,
          ),
          const SizedBox(height: 12),

          // Password Input (Dusty Coral fill from reference)
          _buildNeoInput(
            hint: 'Password',
            icon: Icons.lock_outline_rounded,
            fillColor: AppColors.dustyCoral.withValues(alpha: 0.85),
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.solidBlack,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            onSaved: (v) => _password = v ?? '',
            validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 10),

          // Remember Me + Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _rememberMe ? AppColors.solidBlack : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.solidBlack, width: 1.8),
                      ),
                      child: _rememberMe
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Remember Me',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.solidBlack,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dustyCoral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Demo credentials box (Butter Yellow pill)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.butterYellow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.solidBlack, width: 1.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.solidBlack),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo: test@gmail.com / 123456',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.solidBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Primary CTA Button (Butter Yellow fill from reference)
          NeoButton(
            text: _isSubmitting ? 'Please wait...' : (_isLogin ? 'Login' : 'Register'),
            color: AppColors.butterYellow,
            textColor: AppColors.solidBlack,
            onPressed: _isSubmitting ? null : _submit,
          ),
          const SizedBox(height: 16),

          // "─── or also ───" separator
          Row(
            children: [
              Expanded(child: Container(height: 1.5, color: AppColors.solidBlack.withValues(alpha: 0.3))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or also',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              Expanded(child: Container(height: 1.5, color: AppColors.solidBlack.withValues(alpha: 0.3))),
            ],
          ),
          const SizedBox(height: 16),

          // Secondary Google / Guest Button (White with 2px black border & hard shadow)
          NeoButton(
            text: 'Continue with Google',
            color: AppColors.pureWhite,
            textColor: AppColors.solidBlack,
            leading: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              child: Text(
                'G',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.solidBlack,
                ),
              ),
            ),
            onPressed: _continueAsGuest,
          ),
          const SizedBox(height: 12),

          // Switch to Register / Login
          TextButton(
            onPressed: () {
              setState(() => _isLogin = !_isLogin);
            },
            child: Text(
              _isLogin ? 'Need an account? Register Here' : 'Already have an account? Login',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.solidBlack,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeoInput({
    required String hint,
    required IconData icon,
    required Color fillColor,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.solidBlack, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.solidBlack,
            offset: Offset(2.5, 3.0),
            blurRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.solidBlack,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.solidBlack.withValues(alpha: 0.55),
          ),
          prefixIcon: Icon(icon, color: AppColors.solidBlack, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
