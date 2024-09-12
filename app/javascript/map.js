let map;
let geocoder;

window.initMap = function() {
    console.log('Initializing map');
    geocoder = new google.maps.Geocoder();

    const errorGeolocation = document.body.getAttribute('data-error-geolocation');
    const viewOnGoogleMapsText = document.body.getAttribute('data-view-on-google-maps');
    const favoriteNotAvailableText = "The Favorites are not available in the English version.";

    const isEnglish = document.documentElement.lang === 'en';

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

        map.addListener('dragend', () => {
            const center = map.getCenter();
            searchCafes(center);
        });

        initAutocomplete();
    }, (error) => {
        console.error(errorGeolocation, error);
    });

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
                                    let googleMapsLink;
                                    const isMobile = /Android|iPhone/i.test(navigator.userAgent);
                    
                                    if (isMobile) {
                                        googleMapsLink = `comgooglemaps://?q=place_id:${place.place_id}`;
                                    } else {
                                        googleMapsLink = `https://www.google.com/maps/place/?q=place_id:${place.place_id}`;
                                    }
                    
                                    if (isEnglish) {
                                        const contentString = `
                                            <div class="p-4 bg-white rounded-lg shadow-lg">
                                                <h2 class="text-lg font-semibold">${placeDetails.name}</h2>
                                                <p class="text-gray-600">${placeDetails.formatted_address}</p>
                                                <a href="${googleMapsLink}" target="_blank">
                                                    ${viewOnGoogleMapsText}
                                                </a>
                                                <p class="text-gray-500 text-sm mt-4">${favoriteNotAvailableText}</p>
                                            </div>`;
                                        const infowindow = new google.maps.InfoWindow({
                                            content: contentString,
                                        });
                                        infowindow.open(map, marker);
                                    } else {
                                        fetch(`/cafes/${place.place_id}/favorite_button`)
                                            .then(response => response.json())
                                            .then(data => {
                                                const contentString = `
                                                    <div class="p-4 bg-white rounded-lg shadow-lg">
                                                        <h2 class="text-lg font-semibold">${placeDetails.name}</h2>
                                                        <p class="text-gray-600">${placeDetails.formatted_address}</p>
                                                        <a href="${googleMapsLink}" target="_blank">
                                                            ${viewOnGoogleMapsText}
                                                        </a>
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
                                    }
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
                phone_number: placeDetails.formatted_phone_number || '',
                cafe_url: placeDetails.website || '',
                cafe_image_url: placeDetails.photos ? placeDetails.photos[0].getUrl({ maxWidth: 400 }) : '' // カフェの画像URLを取得
            })
        });
    }
}

function initAutocomplete() {
    const input = document.getElementById("address");
    const errorNoPlaceDetails = document.body.getAttribute('data-error-no_place_details');

    const autocomplete = new google.maps.places.Autocomplete(input, {
        types: ['geocode'],
    });

    autocomplete.addListener('place_changed', function() {
        const place = autocomplete.getPlace();

        if (!place.geometry) {
            alert(errorNoPlaceDetails);
            return;
        }

        map.setCenter(place.geometry.location);
        map.setZoom(15);

        new google.maps.Marker({
            map: map,
            position: place.geometry.location
        });
    });
}

window.codeAddress = function() {
    const alertNoResults = document.body.getAttribute('data-alert-no_results');

    let inputAddress = document.getElementById('address').value;

    geocoder.geocode({ 'address': inputAddress }, function(results, status) {
        if (status == 'OK') {
            map.setCenter(results[0].geometry.location);
            new google.maps.Marker({
                map: map,
                position: results[0].geometry.location
            });
        } else {
            alert(alertNoResults + ': ' + status);
        }
    });   
}
