document.addEventListener("DOMContentLoaded", function() {
  if (typeof google === 'undefined') {
    console.error("Google Maps APIがロードされていません。");
    return;
  }
  
  const input = document.getElementById("address");

  const autocomplete = new google.maps.places.Autocomplete(input, {
    types: ['geocode'],
    componentRestrictions: { country: "jp" },
  });

  autocomplete.addListener('place_changed', function() {
    const place = autocomplete.getPlace();

    if (!place.geometry) {
      alert("その場所の詳細が見つかりませんでした。別の住所をお試しください。");
      return;
    }

    if (typeof map !== 'undefined') {
        map.setCenter(place.geometry.location);
        map.setZoom(15);
  
        const marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location
        });
      } else {
        console.error("地図オブジェクトが定義されていません。");
      }
  });
}); 