class Favorite {
  final int id;
  final String userEmail;
  final int cafeId;
  final String category;
  final String note;
  final String cafeName;
  final String cafeArea;
  final String cafeImage;

  Favorite({
    required this.id,
    required this.userEmail,
    required this.cafeId,
    required this.category,
    required this.note,
    required this.cafeName,
    required this.cafeArea,
    required this.cafeImage,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      userEmail: json['user_email']?.toString() ?? '',
      cafeId: json['cafe_id'] is int
          ? json['cafe_id'] as int
          : int.parse(json['cafe_id'].toString()),
      category: json['category']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      cafeName: json['cafe_name']?.toString() ?? 'Unknown cafe',
      cafeArea: json['cafe_area']?.toString() ?? '',
      cafeImage: json['cafe_image']?.toString() ?? '',
    );
  }
}
