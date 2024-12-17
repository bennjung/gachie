// projectApply.js
function validateForm(event) {
    // 각 입력 필드의 값을 가져옴
    const applyField = document.getElementById('apply-field').value.trim();
    const selfIntro = document.getElementById('self-intro').value.trim();
    const techStack = document.getElementById('tech-stack').value.trim();
    const email = document.getElementById('email').value.trim();

    // 각 필드 검증
    if (!applyField) {
        event.preventDefault(); // 폼 제출 중단
        alert('지원 분야를 선택해주세요.');
        return false;
    }

    if (!selfIntro) {
        event.preventDefault();
        alert('자기 소개를 입력해주세요.');
        return false;
    }

    if (!techStack) {
        event.preventDefault();
        alert('보유 기술 스택을 입력해주세요.');
        return false;
    }

    if (!email) {
        event.preventDefault();
        alert('이메일을 입력해주세요.');
        return false;
    }

    return true;
}