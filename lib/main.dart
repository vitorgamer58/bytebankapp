import 'package:flutter/material.dart';

int counter = 0;

void main() {
  runApp(BytebankApp()); // RunApp
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criando Transferência'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Editor(
                  controlador: _controladorCampoNumeroConta,
                  dica: '0000',
                  rotulo: 'Número da conta'),
              Editor(
                controlador: _controladorCampoValor,
                dica: '0.00',
                rotulo: 'Valor',
                icone: Icons.monetization_on,
              ),
              ElevatedButton(
                  onPressed: () => _criaTransferencia(context),
                  child: Text('Confirmar'))
            ],
          ),
        ));
  }

  void _criaTransferencia(BuildContext context) {
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(_controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$transferenciaCriada'),
        ),
      );
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null, // Operador ternátio
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

test() {
  counter = counter + 1;
}

class ListaTransferencias extends StatefulWidget {

  @override
  _ListaTransferenciasState createState() => _ListaTransferenciasState();
  // final List<Transferencia> _transferencias = [];

  //@override
  // State<StatefulWidget> createState() {
  //   return ListaTransferenciasState();
  // }

}

class _ListaTransferenciasState extends State<ListaTransferencias> {

  @override
  Widget build(BuildContext context) {
    final List<Transferencia> _transferencias = [];

    // widget._transferencias.add(Transferencia(100.0, 377541));
    // Trabalhando com statful não se pode fazer esse tipo de adição,
    // pois esse código vai rodar várias vezes e isso vai deixar o sistema zuado.
    // Poderia ser usado normalmente no statless component
    _transferencias.add(Transferencia(100.0, 1000));
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferências'),
      ),
      body: ListView.builder(
        itemCount: _transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = _transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future<dynamic> future = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            }),
          );
          future.then((transferenciaRecebida) {
            debugPrint('Chegou no then do future');
            debugPrint('$transferenciaRecebida');
            transferenciaRecebida != null ? _transferencias.add(transferenciaRecebida) : debugPrint('null');
            //_transferencias.add(transferenciaRecebida!);
            if(transferenciaRecebida != null) {
              _transferencias.add(transferenciaRecebida!);
            }
            debugPrint('$_transferencias');
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}
