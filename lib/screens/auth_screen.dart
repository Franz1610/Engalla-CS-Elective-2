import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSigningIn = false;
  String? _errorMessage;

  Future<void> _signInWithGitHub() async {
    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: kIsWeb ? Uri.base.origin : null,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSigningIn = false;
        _errorMessage = 'Unable to sign in with GitHub.\n$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.storefront, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Shop',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to browse and manage products.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    FilledButton.icon(
                      onPressed: _isSigningIn ? null : _signInWithGitHub,
                      icon: _isSigningIn
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.code),
                      label: Text(
                        _isSigningIn
                            ? 'Opening GitHub...'
                            : 'Continue with GitHub',
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
