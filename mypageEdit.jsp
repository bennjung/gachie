<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로필 수정</title>
    <link rel="stylesheet" href="css/navstyles.css">
    <link rel="stylesheet" href="css/mypageEdit.css">
    
    <script>

        function updatePreview() {
            const name = document.getElementById("name").value || "이름 없음";
            const school = document.getElementById("school").value || "학교 정보 없음";
            const github = document.getElementById("github").value || "GitHub 정보 없음";
            const techStack = Array.from(document.querySelectorAll("#field-list .tag-item span"))
                                   .map(tag => tag.textContent).join(", ") || "기술 스택 없음";

            document.getElementById("preview-name").textContent = name;
            document.getElementById("preview-school").textContent = school;
            document.getElementById("preview-github").textContent = github;
            document.getElementById("preview-tech-stack").textContent = techStack;
        }

        function addField() {
            const inputField = document.getElementById("field-input");
            const fieldValue = inputField.value.trim();

            if (fieldValue) {
                const tagItem = document.createElement("div");
                tagItem.classList.add("tag-item");

                const tagName = document.createElement("span");
                tagName.textContent = fieldValue;

                const deleteButton = document.createElement("button");
                deleteButton.innerHTML = "&times;";
                deleteButton.classList.add("delete-btn");
                deleteButton.onclick = function () {
                    tagItem.remove();
                    updatePreview();
                };

                tagItem.appendChild(tagName);
                tagItem.appendChild(deleteButton);
                document.getElementById("field-list").appendChild(tagItem);
                inputField.value = '';
                updatePreview();
            } else {
                alert("내용을 입력해주세요!");
            }
        }

        function useExampleTag(value) {
            const inputField = document.getElementById("field-input");
            inputField.value = value;
            addField();
        }
    </script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <div class="profile-container">
        <h1>프로필 수정</h1>
        <%
            request.setCharacterEncoding("UTF-8");
            String userEmail = (session != null) ? (String) session.getAttribute("email") : null;

            if (userEmail == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String name = "이름 없음";
            String school = "학교 정보 없음";
            String github = "GitHub 정보 없음";
            String techStack = "";

            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/MakeWebDB?characterEncoding=UTF-8&useUnicode=true", 
                    "me", 
                    "1234")) {
                String sql = "SELECT name, school, github, tech_stack FROM MypageTable WHERE email = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, userEmail);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            name = rs.getString("name") != null ? rs.getString("name") : "이름 없음";
                            school = rs.getString("school") != null ? rs.getString("school") : "학교 정보 없음";
                            github = rs.getString("github") != null ? rs.getString("github") : "GitHub 정보 없음";
                            techStack = rs.getString("tech_stack") != null ? rs.getString("tech_stack") : "";
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>데이터베이스 오류 발생: " + e.getMessage() + "</p>");
            }
        %>
        <form action="saveProfile.jsp" method="post">
            <label for="name">이름:</label>
            <input type="text" id="name" name="name" value="<%= name %>" required oninput="updatePreview()">

            <label for="school">학교:</label>
            <input type="text" id="school" name="school" value="<%= school %>" required oninput="updatePreview()">

            <label for="github">GitHub:</label>
            <input type="text" id="github" name="github" value="<%= github %>" oninput="updatePreview()">

            <label>기술 스택:</label>
            <div class="input-group">
                <input type="text" id="field-input" placeholder="기술 스택을 입력 후 Enter">
                <button type="button" onclick="addField()">추가</button>
            </div>
            <div id="field-list" class="tag-container">
                <% if (techStack != null && !techStack.isEmpty()) {
                    for (String tech : techStack.split(",")) { %>
                        <div class="tag-item">
                            <span><%= tech %></span>
                            <button type="button" class="delete-btn" onclick="this.parentElement.remove(); updatePreview();">&times;</button>
                        </div>
                <% } } %>
            </div>
            <input type="hidden" id="techStackInput" name="techStack" value="<%= techStack %>">

            <button type="submit" class="save-button">저장</button>
            <button type="button" onclick="location.href='myPage.jsp'" class="cancel-button">취소</button>
        </form>

        <h2>미리보기</h2>
        <div class="preview-container">
            <p><strong>이름:</strong> <span id="preview-name"><%= name %></span></p>
            <p><strong>학교:</strong> <span id="preview-school"><%= school %></span></p>
            <p><strong>GitHub:</strong> <span id="preview-github"><%= github %></span></p>
            <p><strong>기술 스택:</strong> <span id="preview-tech-stack"><%= techStack.isEmpty() ? "기술 스택 없음" : techStack %></span></p>
        </div>
    </div>
</body>
</html>
