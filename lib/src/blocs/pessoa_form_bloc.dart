import '../models/pessoa_model.dart';
import 'package:rxdart/rxdart.dart';

class PessoaFormBloc {
  PessoaModel pessoa;
  var _fotoFetcher = BehaviorSubject<String>();
  Observable<String> get foto => _fotoFetcher.stream;

  setFoto(String foto) {
    pessoa.fotoPath = foto;
    _fotoFetcher.sink.add(foto);
  }

  PessoaFormBloc(PessoaModel pessoa) {
    reset(pessoa);
  }

  reset(PessoaModel pessoa) {
    _fotoFetcher = BehaviorSubject<String>();
    if (pessoa == null) {
      this.pessoa = PessoaModel.vazio();
    } else {
      this.pessoa = PessoaModel.fromJson(pessoa.toJson());
      if (pessoa.fotoPath != null && pessoa.fotoPath != 'null') {
        setFoto(pessoa.fotoPath);
      }
    }
  }

  dispose() {
    _fotoFetcher.close();
  }
}

final bloc = PessoaFormBloc(null);