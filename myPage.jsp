<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개발자 프로필</title>
    <link rel="stylesheet" href="css/mypage.css">
    <link rel="stylesheet" href="css/navstyles.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="profile-container">
        <div class="profile-header">
            <%
                request.setCharacterEncoding("UTF-8");
                String userEmail = (session != null) ? (String) session.getAttribute("email") : null;

                if (userEmail == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                String name = "";
                String school = "";
                String github = "";
                String techStack = "";

                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234")) {
                    String sql = "SELECT name, school, github, tech_stack FROM MypageTable WHERE email = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        pstmt.setString(1, userEmail);
                        try (ResultSet rs = pstmt.executeQuery()) {
                            if (rs.next()) {
                                name = rs.getString("name");
                                school = rs.getString("school");
                                github = rs.getString("github");
                                techStack = rs.getString("tech_stack");
                            }
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p>데이터베이스 오류 발생: " + e.getMessage() + "</p>");
                }
            %>
            <h1><%= name %>님의 프로필</h1>
            <button class="edit-button" onclick="location.href='mypageEdit.jsp'">수정하기</button>
        </div>
        <div class="profile-info">
            <p><strong>학교:</strong> <%= school %></p>
            <p><strong>GitHub:</strong> 
                <a href="<%= github %>" target="_blank">
                    <%= github != null && !github.isEmpty() ? github : "정보 없음" %>
                </a>
            </p>
            <div class="tech-stack">
                <strong>기술 스택:</strong>
                <ul>
                    <% if (techStack != null && !techStack.isEmpty()) {
                        for (String tech : techStack.split(",")) { %>
                            <li><%= tech %></li>
                    <% } } else { %>
                        <li>등록된 기술 스택이 없습니다.</li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>
