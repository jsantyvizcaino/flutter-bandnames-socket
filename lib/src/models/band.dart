class Band {
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        //el factory tienee como objetivo regresar una nueva instancia de la clase
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'none',
        votes: obj.containsKey('votes') ? obj['votes'] : 'none',
      );
}
