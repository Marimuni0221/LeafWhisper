import "@hotwired/turbo-rails";
import "controllers";
import "./map";

// Turbo Load: ページ遷移ごとに初期化
document.addEventListener('turbo:load', () => {
  initializeStarRating();
  setupModalListeners();
  setupMenuToggle(); // 追加: メニューのトグルをセットアップ
  disableButtonAfterClick(); // 追加: ボタンの無効化をセットアップ

  // ログイン後にモーダルを自動表示する
  const modalTrigger = document.getElementById('review-modal-trigger');
  if (modalTrigger) {
    modalTrigger.click(); // ログイン後にモーダルを表示
  }
});

// ボタンの無効化をセットアップする関数
function disableButtonAfterClick() {
  const reviewButton = document.querySelector('#no-double_click-button');

  if (reviewButton) {
    reviewButton.addEventListener('click', function() {
      reviewButton.disabled = true; // ボタンを無効化
      reviewButton.form.submit(); // ボタンを無効化した後にフォームを送信
    });
  }
}

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
    const isLoggedIn = document.querySelector('meta[name="logged-in"]').getAttribute('content') === 'true';
    
    if (isLoggedIn) {
      // ログイン済みの場合、モーダルを表示
      fetch(url)
        .then(response => response.text())
        .then(html => {
          document.getElementById('modalContent').innerHTML = html;
          document.getElementById('reviewModal').classList.remove('hidden');
          initializeStarRating(); // モーダル内の星評価を初期化
        });
    } else {
      // 未ログインの場合、ログインページにリダイレクト
      window.location.href = '/users/sign_in';
    }
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


// メニューのトグルをセットアップ
function setupMenuToggle() {
  const menuToggle = document.getElementById('menu-toggle');
  const mobileMenu = document.getElementById('mobile-menu');

  if (menuToggle && mobileMenu) {
    menuToggle.addEventListener('click', function() {
      if (mobileMenu.classList.contains('hidden')) {
        mobileMenu.classList.remove('hidden');
      } else {
        mobileMenu.classList.add('hidden');
      }
    });
  }
}