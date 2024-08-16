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
    }, (error) => {
        console.error("現在地の取得に失敗しました。", error);
    });
}

window.codeAddress = function() {
    //検索フォームの入力内容を取得
    let inputAddress = document.getElementById('address').value;

    geocoder.geocode({ 'address': inputAddress }, function(results, status) {
        //該当する検索結果がヒットした時に、地図の中心を検索結果の緯度経度に更新する
        if (status == 'OK') {
            map.setCenter(results[0].geometry.location);
            new google.maps.Marker({
                map: map,
                position: results[0].geometry.location
            });
        } else {
            //検索結果が何もなかった場合に表示
            alert('該当する結果がありませんでした：' + status);
        }
    });   
}

function searchCafes(location) {
    const service = new google.maps.places.PlacesService(map);
    const reviewPathTemplate = document.getElementById('map').dataset.reviewUrl;

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
                            // 'PLACE_ID' を実際のplace_idに置き換え
                            const reviewPath = reviewPathTemplate.replace('PLACE_ID', place.place_id);
                            const contentString = `
                                <div class="p-4 bg-white rounded-lg shadow-lg">
                                  <h2 class="text-lg font-semibold">${placeDetails.name}</h2>
                                  <p class="text-gray-600">${placeDetails.formatted_address}</p>
                                  <a href="https://www.google.com/maps/place/?q=place_id=${place.place_id}" target="_blank">Googleで見る</a>
                                  <a href="#" onclick="openModal('${reviewPath}')" class="bg-secondary hover:bg-blue-600 text-white font-bold py-2 px-4 rounded mt-4 inline-block">レビューを書く</a>
                                </div>`;
                            const infowindow = new google.maps.InfoWindow({
                                content: contentString,
                            });
                            infowindow.open(map, marker);
                        }
                    });
                });
            });
        }
    });
}
