import '../models/pessoa_model.dart';
import 'package:rxdart/rxdart.dart';

class PessoaBloc {
  final _pessoas = [new PessoaModel('Thalyson', '9999-9999'), new PessoaModel('Outro', '8888-8888')];
  final _pessoasFetcher = BehaviorSubject<List<PessoaModel>>();

  Observable<List<PessoaModel>> get allPessoas => _pessoasFetcher.stream;

  fetchAllPessoas() {
    print(_pessoas.length);
    _pessoasFetcher.sink.add(_pessoas);
  }

  addPessoa(PessoaModel pessoa) {
    _pessoas.add(pessoa);
    fetchAllPessoas();
  }

  dispose() {
    _pessoasFetcher.close();
  }
}

final bloc = PessoaBloc();