<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로젝트 등록</title>
    <link rel="stylesheet" href="css/navstyles.css">
    <link rel="stylesheet" href="css/registe.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container">
        <form id="project-form" onsubmit="return validateForm()" method="post" action="submitProject.jsp">
            <!-- 프로젝트 제목 -->
            <div class="section">
                <h2>프로젝트 제목</h2>
                <input type="text" name="project_title" placeholder="프로젝트 제목을 입력해주세요" required>
            </div>

            <!-- 프로젝트 유형 -->
            <div class="section">
                <h2>프로젝트 유형</h2>
                <div class="buttons-group">
                    <button type="button" class="project-type" data-value="0">학교 과제</button>
                    <button type="button" class="project-type" data-value="1">공모전</button>
                    <button type="button" class="project-type" data-value="2">토이프로젝트</button>
                </div>
                <input type="hidden" name="project_type" id="project_type" required>
            </div>

            <!-- 기술 스택 -->
            <div class="section">
                <h2>기술 스택</h2>
                <div class="input-group">
                    <input type="text" id="field-input" placeholder="사용할 기술 스택을 입력하세요">
                    <button type="button" onclick="addField()">추가</button>
                </div>
                <div id="example-tags" class="example-tags">
                    <span class="example-tag" onclick="useExampleTag('HTML5')">HTML5</span>
                    <span class="example-tag" onclick="useExampleTag('Java')">Java</span>
                    <span class="example-tag" onclick="useExampleTag('Spring')">Spring</span>
                    <span class="example-tag" onclick="useExampleTag('Python')">Python</span>
                    <span class="example-tag" onclick="useExampleTag('JavaScript')">JavaScript</span>
                </div>
                <div id="field-list" class="tag-container"></div>
                <input type="hidden" id="techStackInput" name="techStack">
            </div>

            <!-- 모집 분야 -->
            <div class="section">
                <h2>모집 분야</h2>
                <div id="recruitment-list" class="recruitment-list">
                    <div class="recruitment-item">
                        <h3 class="recruitment-title">모집 분야 #1</h3>
                        <div class="recruitment-fields">
                            <input type="text" name="recruit_field[]" placeholder="역할 (예: AI 개발자)" required>
                            <input type="number" name="recruit_count[]" value="1" min="1" required> 명
                        </div>
                        <textarea name="recruit_requirements[]" rows="2" placeholder="필요 역량이나 요구사항" required></textarea>
                        <button type="button" class="delete-btn" onclick="deleteRecruitment(this)">삭제</button>
                    </div>
                </div>
                <button type="button" class="add-btn" onclick="addRecruitment()">+ 모집 분야 추가</button>
            </div>

            <!-- 프로젝트 소개 -->
            <div class="section">
                <h2>프로젝트 소개</h2>
                <textarea name="description" rows="3" placeholder="프로젝트의 목적을 설명해주세요" required></textarea>
                <textarea name="details" rows="5" placeholder="프로젝트에 대한 상세한 설명을 작성해주세요" required></textarea>
            </div>

            <!-- 마감일 설정 -->
            <div class="section">
                <h2>마감일 설정</h2>
                <div class="date-picker">
                    <input type="date" name="deadline_date" required>
                </div>
            </div>

            <!-- 제출 버튼 -->
            <div class="submit-button">
                <button type="submit">프로젝트 생성하기</button>
            </div>
        </form>
    </div>

    <script src="js/registe.js"></script>
</body>
</html>
