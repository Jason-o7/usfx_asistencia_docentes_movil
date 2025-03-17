import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
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
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          widget.state is AuthLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Iniciar Sesión'),
              ),
          if (widget.state is AuthError)
            Text(
              (widget.state as AuthError).message,
              style: const TextStyle(color: Colors.red),
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
