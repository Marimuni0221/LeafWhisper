document.addEventListener("DOMContentLoaded", function() {
  // Google Maps APIがロードされているか確認
  if (typeof google === 'undefined') {
    console.error("Google Maps APIがロードされていません。");
    return;
  }
  
  const input = document.getElementById("address");

  // Google Maps Places APIのオートコンプリート機能を設定
  const autocomplete = new google.maps.places.Autocomplete(input, {
    types: ['geocode'], // 検索対象を地名に限定
    componentRestrictions: { country: "jp" }, // 日本国内に限定（必要に応じて）
  });

  // ユーザーが選択した場所に基づいて地図を更新する
  autocomplete.addListener('place_changed', function() {
    const place = autocomplete.getPlace();

    if (!place.geometry) {
      alert("その場所の詳細が見つかりませんでした。別の住所をお試しください。");
      return;
    }

    // map.jsの地図オブジェクトを使用して地図を更新
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