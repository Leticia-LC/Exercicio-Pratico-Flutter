import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TipoSanguineo {
  aPositivo,
  aNegativo,
  bPositivo,
  bNegativo,
  oPositivo,
  oNegativo,
  abPositivo,
  abNegativo,
}

extension TipoSanguineoExtension on TipoSanguineo {
  String get nome {
    switch (this) {
      case TipoSanguineo.aPositivo:
        return 'A+';
      case TipoSanguineo.aNegativo:
        return 'A-';
      case TipoSanguineo.bPositivo:
        return 'B+';
      case TipoSanguineo.bNegativo:
        return 'B-';
      case TipoSanguineo.oPositivo:
        return 'O+';
      case TipoSanguineo.oNegativo:
        return 'O-';
      case TipoSanguineo.abPositivo:
        return 'AB+';
      case TipoSanguineo.abNegativo:
        return 'AB-';
    }
  }

  Color get cor {
    switch (this) {
      case TipoSanguineo.aPositivo:
        return Colors.blue;
      case TipoSanguineo.aNegativo:
        return Colors.red;
      case TipoSanguineo.bPositivo:
        return Colors.purple;
      case TipoSanguineo.bNegativo:
        return Colors.orange;
      case TipoSanguineo.oPositivo:
        return Colors.green;
      case TipoSanguineo.oNegativo:
        return Colors.yellow;
      case TipoSanguineo.abPositivo:
        return Colors.cyan;
      case TipoSanguineo.abNegativo:
        return Colors.white;
    }
  }
}

class Pessoa {
  const Pessoa({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.github,
    required this.tipoSanguineo,
  });

  final String nome;
  final String email;
  final String telefone;
  final String github;
  final TipoSanguineo tipoSanguineo;
}

class EstadoListaDePessoas with ChangeNotifier {
  final List<Pessoa> _listaDePessoas = [];

  List<Pessoa> get pessoas => List.unmodifiable(_listaDePessoas);

  void incluir(Pessoa pessoa) {
    _listaDePessoas.add(pessoa);
    notifyListeners();
  }

  void excluir(Pessoa pessoa) {
    _listaDePessoas.remove(pessoa);
    notifyListeners();
  }

  void alterar(Pessoa pessoaExistente, Pessoa pessoaNova) {
    final index = _listaDePessoas.indexOf(pessoaExistente);
    if (index != -1) {
      _listaDePessoas[index] = pessoaNova;
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EstadoListaDePessoas(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => TelaInicial(),
        '/listagem': (context) => TelaListagem(),
        '/formulario': (context) => TelaFormulario(),
      },
    );
  }
}

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/listagem');
                },
                child: Text('Ver lista de pessoas', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/formulario');
                },
                child: Text('Incluir nova pessoa', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaListagem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de Pessoas'),
      ),
      body: Container(
        color: Colors.white,
        child: Consumer<EstadoListaDePessoas>(
          builder: (context, estadoLista, child) {
            return ListView.builder(
              itemCount: estadoLista.pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = estadoLista.pessoas[index];
                return ListTile(
                  title: Text(pessoa.nome, style: TextStyle(color: Colors.black)),
                  subtitle: Text(
                    '${pessoa.email}\n${pessoa.telefone}\n${pessoa.github}\n${pessoa.tipoSanguineo.nome}',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: pessoa.tipoSanguineo.cor,
                    child: Text(pessoa.tipoSanguineo.nome),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () {
                      estadoLista.excluir(pessoa);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  @override
  _TelaFormularioState createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _email;
  late String _telefone;
  late String _github;
  late TipoSanguineo _tipoSanguineo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Formulário'),
    ),
    body: Container(
    color: Colors.white,
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    TextFormField(
    decoration: InputDecoration(labelText: 'Nome', labelStyle: TextStyle(color: Colors.black)),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Nome é obrigatório';
    }
    return null;
    },
    onSaved: (value) {
    _nome = value!;
    },
    style: TextStyle(color: Colors.black),
    ),
    TextFormField(
    decoration: InputDecoration(labelText: 'E-mail', labelStyle: TextStyle(color: Colors.black)),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'E-mail é obrigatório';
    }
    return null;
    },
    onSaved: (value) {
    _email = value!;
    },
    style: TextStyle(color: Colors.black),
    ),
    TextFormField(
    decoration: InputDecoration(labelText: 'Telefone', labelStyle: TextStyle(color: Colors.black)),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Telefone é obrigatório';
    }
    return null;
    },
    onSaved: (value) {
    _telefone = value!;
    },
    style: TextStyle(color: Colors.black),
    ),
    TextFormField(
    decoration: InputDecoration(labelText: 'GitHub', labelStyle: TextStyle(color: Colors.black)),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'GitHub é obrigatório';
    }
    return null;
    },
    onSaved: (value) {
    _github = value!;
    },
    style: TextStyle(color: Colors.black),
    ),
    DropdownButtonFormField<TipoSanguineo>(
    decoration: InputDecoration(labelText: 'Tipo Sanguíneo', labelStyle: TextStyle(color: Colors.black)),
    items: TipoSanguineo.values.map((TipoSanguineo tipo) {
    return DropdownMenuItem<TipoSanguineo>(
    value: tipo,
    child: Text(tipo.nome),
    );
    }).toList(),
    validator: (value) {
    if (value == null) {
    return 'Tipo Sanguíneo é obrigatório';
    }
    return null;
    },
      onChanged: (value) {
        setState(() {
          _tipoSanguineo = value!;
        });
      },
      style: TextStyle(color: Colors.black),
    ),
      SizedBox(height: 20),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final novaPessoa = Pessoa(
              nome: _nome,
              email: _email,
              telefone: _telefone,
              github: _github,
              tipoSanguineo: _tipoSanguineo,
            );
            Provider.of<EstadoListaDePessoas>(context, listen: false).incluir(novaPessoa);
            Navigator.pop(context);
          }
        },
        child: Text('Salvar', style: TextStyle(color: Colors.white)),
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}
