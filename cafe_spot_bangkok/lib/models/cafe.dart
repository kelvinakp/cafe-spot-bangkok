class Cafe {
  final int id;
  final String name;
  final String area;
  final String address;
  final String description;
  final String imageUrl;
  final String vibe;
  final String wifiScore;
  final String signatureDrink;
  final String priceLevel;
  final String status;

  Cafe({
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.vibe,
    required this.wifiScore,
    required this.signatureDrink,
    required this.priceLevel,
    required this.status,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      vibe: json['vibe']?.toString() ?? '',
      wifiScore: json['wifi_score']?.toString() ?? '',
      signatureDrink: json['signature_drink']?.toString() ?? '',
      priceLevel: json['price_level']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'address': address,
      'description': description,
      'image_url': imageUrl,
      'vibe': vibe,
      'wifi_score': wifiScore,
      'signature_drink': signatureDrink,
      'price_level': priceLevel,
      'status': status,
    };
  }
}
