import '../models/pessoa_model.dart';

class PessoaFormBloc {
  PessoaModel pessoa;

  PessoaFormBloc(PessoaModel pessoa) {
    reset(pessoa);
  }

  reset(PessoaModel pessoa) {
    if (pessoa == null) {
      this.pessoa = PessoaModel.vazio();
    } else {
      this.pessoa = pessoa;
    }
  }
}

final bloc = PessoaFormBloc(null);