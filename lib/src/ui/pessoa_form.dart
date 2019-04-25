import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/pessoa_form_bloc.dart';
import 'dart:io';

class TelaPessoa extends StatefulWidget {
  PessoaModel _pessoa;
  String _title;
  Function(PessoaModel) _onSubmit;

  TelaPessoa(
      {Function(PessoaModel) onSubmit,
      String title = 'Novo Cadastro',
      PessoaModel editarPessoa}) {
    this._pessoa = editarPessoa;
    this._title = title;
    this._onSubmit = onSubmit;
  }

  @override
  TelaPessoaState createState() {
    return TelaPessoaState(_pessoa, _title);
  }
}

class TelaPessoaState extends State<TelaPessoa> {
  final GlobalKey<PessoaFormState> _keyPessoaForm = GlobalKey<PessoaFormState>();
  PessoaModel _pessoa;
  String _title;
  PessoaForm _pessoaForm;
  PessoaFormBloc bloc = new PessoaFormBloc();

  TelaPessoaState(this._pessoa, this._title);

  void finish() {
    if(_keyPessoaForm.currentState._formKey.currentState.validate()) {
      _keyPessoaForm.currentState._formKey.currentState.save();
      widget._onSubmit(_keyPessoaForm.currentState._pessoa);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _pessoaForm = PessoaForm(_pessoa, finish, _keyPessoaForm);

    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: <Widget>[
            new MaterialButton(
              onPressed: () => finish(),
              child: Icon(Icons.save),
            )
          ],
        ),
        body: StreamBuilder(
          stream: bloc.photo,
          builder: (context, AsyncSnapshot<File> snapshot, ) {
            return new SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      var picture = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 600, maxWidth: 600);
                      bloc.savePhoto(picture);
                      print(picture.path);
                    },
                    child: () {
                      if (snapshot.hasData) {
                        return new Image.file(snapshot.data, height: 250.0, width: 250.0,);
                      } else {
                        return new Image.asset('assets/contato.png', height: 250.0, width: 250.0,);
                      }
                    }(),
                  ),
                  _pessoaForm
                ],
              ),
            );
          },
        )
    );
  }
}

class PessoaForm extends StatefulWidget {
  PessoaModel _pessoa;
  Function _onSubmit;

  @override
  PessoaFormState createState() => PessoaFormState(_pessoa, _onSubmit);

  PessoaForm(this._pessoa, this._onSubmit, GlobalKey<PessoaFormState> formStateKey): super(key : formStateKey);
}

class PessoaFormState extends State<PessoaForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  PessoaModel _pessoa;
  Function _onSubmit;
  bool _edicao = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  PessoaFormState(PessoaModel pessoa, this._onSubmit) {
    this._pessoa = pessoa == null ? new PessoaModel.vazio() : pessoa;
    this._edicao = pessoa != null;
  }

  void _fieldFocusChange(context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
              textCapitalization: TextCapitalization.words,
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
                _onSubmit();
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
