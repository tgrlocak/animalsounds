class Animal {
  String key;
  String imagePath;
  String soundPath;
  Map<String, String> names;

  Animal({
    this.key,
    this.imagePath,
    this.soundPath,
    this.names
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    Map<String, String> names = {};
    (json['names'] as List).forEach((n) => names[(n as Map).keys.first] = (n as Map).values.first);
    
    return Animal(
      key: json['key'],
      imagePath: json['image'],
      soundPath: json['sound'],
      names: names
    );
  }

  @override
  String toString() {
    return 'Animal:[key: ${this.key}, image: ${this.imagePath}, sound: ${this.soundPath}, names: ${this.names}]';
  }
}