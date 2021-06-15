class Depot {
  final String phoneNumber;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final double rating;
  final int price;
  final String priceDesc;
  final bool isOpen;
  final String isOpenDesc;
  final double distance;
  final String? image;

  Depot({
    required this.phoneNumber,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.rating,
    required this.price,
    required this.priceDesc,
    required this.isOpen,
    required this.isOpenDesc,
    required this.image,
    this.distance = 0,
  });

  static List<Depot> fromJsonToList(dynamic json) {
    List<Depot> depots = [];

    for (var depot in json) {
      depots.add(Depot(
        address: depot['address'],
        distance: depot['distance'],
        image: depot['image'],
        isOpen: depot['is_open'] == 1 ? true : false,
        isOpenDesc: depot['is_open_description'],
        latitude: depot['latitude'],
        longitude: depot['longitude'],
        name: depot['name'],
        phoneNumber: depot['phone_number'],
        price: depot['price'],
        priceDesc: depot['price_description'],
        rating: double.parse(depot['rating'].toString()),
      ));
    }

    return depots;
  }

  factory Depot.fromJson(dynamic json) {
    return Depot(
      phoneNumber: json['phone_number'],
      name: json['name'],
      image: json['image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      rating: double.parse(json['rating'].toString()),
      price: json['price'],
      priceDesc: json['price_description'],
      isOpen: json['is_open'] == 1 ? true : false,
      isOpenDesc: json['is_open_description'],
    );
  }
}
