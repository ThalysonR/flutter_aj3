class PessoaModel {
  String _matricula;
  String _nome;
  String _telefone;
  String _dtNascimento;
  String _lider;
  String _fotoPath;


  PessoaModel(this._matricula, this._nome, this._telefone, this._dtNascimento,
      this._lider, this._fotoPath);

  PessoaModel.vazio() {
    _matricula = '';
    _nome = '';
    _telefone = '';
    _dtNascimento = '';
    _lider = '';
    _fotoPath = null;
  }


  String get matricula => _matricula;

  set matricula(String value) {
    _matricula = value;
  }

  List<String> toList() {
    List<String> list = [_matricula, _nome, _telefone, _dtNascimento, _lider];
    return list;
  }

  static List<String> getLabels() {
    return ['Matrícula', 'Nome', 'Telefone', 'Data de Nascimento', 'Líder'];
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get dtNascimento => _dtNascimento;

  set dtNascimento(String value) {
    _dtNascimento = value;
  }

  String get lider => _lider;

  set lider(String value) {
    _lider = value;
  }

  String get fotoPath => _fotoPath;

  set fotoPath(String value) {
    _fotoPath = value;
  }

  @override
  String toString() {
    return 'PessoaModel{_matricula: $_matricula, _nome: $_nome, _telefone: $_telefone, _dtNascimento: $_dtNascimento, _lider: $_lider, _fotoPath: $_fotoPath}';
  }


}