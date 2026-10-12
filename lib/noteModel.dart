class NoteModel {
  final int? id ;
  final String title;
  final String description;
  final String userId;
  NoteModel(this.id, this.title, this.description, this.userId);
  Map<String,dynamic>toMap(){
    return {
      'id':id,
      'title':title,
      'description':description,
      'userId':userId,
    };
  }
  factory NoteModel.fromMap(Map<String,dynamic>map){
    return NoteModel(
      map ['id'],
      map ['title'],
      map['description'],
      map['userId'] ?? '',

    );
  }
}