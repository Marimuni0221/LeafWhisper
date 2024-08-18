import "@hotwired/turbo-rails";
import "controllers";
import "./map";

// Turbo Load: ページ遷移ごとに初期化
document.addEventListener('turbo:load', () => {
  initializeStarRating();
  setupModalListeners();
});

// 星評価の初期化
function initializeStarRating() {
  const stars = document.querySelectorAll('.star');
  let clicked = false;

  stars.forEach((star, i) => {
    star.addEventListener('click', () => {
      clicked = true; // クリック済み
      updateStarRating(i, stars);
    }, false);

    // ホバー機能の追加（オプション）
    star.addEventListener('mouseover', () => {
      if (!clicked) {
        updateStarRating(i, stars);
      }
    });

    star.addEventListener('mouseout', () => {
      if (!clicked) {
        resetStarRating(stars);
      }
    });
  });
}

function updateStarRating(index, stars) {
  for (let j = 0; j <= index; j++) {
    stars[j].style.color = "#f0da61"; // 黄色
  }
  for (let j = index + 1; j < stars.length; j++) {
    stars[j].style.color = "#a09a9a";  // グレー
  }
}

function resetStarRating(stars) {
  stars.forEach(star => {
    star.style.color = "#a09a9a"; // リセット時は全てグレー
  });
}

// モーダルのリスナーを設定
function setupModalListeners() {
  window.openModal = (url) => {
    fetch(url)
      .then(response => response.text())
      .then(html => {
        document.getElementById('modalContent').innerHTML = html;
        document.getElementById('reviewModal').classList.remove('hidden');
        initializeStarRating(); // モーダル内の星評価を初期化
      });
  };

  window.closeModal = () => {
    document.getElementById('reviewModal').classList.add('hidden');
  };

  // モーダル外をクリックして閉じるリスナー
  document.addEventListener('click', function(event) {
    const modal = document.getElementById('reviewModal');
    if (modal && event.target.id === 'close-modal') {
      modal.classList.add('hidden');
    }
  });
}
