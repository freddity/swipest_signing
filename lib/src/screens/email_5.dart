import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../controller.dart';
import '../util/text_field.dart';

class Email5Step extends StatefulWidget {

  final Controller controller;

  const Email5Step(this.controller, {Key? key}) : super(key: key);

  @override
  State<Email5Step> createState() => _Email5StepState();
}

class _Email5StepState extends State<Email5Step> {

  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();

  final _emailController = TextEditingController();

  @override
  void initState() {
    _emailController.text = widget.controller.dataCollector.getEmail();

    super.initState();
  }

  late final _emailTextField = SwipestTextFormField(
    widgetKey: _emailKey,
    controller: _emailController,
    text: 'EMAIL',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Pole nie może być puste';
      }

      if (!EmailValidator.validate(value)) {
        return 'Niepoprawny format';
      }

      return null;
    },
    onEditingComplete: () => _emailKey.currentState!.validate(),
    obscure: false,
  );

  late final _continueButton = SizedBox(
    width: 150,
    child: TextButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.controller.dataCollector.setEmail(_emailKey.currentState!.value);
          widget.controller.show(SigningPhase.sixth);
        }
      },
      child: const Text(
        'Kontynuuj',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xffff3379),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ),
  );

  late final _form = Form(
    key: _formKey,
    child: Stack(
      children: [
        const Positioned(
          top: 135,
          right: 0,
          bottom: 0,
          left: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Jaki masz adres email?',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
          ),
        ),
        Positioned(
          top: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _emailTextField,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          left: 0,
          child: Column(
            children: [
              _continueButton,
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.controller.show(SigningPhase.fourth);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(70),
            child: SizedBox(
              width: double.infinity,
              height: _calculateMainHeight(),
              child: Center(child: _form),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMainHeight() {
    double bottomInset;
    bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (bottomInset != 0) {

      double screenHeight;
      screenHeight = MediaQuery.of(context).size.height;

      double verticalInsets;
      verticalInsets = MediaQuery.of(context).viewInsets.vertical;

      double paddingCorrection;
      paddingCorrection = 25;

      return screenHeight - verticalInsets - paddingCorrection;
    } else {
      return double.infinity;
    }
  }
}
