import 'dart:developer';

import 'package:flutter/cupertino.dart';

class LoginFormProvider extends ChangeNotifier {
  //? global key es una referencia a un widget especifico
  //? a u vez el global key necesita un state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //? inputs a validar
  String email = "";
  String password = "";

  //
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    log("${formKey.currentState?.validate()}");
    log('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }
}
