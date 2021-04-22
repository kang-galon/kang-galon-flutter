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
  final String image;

  Depot({
    this.phoneNumber,
    this.name,
    this.latitude,
    this.longitude,
    this.address,
    this.rating,
    this.price,
    this.priceDesc,
    this.isOpen,
    this.isOpenDesc,
    this.distance,
    this.image,
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
}
