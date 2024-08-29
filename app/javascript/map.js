let map;
let geocoder;

window.initMap = function() {
    console.log('Initializing map');
    geocoder = new google.maps.Geocoder();

    navigator.geolocation.getCurrentPosition((position) => {
        const userLocation = { 
            lat: position.coords.latitude, 
            lng: position.coords.longitude 
        };

        map = new google.maps.Map(document.getElementById("map"), {
            center: userLocation,
            zoom: 15,
        });

        new google.maps.Marker({
            position: userLocation,
            map: map,
            title: "現在地"
        });

        searchCafes(userLocation);

        // ドラッグ後にカフェを再検索
        map.addListener('dragend', () => {
            const center = map.getCenter();
            searchCafes(center);
        });

        // オートコンプリートの初期化
        initAutocomplete();
    }, (error) => {
        console.error("現在地の取得に失敗しました。", error);
    });
}

function initAutocomplete() {
    const input = document.getElementById("address");

    const autocomplete = new google.maps.places.Autocomplete(input, {
        types: ['geocode'],
    });

    autocomplete.addListener('place_changed', function() {
        const place = autocomplete.getPlace();

        if (!place.geometry) {
            alert("その場所の詳細が見つかりませんでした。別の住所をお試しください。");
            return;
        }

        // 地図をオートコンプリートで選択された場所に移動
        map.setCenter(place.geometry.location);
        map.setZoom(15);

        new google.maps.Marker({
            map: map,
            position: place.geometry.location
        });
    });
}

window.codeAddress = function() {
    let inputAddress = document.getElementById('address').value;

    geocoder.geocode({ 'address': inputAddress }, function(results, status) {
        if (status == 'OK') {
            map.setCenter(results[0].geometry.location);
            new google.maps.Marker({
                map: map,
                position: results[0].geometry.location
            });
        } else {
            alert('該当する結果がありませんでした：' + status);
        }
    });   
}

function searchCafes(location) {
    const service = new google.maps.places.PlacesService(map);
    service.nearbySearch({
        location: location,
        radius: 5000,
        keyword: "抹茶カフェ"
    }, (results, status) => {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
            results.forEach((place) => {
                const marker = new google.maps.Marker({
                    position: place.geometry.location,
                    map: map,
                    title: place.name
                });

                marker.addListener('click', () => {
                    service.getDetails({ placeId: place.place_id }, (placeDetails, status) => {
                        if (status === google.maps.places.PlacesServiceStatus.OK) {
                            saveCafeToServer(placeDetails).then(() => {
                                fetch(`/cafes/${place.place_id}/favorite_button`)
                                    .then(response => response.json())
                                    .then(data => {
                                        const contentString = `
                                            <div class="p-4 bg-white rounded-lg shadow-lg">
                                              <h2 class="text-lg font-semibold">${placeDetails.name}</h2>
                                              <p class="text-gray-600">${placeDetails.formatted_address}</p>
                                              <a href="https://www.google.com/maps/place/?q=place_id:${place.place_id}" target="_blank">Googleで見る</a>
                                              <div class="flex justify-between items-center mt-4 space-x-4">
                                                ${data.favorite_button_html}
                                                <a href="${data.share_url}" target="_blank" class="ml-4">
                                                  <i class="fa-brands fa-x-twitter fa-xl"></i>
                                                </a>    
                                              </div>
                                            </div>`;
                                        const infowindow = new google.maps.InfoWindow({
                                            content: contentString,
                                        });
                                        infowindow.open(map, marker);
                                    })
                                    .catch(error => {
                                        console.error('お気に入りボタンの取得に失敗しました:', error);
                                    });
                            });
                        }
                    });
                });
            });
        }
    });
}

function saveCafeToServer(placeDetails) {
    return fetch('/cafes/save', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
            name: placeDetails.name,
            address: placeDetails.formatted_address,
            place_id: placeDetails.place_id,
            phone_number: placeDetails.formatted_phone_number || '', // 電話番号を取得
            cafe_url: placeDetails.website || '', // カフェのウェブサイトURLを取得
            cafe_image_url: placeDetails.photos ? placeDetails.photos[0].getUrl({ maxWidth: 400 }) : '' // カフェの画像URLを取得
        })
    });
}