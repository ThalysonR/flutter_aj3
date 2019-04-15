//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:convert';
import '../blocs/pessoa_bloc.dart';
import '../models/pessoa_model.dart';
import 'pessoa_form.dart';

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
//                Directory tempdir = await getTemporaryDirectory();
//                print(tempdir.path);

                var first = await bloc.allPessoas.first;
                var list = List<List<dynamic>>();
                list.add(["Nome", "Telefone"]);
                first.forEach((item) {
                  list.add(item.toList());
                });
                String csv = const ListToCsvConverter().convert(list);
                var encodedList = Utf8Encoder().convert(csv);
                await Share.file('Lista CSV', 'lista.csv', encodedList, 'text/csv');
              },
              child: Icon(Icons.share),
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
                onSubmit: (pessoa) => print("Editar: ${pessoa.nome}"),
              );
            })),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                  child: Text(
                    snapshot.data[position].nome,
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                  child: Text(
                    snapshot.data[position].telefone,
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            ),
          )
        );
      },
      itemCount: snapshot.data.length,
    );
  }
}
