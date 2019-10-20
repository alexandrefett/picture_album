class Hotel{
  String id;
  String nome;
  String descricao;
  String imageUrl;
//  List<Categoria> categorias;

//  Hotel({this.nome, this.descricao, this.categorias, this.imageUrl});
  Hotel({this.nome, this.descricao, this.imageUrl, this.id});

  factory Hotel.fromJson(Map<dynamic, dynamic> json){
    return Hotel(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      imageUrl: json['imageUrl']
      //,categorias: json['categorias'] != null ? (json['categorias'] as List).map((i) => Categoria.fromJson(i)).toList() : null
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'nome':nome,
        'descricao':descricao,
        'imageUrl':imageUrl
        //'categorias': categorias==null ? [] : categorias.map((cat)=> cat.toJson()).toList()
      };
}

class Categoria{
  String id;
  String categoria;
  String imageurl;
  //List<String> fotos;

  Categoria({this.categoria, this.id, this.imageurl});

  factory Categoria.fromJson(Map<dynamic, dynamic> json){
    return Categoria(
        id: json['id'],
        categoria: json['categoria'],
        imageurl: json['imageurl']
        //fotos: json['fotos'] != null ? (json['fotos'] as List).map((i) => i).toList() : null
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'categoria':categoria,
        'imageurl':imageurl
        //'fotos': fotos.map((foto) => foto).toList()
      };
}