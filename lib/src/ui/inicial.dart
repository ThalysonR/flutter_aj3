import 'package:flutter/material.dart';
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
        ),
        body: StreamBuilder(
          stream: bloc.allPessoas,
          builder: (context, AsyncSnapshot<List<PessoaModel>> snapshot) {
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
              onSubmit: (pessoa) => print("Cadastro: ${pessoa.nome}"),
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
