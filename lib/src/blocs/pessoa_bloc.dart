import '../models/pessoa_model.dart';
import 'package:rxdart/rxdart.dart';
import '../database/pessoa_model_repository.dart';
import 'dart:io';

class PessoaBloc {
  final _pessoasFetcher = BehaviorSubject<List<PessoaModel>>();

  Observable<List<PessoaModel>> get allPessoas => _pessoasFetcher.stream;

  fetchAllPessoas() async {
    _pessoasFetcher.sink.add(await getAllPessoas());
  }

  addPessoa(PessoaModel pessoa) async {
//    _pessoas.add(pessoa);
    print("Add Pessoa Bloc");
    await newPessoa(pessoa);
    fetchAllPessoas();
  }

  update(PessoaModel pessoa) async {
    await updatePessoa(pessoa);
    fetchAllPessoas();
  }

  delete(PessoaModel pessoa) async {
    await deletePessoa(pessoa);
    if (pessoa.fotoPath != null && pessoa.fotoPath != 'null')
      File(pessoa.fotoPath).delete();
    fetchAllPessoas();
  }

  removeAllPessoas() async {
    await removePics();
    deleteAllPessoas();
    fetchAllPessoas();
  }

  removePics() async {
    var pessoas = await allPessoas.first;
    var pessoa = pessoas.firstWhere((p) => (p.fotoPath != null && p.fotoPath != 'null'), orElse: () => null);
    if (pessoa != null) {
      var path =
      pessoa.fotoPath.substring(0, pessoa.fotoPath.lastIndexOf("/"));
      Directory(path).delete(recursive: true);
    }
  }

  dispose() {
    _pessoasFetcher.close();
  }
}

final bloc = PessoaBloc();
