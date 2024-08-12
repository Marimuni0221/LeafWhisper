function initMap() {
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 35.6895, lng: 139.6917 },
    zoom: 12,
  });
  
  const cafes = JSON.parse(document.getElementById('map-data').dataset.cafes);
  
  cafes.forEach(function(cafe) {
    new google.maps.Marker({
      position: { lat: cafe.latitude, lng: cafe.longitude },
      map: map,
      title: cafe.name,
    });
  });
}
  
document.addEventListener("DOMContentLoaded", function() {
  initMap();
});
  