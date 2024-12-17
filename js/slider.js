let index = 0;
const slides = document.querySelectorAll(".slides img");
const totalSlides = slides.length;

// 슬라이더 컨테이너의 너비를 동적으로 가져옴
const sliderWidth = document.querySelector(".slider").offsetWidth;

function showNextSlide() {
    console.log('슬라이드 번호:', index);  // 콘솔로 현재 슬라이드 번호 확인
    index = (index + 1) % totalSlides;  // 슬라이드 번호를 순환
    document.querySelector(".slides").style.transform = `translateX(-${index * sliderWidth}px)`;  // 슬라이더 너비에 맞게 이동
}

// 3초마다 슬라이드를 전환
setInterval(showNextSlide, 3000);
