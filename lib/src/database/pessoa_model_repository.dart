import 'dbprovider.dart';
import '../models/pessoa_model.dart';

newPessoa(PessoaModel pessoa) async {
  final db = await DBProvider.db.database;
  var res = await db.rawInsert("INSERT INTO Cadastro "
      "(matricula, nome, telefone, data_nascimento, lider, foto_path) VALUES "
      "('${pessoa.matricula}', '${pessoa.nome}', '${pessoa.telefone}', '${pessoa.dtNascimento}', '${pessoa.lider}', '${pessoa.fotoPath}')");
  print("NewPessoa: $res");
  return res;
}

getAllPessoas() async {
  final db = await DBProvider.db.database;
  var res = await db.query("Cadastro");
  print("GetAllPessoas: $res");
  var retorno = res.map((c) => PessoaModel.fromJson(c)).toList();
  return retorno;
}

deleteAllPessoas() async {
  final db = await DBProvider.db.database;
  db.rawDelete("DELETE FROM Cadastro");
}

deletePessoa(PessoaModel pessoa) async {
  final db = await DBProvider.db.database;
  db.rawDelete("DELETE FROM Cadastro WHERE id = ${pessoa.id}");
}

updatePessoa(PessoaModel pessoa) async {
  final db = await DBProvider.db.database;
  print("Update foto path: ${pessoa.fotoPath}");
  var res = await db.rawUpdate("UPDATE Cadastro SET "
      "matricula = '${pessoa.matricula}', nome = '${pessoa.nome}', telefone = '${pessoa.telefone}',"
      "data_nascimento = '${pessoa.dtNascimento}', lider = '${pessoa.lider}', foto_path = '${pessoa.fotoPath}' "
      "WHERE id = ${pessoa.id}");
  return res;
}