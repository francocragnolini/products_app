import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../ui/input_decoration.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //! creando la instancia del LoginFormProvider
                    //! para manejar el estado del formulario
                    //! no lo inicializa en el main
                    ChangeNotifierProvider(
                      create: (context) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "login_screen"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                  overlayColor: MaterialStateProperty.all(
                    Colors.indigo.withOpacity(0.1),
                  ),
                ),
                child: const Text(
                  "¿Ya tienes una Cuenta?",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);
    final navigator = Navigator.of(context);

    // to manage the style of the form
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //todo: utilizar el global key para manejar el estado interno del formulario
        key: loginFormProvider.formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginFormProvider.isLoading
                  ? null
                  : () async {
                      //? esconder el teclado despues de hacer el submit
                      FocusScope.of(context).unfocus();

                      //? creando la instancia del provider
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      //? verifica que el formulario sea valido
                      if (!loginFormProvider.isValidForm()) return;

                      //? comienza el loading
                      loginFormProvider.isLoading = true;

                      Future.delayed(const Duration(milliseconds: 200));

                      //todo: validar si el register es correcto backend
                      final String? errorMessage = await authService.createUser(
                          loginFormProvider.email, loginFormProvider.password);
                      if (errorMessage == null) {
                        navigator.pushReplacementNamed("home_screen");
                      } else {
                        // todo: mostrar error en pantalla
                        log(errorMessage);
                        loginFormProvider.isLoading = false;
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginFormProvider.isLoading ? "Espere" : "Ingresar",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
