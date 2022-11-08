import 'dart:io';

import 'package:band_names/src/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routerName = 'Home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Bon jovi', votes: 5),
    Band(id: '2', name: 'Aldeano', votes: 2),
    Band(id: '3', name: 'Nampa', votes: 1),
    Band(id: '4', name: 'Khlan', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: ()=>addNewBand(),    //se haria asi cuando se tiene argumentos
        onPressed: addNewBand, //se hace asi xq no tiene argumentos
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        print('id: ${band.id}');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () => print(band.name),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Nombre de la banda'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => addBandToList(textController.text),
                  child: const Text('Agregar'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nombre de la banda'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              onPressed: () => addBandToList(textController.text),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Agregar'),
            )
          ],
        );
      },
    );
  }

  void addBandToList(String nombreBanda) {
    if (nombreBanda.isNotEmpty) {
      bands.add(Band(id: DateTime.now().toString(), name: nombreBanda, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
