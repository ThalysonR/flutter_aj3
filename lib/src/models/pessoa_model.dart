class PessoaModel {
  String _nome;
  String _telefone;

  PessoaModel(this._nome, this._telefone);

  PessoaModel.vazio() {
    _nome = '';
    _telefone = '';
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


}