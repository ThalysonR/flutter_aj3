import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/pessoa_form_bloc.dart';
import '../models/pessoa_model.dart';

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
  String _title;
  PessoaForm _pessoaForm;

  TelaPessoaState(PessoaModel pessoa, this._title) {
    bloc.reset(pessoa);
  }

  Future<bool> _onWillPop() {
    var fotoAtual = bloc.pessoa.fotoPath;
    print("onWillPop");
    _limpaFoto(fotoAtual);
    return Future.value(true);
  }

  _limpaFoto(String path) {
    if (path != null && path != 'null' && !path.contains('cadastro')) {
      File(path).delete();
    }
  }

  void finish() {
    print("Save Form");
    if(_keyPessoaForm.currentState._formKey.currentState.validate()) {
      _keyPessoaForm.currentState._formKey.currentState.save();

      if (bloc.pessoa.fotoPath != null) {
          var picture = File(bloc.pessoa.fotoPath);
          var path = picture.path.substring(0, picture.path.lastIndexOf("/")).replaceAll('/cadastro', '');
          var dir = Directory("$path/cadastro");
          if (!dir.existsSync()) {
            dir.createSync();
          }
          var renamedPic = picture.renameSync("${dir.path}/${bloc.pessoa.nome.split(' ').join('_')}.jpg");
          bloc.setFoto(renamedPic.path);

//        });
      }
      widget._onSubmit(bloc.pessoa);
      print("Pop Context");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _pessoaForm = PessoaForm(finish, _keyPessoaForm);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(_title),
            actions: <Widget>[
              new MaterialButton(
                onPressed: () => finish(),
                child: Icon(Icons.save),
              )
            ],
          ),
          body: new SingleChildScrollView(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    var picture = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 600, maxWidth: 600);
                    _limpaFoto(bloc.pessoa.fotoPath);
                    bloc.setFoto(picture.path);
                  },
                  child: StreamBuilder(
                    stream: bloc.foto,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return new Image.file(File(snapshot.data), height: 250.0, width: 250.0,);
                      } else {
                        return new Image.asset('assets/contato.png', height: 250.0, width: 250.0,);
                      }
                    },
                  ),
                ),
                _pessoaForm
              ],
            ),
          )
      ),
    );
  }
}

class PessoaForm extends StatefulWidget {
  Function _onSubmit;

  @override
  PessoaFormState createState() => PessoaFormState(_onSubmit);

  PessoaForm(this._onSubmit, GlobalKey<PessoaFormState> formStateKey): super(key : formStateKey);
}

class PessoaFormState extends State<PessoaForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  Function _onSubmit;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _matriculaFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _liderFocus = FocusNode();

  PessoaFormState(this._onSubmit);

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
            leading: const Icon(Icons.account_circle),
            title: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: bloc.pessoa.matricula,
              focusNode: _matriculaFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _matriculaFocus, _nameFocus);
              },
              decoration: new InputDecoration(hintText: 'Matrícula do Senib'),
              onSaved: (String value) {
                bloc.pessoa.matricula = value;
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.person),
            title: TextFormField(
              textCapitalization: TextCapitalization.words,
              initialValue: bloc.pessoa.nome,
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
                bloc.pessoa.nome = value;
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              initialValue: bloc.pessoa.telefone,
              focusNode: _phoneFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _phoneFocus, _dateFocus);
              },
              decoration: new InputDecoration(hintText: 'Telefone'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Preencha o telefone';
                }
              },
              onSaved: (String value) {
                bloc.pessoa.telefone = value;
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.calendar_today),
            title: TextFormField(
              keyboardType: TextInputType.datetime,
              focusNode: _dateFocus,
              initialValue: bloc.pessoa.dtNascimento,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _dateFocus, _liderFocus);
              },
              decoration: new InputDecoration(hintText: 'Data de nascimento'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Preencha a data de nascimento';
                }
              },
              onSaved: (String value) {
                bloc.pessoa.dtNascimento = value;
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.group),
            title: TextFormField(
              textCapitalization: TextCapitalization.words,
              focusNode: _liderFocus,
              initialValue: bloc.pessoa.lider,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term) {
                _onSubmit();
              },
              decoration: new InputDecoration(hintText: 'Líder de GA'),
              onSaved: (String value) {
                bloc.pessoa.lider = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
