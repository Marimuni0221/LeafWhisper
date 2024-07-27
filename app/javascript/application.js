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
  
document.addEventListener('DOMContentLoaded', () => {
  window.openModal = () => {
    document.getElementById('reviewModal').classList.remove('hidden');
  };

  window.closeModal = () => {
    document.getElementById('reviewModal').classList.add('hidden');
  };

  // 閉じるボタンのイベントリスナー
  document.addEventListener('click', function(event) {
    if (event.target.id === 'close-modal') {
      const modal = event.target.closest('.fixed.inset-0');
      if (modal) {
        window.location.href = '/products/search'; // ここでリダイレクト先のURLを指定
      }
    }
  });
});

