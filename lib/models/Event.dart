class EventModel {
  String id;
  String name;
  String description;
  String eventDate;
  String image;
  String location;
  String organizer;
  String organizerId;
  String price;

  EventModel({this.eventDate, this.image, this.location, this.name, this.organizer, this.price, this.organizerId,this.description});

  EventModel.fromMap(Map snapshot,String id) :
        id = id ?? '',
        price = snapshot['price'] ?? '',
        name = snapshot['name'] ?? '',
        image = snapshot['image'] ?? '',
        description = snapshot['desc'] ?? '',
        eventDate = snapshot['datetime'] ?? '',
        location = snapshot['location'] ?? '',
        organizerId = snapshot['organizerid'] ?? '',
        organizer = snapshot['organizer'] ?? '';

  toJson() {
    return {
      "price": price,
      "name": name,
      "image": image,
      "desc" :description,
      "datetime" : eventDate,
      "location" : location,
      "organizerid" : organizerId,
      "organizer" : organizer,
    };
  }
}

