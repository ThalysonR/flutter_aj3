import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:convert';
import '../blocs/pessoa_bloc.dart';
import '../models/pessoa_model.dart';
import 'pessoa_form.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class Inicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllPessoas();
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastro AJ3'),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                Directory tempdir = await getTemporaryDirectory();
                print(tempdir.path);

                var first = await bloc.allPessoas.first;
                var list = List<List<dynamic>>();
                list.add(PessoaModel.getLabels());
                first.forEach((item) {
                  list.add(item.toList());
                });
                String csv = const ListToCsvConverter().convert(list);
                var encodedList = Utf8Encoder().convert(csv);

                var pessoaFoto = await first.firstWhere((item) => item.fotoPath != null, orElse: () => PessoaModel.vazio());
                if (pessoaFoto.fotoPath != null) {
                  var path = pessoaFoto.fotoPath.substring(0, pessoaFoto.fotoPath.lastIndexOf("/"));
                  new ZipFileEncoder().zipDirectory(new Directory(path), filename: "${tempdir.path}/fotos.zip");

                  await Share.files('Cadastros', {
                    'lista.csv': encodedList,
                    'fotos.zip': File("${tempdir.path}/fotos.zip").readAsBytesSync()
                  }, '*/*');
                } else {
                  await Share.file('Lista CSV', 'lista.csv', encodedList, 'text/csv');
                }
              },
              child: Icon(Icons.share),
            ),
            MaterialButton(
              onPressed: bloc.removeAllPessoas,
              child: Icon(OpenIconicIcons.trash),
            )
          ],
        ),
        body: StreamBuilder(
          stream: bloc.allPessoas,
          builder: (context, AsyncSnapshot<List<PessoaModel>> snapshot) {
            print(snapshot.hasData);
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TelaPessoa(
              onSubmit: (pessoa) => bloc.addPessoa(pessoa),
            );
          })),
          child: new Icon(Icons.add),
        )
    );
  }

  Widget buildList(AsyncSnapshot<List<PessoaModel>> snapshot) {
    return ListView.builder(
      itemBuilder: (context, position) {
        return Card(
          child: new InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TelaPessoa(
                title: 'Editar',
                editarPessoa: snapshot.data[position],
                onSubmit: (pessoa) => print("Editar: ${pessoa.nome.split(' ')[0]}"),
              );
            })),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: () {
                  if (snapshot.data[position].fotoPath == null) {
                    return AssetImage('assets/contato.png');
                  } else {
                    return FileImage(File(snapshot.data[position].fotoPath));
                  }
                }(),
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                child: Text(
                  snapshot.data[position].nome,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                child: Text(
                  snapshot.data[position].telefone,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          )
        );
      },
      itemCount: snapshot.data.length,
    );
  }
}
