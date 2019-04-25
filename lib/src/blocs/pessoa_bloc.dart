import '../models/pessoa_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

class PessoaBloc {
  final _pessoas = [
    new PessoaModel('', 'Thalyson', '9999-9999', '', '', null),
    new PessoaModel('', 'Outro', '8888-8888', '', '', null)
  ];
  final _pessoasFetcher = BehaviorSubject<List<PessoaModel>>();

  Observable<List<PessoaModel>> get allPessoas => _pessoasFetcher.stream;

  fetchAllPessoas() {
    _pessoasFetcher.sink.add(_pessoas);
  }

  addPessoa(PessoaModel pessoa) {
    _pessoas.add(pessoa);
    fetchAllPessoas();
  }

  removeAllPessoas() {
    removePics(() {
      _pessoas.removeRange(0, this._pessoas.length);
      fetchAllPessoas();
    });
  }

  removePics(Function func) {
    return Observable<PessoaModel>.fromIterable(_pessoas).firstWhere((pessoa) {
      return pessoa.fotoPath != null;
    }, orElse: () => PessoaModel.vazio()).then((pessoa) {
      if (pessoa.fotoPath != null) {
        var path =
            pessoa.fotoPath.substring(0, pessoa.fotoPath.lastIndexOf("/"));
        Directory(path).delete(recursive: true);
      }
      func();
    });
  }

  dispose() {
    _pessoasFetcher.close();
  }
}

final bloc = PessoaBloc();
