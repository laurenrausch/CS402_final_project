class Project {
  String id;
  String title;
  String description;
  List<String> todoItems;
  List<String> photoPaths;
  DateTime createdAt;
  DateTime updatedAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    List<String>? todoItems,
    List<String>? photoPaths,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : todoItems = todoItems ?? [],
        photoPaths = photoPaths ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Project copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? todoItems,
    List<String>? photoPaths,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      todoItems: todoItems ?? List.from(this.todoItems),
      photoPaths: photoPaths ?? List.from(this.photoPaths),
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
