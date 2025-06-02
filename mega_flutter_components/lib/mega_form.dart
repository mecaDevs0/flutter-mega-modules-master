import 'package:flutter/material.dart';

class MegaForm extends StatefulWidget {
  final Widget child;
  final AutovalidateMode autoValidate;

  const MegaForm({
    required GlobalKey<MegaFormState> key,
    required this.child,
    this.autoValidate = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  MegaFormState createState() => MegaFormState();
}

class MegaFormState extends State<MegaForm> {
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidate;

  @override
  void initState() {
    super.initState();
    _autoValidate = widget.autoValidate;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate,
      child: widget.child,
    );
  }

  bool validate() {
    final validated = _formKey.currentState!.validate();
    if (!validated) {
      setState(() {
        _autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
    return validated;
  }

  void save() => _formKey.currentState!.save();
}
