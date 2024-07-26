// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:load', function() {
    const stars = document.querySelectorAll('.star');
    let clicked = false;
  
    stars.forEach((star, i) => {
      star.addEventListener('click', () => {
        clicked = true; // クリック済み
        for (let j = 0; j <= i; j++) {  // 星1からクリックされた星まで
          stars[j].style.color = "#f0da61"; // 黄色に
        }
        for (let j = i + 1; j < stars.length; j++) {  // クリックされた星の次から星5まで
          stars[j].style.color = "#a09a9a";  // グレーに
        }
      }, false);
    });
  }); 
  