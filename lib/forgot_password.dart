import 'package:flutter/material.dart';
import 'package:mi_auth/validator.dart';

import 'fire_auth.dart';
import 'login_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _forgotFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar password'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Para poder redefinir a sua password escreva o seu endereço de e-mail e clique em Enviar!',
                style: TextStyle(color: Colors.blue),
              ),
              const SizedBox(height: 16.0),
              Form(
                key: _forgotFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) =>
                          Validator.validateEmail(email: value),
                      decoration: InputDecoration(
                        hintText: "e-mail",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_forgotFormKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });

                          await FireAuth.resetPassword(
                              email: _emailTextController.text);

                          setState(() {
                            _isProcessing = false;
                          });

                          if (FireAuth.userExists) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: const Text("Recuperar password"),
                                    content: const Text(
                                        "Foi enviado um e-mail com as instruções necessárias para recuperar a sua password! Verifique o seu e-mail."),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ));
                                          })
                                    ]);
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: const Text(
                                        "Erro ao recuperar password"),
                                    content: const Text(
                                        "Não existe nenhum utilizador registado com o e-mail indicado. Verifique o e-mail indicado."),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ]);
                              },
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (_isProcessing) const CircularProgressIndicator()
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
