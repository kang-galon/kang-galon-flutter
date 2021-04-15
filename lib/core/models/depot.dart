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
}

class DepotUninitialized extends Depot {}

class DepotEmpty extends Depot {
  @override
  String toString() {
    return 'Tidak ada depot di sekitar anda';
  }
}

class DepotFetchList extends Depot {
  final double latitude;
  final double longitude;

  DepotFetchList({this.latitude, this.longitude});
}

class DepotListSuccess extends Depot {
  final List<Depot> depots;

  DepotListSuccess({this.depots});

  factory DepotListSuccess.fromJsonToList(dynamic json) {
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

    return DepotListSuccess(depots: depots);
  }
}

class DepotLoading extends Depot {}

class DepotError extends Depot {
  @override
  String toString() {
    return 'Ups.. ada yang salah nih';
  }
}
