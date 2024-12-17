<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가치해요</title>
    <link rel="stylesheet" href="css/main1.css">
    <link rel="stylesheet" href="css/navstyles.css">
</head>

<body>
    <jsp:include page="navbar.jsp" />

    <section class="main-banner">
        <div class="content">
            <h1>가치 성장하는 IT 프로젝트</h1>
            <p>함께 만들어가는 프로젝트, 가치있는 경험을 시작하세요</p>
            <button class="btn-search" onclick="window.location.href='projectLists.jsp';">프로젝트 찾기</button>
            <a href="myproject.jsp">
                <button class="btn-myproject">내 프로젝트</button>
            </a>
        </div>

        <div class="slider">
            <div class="slides">
                <img src="img/image1.jpg" alt="이미지 1">
                <img src="img/image2.jpg" alt="이미지 2">

            </div>
        </div>
    </section>

    <button class="scroll-down" onclick="scrollToContent()">⬇</button> <!-- 떠다니는 화살표 -->

    <section class="project-list">
        <div class="project-card">
            <h2>캡스톤 디자인: AI 기반 학습 관리 시스템</h2>
            <div class="tags">
                <span>Python</span><span>TensorFlow</span><span>React</span>
            </div>
            <div class="details">
                <p><strong>현재 인원:</strong> 프로젝트 매니저 1명 / 백엔드 1명</p>
                <p><strong>모집 인원:</strong> AI 개발자 1명 / 백엔드 개발자 1명</p>
            </div>
        </div>
        <div class="project-card">
            <h2>IoT 프로젝트: 스마트 농업 시스템</h2>
            <div class="tags">
                <span>JavaScript</span><span>Node.js</span><span>Arduino</span>
            </div>
            <div class="details">
                <p><strong>현재 인원:</strong> 프론트엔드 2명 / IoT 엔지니어 1명</p>
                <p><strong>모집 인원:</strong> 백엔드 개발자 1명</p>
            </div>
        </div>
        <div class="project-card">
            <h2>머신러닝 기반 추천 시스템 개발</h2>
            <div class="tags">
                <span>Python</span><span>scikit-learn</span><span>Flask</span>
            </div>
            <div class="details">
                <p><strong>현재 인원:</strong> 데이터 분석가 1명</p>
                <p><strong>모집 인원:</strong> 머신러닝 엔지니어 2명</p>
            </div>
        </div>
        <div class="project-card">
            <h2>소셜 미디어 데이터 분석 및 시각화</h2>
            <div class="tags">
                <span>Python</span><span>Pandas</span><span>Matplotlib</span>
            </div>
            <div class="details">
                <p><strong>현재 인원:</strong> 데이터 분석가 2명</p>
                <p><strong>모집 인원:</strong> 데이터 엔지니어 1명</p>
            </div>
        </div>
        <div class="project-card">
            <h2>VR 게임: 몰입형 체험 시뮬레이터</h2>
            <div class="tags">
                <span>Unity</span><span>C#</span><span>Blender</span>
            </div>
            <div class="details">
                <p><strong>현재 인원:</strong> 게임 디자이너 1명 / VR 개발자 1명</p>
                <p><strong>모집 인원:</strong> 3D 모델러 1명 / 게임 개발자 1명</p>
            </div>
        </div>
    </section>
    
    

    <script src="js/slider.js"></script> <!-- 슬라이더 JS 추가 -->

    <script>
        function scrollToContent() {
            // 특정 섹션으로 부드럽게 스크롤 이동
            const targetSection = document.querySelector(".project-list");
            targetSection.scrollIntoView({ behavior: "smooth" });
        }
    </script>
</body>

</html>
