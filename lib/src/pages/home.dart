import 'dart:io';

import 'package:band_names/src/models/models.dart';
import 'package:band_names/src/providers/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routerName = 'Home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];
  @override
  void initState() {
    final socketServer = Provider.of<SocketService>(context, listen: false);
    socketServer.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketServer = Provider.of<SocketService>(context, listen: false);
    socketServer.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverSatus = Provider.of<SocketService>(context).serverStatus;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (serverSatus == ServerStatus.online)
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          if (bands.isNotEmpty) _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) => _bandTile(bands[index]),
            ),
          ),
        ],
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
    final socketServer = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => socketServer.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketServer.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
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
              ));
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  void addBandToList(String nombreBanda) {
    if (nombreBanda.isNotEmpty) {
      final socketServer = Provider.of<SocketService>(context, listen: false);
      socketServer.emit('add-band', {'nombre': nombreBanda});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {for (var element in bands) element.name: element.votes.toDouble()};

    final List<Color> colorList = [
      Colors.blue,
      Colors.yellow,
      Colors.pink,
      Colors.green,
      Colors.grey,
    ];

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 30,
        chartRadius: MediaQuery.of(context).size.width / 2.9,
        colorList: colorList,
        initialAngleInDegree: 1,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right, //
          showLegends: true, //

          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false, //
          showChartValues: true, //
          showChartValuesInPercentage: true, //
          showChartValuesOutside: false, //
          decimalPlaces: 0, //
          chartValueBackgroundColor: Colors.grey[200], //
        ),
      ),
    );
  }
}
