import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';

class TelaPessoa extends StatelessWidget {
  PessoaModel _pessoa;
  String _title;
  Function(PessoaModel) _onSubmit;

  @override
  Widget build(BuildContext context) {
    var pessoaForm = PessoaForm(_pessoa, _onSubmit);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          new MaterialButton(
            onPressed: () => pessoaForm.state.finish(),
            child: Icon(Icons.save),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Container(
            child: pessoaForm,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }

  TelaPessoa(
      {Function(PessoaModel) onSubmit,
      String title = 'Novo Cadastro',
      PessoaModel editarPessoa}) {
    this._pessoa = editarPessoa;
    this._title = title;
    this._onSubmit = onSubmit;
  }
}

class PessoaForm extends StatefulWidget {
  PessoaModel _pessoa;
  Function(PessoaModel) _onSubmit;
  PessoaFormState state;
  ValueKey<FormState> key = ValueKey(FormState());

  @override
  PessoaFormState createState() {
    return state;
  }

  PessoaForm(this._pessoa, this._onSubmit) {
    state = PessoaFormState(_pessoa, _onSubmit, key);
  }
}

class PessoaFormState extends State<PessoaForm> {
  ValueKey<FormState> _formKey;
  PessoaModel _pessoa;
  Function(PessoaModel) _onSubmit;
  bool _edicao = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  PessoaFormState(PessoaModel pessoa, Function(PessoaModel) onSubmit, ValueKey<FormState> key) {
    this._pessoa = pessoa == null ? new PessoaModel.vazio() : pessoa;
    this._edicao = pessoa != null;
    this._onSubmit = onSubmit;
    this._formKey = key;
  }

  void _fieldFocusChange(context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void finish() {
    print(_formKey);
    if (_formKey.value.validate()) {
      _formKey.value.save();
      if (_onSubmit != null) _onSubmit(_pessoa);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: TextFormField(
              enabled: !_edicao,
              initialValue: _pessoa.nome,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              decoration: new InputDecoration(hintText: 'Nome'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Preencha o nome';
                }
              },
              onSaved: (String value) {
                _pessoa.nome = value;
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: TextFormField(
              initialValue: _pessoa.telefone,
              focusNode: _phoneFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term) {
                finish();
              },
              decoration: new InputDecoration(hintText: 'Telefone'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Preencha o telefone';
                }
              },
              onSaved: (String value) {
                _pessoa.telefone = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
