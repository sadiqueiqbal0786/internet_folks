class Data {
  int? id;
  String? title;
  String? description;
  String? bannerImage;
  String? dateTime;
  String? organiserName;
  String? organiserIcon;
  String? venueName;
  String? venueCity;
  String? venueCountry;

  Data(
      {this.id,
      this.title,
      this.description,
      this.bannerImage,
      this.dateTime,
      this.organiserName,
      this.organiserIcon,
      this.venueName,
      this.venueCity,
      this.venueCountry});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    bannerImage = json['banner_image'];
    dateTime = json['date_time'];
    organiserName = json['organiser_name'];
    organiserIcon = json['organiser_icon'];
    venueName = json['venue_name'];
    venueCity = json['venue_city'];
    venueCountry = json['venue_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['banner_image'] = this.bannerImage;
    data['date_time'] = this.dateTime;
    data['organiser_name'] = this.organiserName;
    data['organiser_icon'] = this.organiserIcon;
    data['venue_name'] = this.venueName;
    data['venue_city'] = this.venueCity;
    data['venue_country'] = this.venueCountry;
    return data;
  }
}
