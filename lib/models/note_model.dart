
class Note {
  int? id;
  String title;
  String contentJson; // store Quill JSON
  String createdAt;
  String updatedAt;

  Note({
    this.id,
    required this.title,
    required this.contentJson,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'contentJson': contentJson,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      contentJson: map['contentJson'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
