import "@hotwired/turbo-rails";
import "controllers";
import "./map";

document.addEventListener('turbo:load', () => {
  initializeStarRating();
  setupModalListeners();
  setupMenuToggle();
  disableButtonAfterClick();

  const modalTrigger = document.getElementById('review-modal-trigger');
  if (modalTrigger) {
    modalTrigger.click();
  }

  const avatarInput = document.getElementById('user_avatar');
  const imagePreview = document.getElementById('image-preview');

  if (avatarInput && imagePreview) {
    avatarInput.addEventListener('change', function (event) {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();

        reader.onload = function (e) {
          imagePreview.src = e.target.result;
        };

        reader.readAsDataURL(file);
      }
    });
  }
});

function disableButtonAfterClick() {
  const reviewButton = document.querySelector('#no-double_click-button');

  if (reviewButton) {
    reviewButton.addEventListener('click', function() {
      reviewButton.disabled = true; 
      reviewButton.form.submit();
    });
  }
}

function initializeStarRating() {
  const stars = document.querySelectorAll('.star');
  let clicked = false;

  stars.forEach((star, i) => {
    star.addEventListener('click', () => {
      clicked = true;
      updateStarRating(i, stars);
    }, false);

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
    stars[j].style.color = "#f0da61";
  }
  for (let j = index + 1; j < stars.length; j++) {
    stars[j].style.color = "#a09a9a";
  }
}

function resetStarRating(stars) {
  stars.forEach(star => {
    star.style.color = "#a09a9a";
  });
}

function setupModalListeners() {
  window.openModal = (url) => {
    const isLoggedIn = document.querySelector('meta[name="logged-in"]').getAttribute('content') === 'true';
    
    if (isLoggedIn) {
      fetch(url)
        .then(response => response.text())
        .then(html => {
          document.getElementById('modalContent').innerHTML = html;
          document.getElementById('reviewModal').classList.remove('hidden');
          initializeStarRating();
        });
    } else {
      window.location.href = '/users/sign_in';
    }
  };

  window.closeModal = () => {
    document.getElementById('reviewModal').classList.add('hidden');
  };

  document.addEventListener('click', function(event) {
    const modal = document.getElementById('reviewModal');
    if (modal && event.target.id === 'close-modal') {
      modal.classList.add('hidden');
    }
  });
}

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