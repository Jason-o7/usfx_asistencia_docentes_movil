import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_state.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_text_styles.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_shadows.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          SizedBox.expand(
            child: Image.asset('assets/images/bg_login.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo_usfx.png',
                        width: 100,
                        height: 180,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'USFX',
                            style: AppTextStyles.title(
                              color: AppPalette.lightTextColor,
                            ).copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Control Docente',
                            style: AppTextStyles.subtitle(
                              color: AppPalette.lightTextColor,
                            ).copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.lightBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: AppShadows.generalShadow,
                  ),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is Authenticated) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    builder: (context, state) {
                      return _LoginForm(state: state);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final AuthState state;

  const _LoginForm({required this.state});

  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bienvenido/a', style: AppTextStyles.title()),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Introduzca su email',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su email';
              }
              if (!value.contains('@')) {
                return 'Email inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Introduzca su contraseña',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              Text('Recordarme', style: AppTextStyles.body()),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implementar la lógica de recuperación de contraseña
                },
                child: Text(
                  'Ha olvidado su contraseña?',
                  style: AppTextStyles.caption(color: AppPalette.linkColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child:
                widget.state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: AppTextStyles.bodyBold(
                          color: AppPalette.lightTextColor,
                        ),
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        'Iniciar Sesión',
                        style: AppTextStyles.bodyBold(
                          color: AppPalette.lightTextColor,
                        ),
                      ),
                    ),
          ),
          if (widget.state is AuthError)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                (widget.state as AuthError).message,
                style: AppTextStyles.body(color: AppPalette.errorColor),
              ),
            ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
