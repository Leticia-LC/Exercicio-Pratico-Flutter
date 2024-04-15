import 'package:flutter/material.dart';
import 'dart:math';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

enum EstadoDoJogo {
  emAndamento,
  ganhou,
  perdeu,
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final random = Random();

  var vitorias = 0;
  var derrotas = 0;
  var botaoCorreto = 0;
  var clicks = 0;
  var estadoDoJogo = EstadoDoJogo.emAndamento;

  @override
  void initState() {
    super.initState();

    iniciarJogo();
  }

  void tentativa(int opcao) {
    setState(() {
      if (opcao == botaoCorreto) {
        estadoDoJogo = EstadoDoJogo.ganhou;
        vitorias++;
      } else {
        clicks++;
      }

      if (clicks >= 2 && estadoDoJogo != EstadoDoJogo.ganhou) {
        estadoDoJogo = EstadoDoJogo.perdeu;
        derrotas++;
      }
    });
  }

  void iniciarJogo() {
    setState(() {
      botaoCorreto = random.nextInt(3);

      clicks = 0;

      estadoDoJogo = EstadoDoJogo.emAndamento;
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (estadoDoJogo) {
      EstadoDoJogo.ganhou => GanhouJogo(iniciarJogo),
      EstadoDoJogo.perdeu => PerdeuJogo(iniciar
      EstadoDoJogo.emAndamento => JogoEmAndamento(vitorias, derrotas, tentativa),
    };
  }
}

class PerdeuJogo extends StatelessWidget {
  const PerdeuJogo(this.reiniciar);

  final void Function() reiniciar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(children: [
        const Text('Você perdeu'),
        ElevatedButton(
          child: const Text('Jogar novamente'),
          onPressed: () {
            reiniciar();
          },
        ),
      ]),
    );
  }
}

class GanhouJogo extends StatelessWidget {
  const GanhouJogo(this.reiniciar);

  final void Function() reiniciar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(children: [
        const Text('Você ganhou'),
        ElevatedButton(
          child: const Text('Jogar novamente'),
          onPressed: () {
            reiniciar();
          },
        ),
      ]),
    );
  }
}

class JogoEmAndamento extends StatelessWidget {
  const JogoEmAndamento(
      this.vitorias,
      this.derrotas,
      this.tentativa,
  );

  final int vitorias;
  final int derrotas;

  final void Function(int) tentativa;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Vitórias: $vitorias'),
        Text('Derrotas: $derrotas'),
        ElevatedButton(
          child: const Text('A'),
          onPressed: () {
            tentativa(0);
          },
        ),
        ElevatedButton(
          child: const Text('B'),
          onPressed: () {
            tentativa(1);
          },
        ),
        ElevatedButton(
          child: const Text('C'),
          onPressed: () {
            tentativa(2);
          },
        ),
      ],
    );
  }
}