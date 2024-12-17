<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/navstyles.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="login-container">
        <div class="login-header">
            <a href="login.jsp" class="active">로그인</a>
            <a href="signup.jsp">회원가입</a>
        </div>

        <% 
            String errorMessage = null;

            // 로그인 로직
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");

                    String sql = "SELECT name FROM MypageTable WHERE email = ? AND password = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, email);
                    pstmt.setString(2, password);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String name = rs.getString("name");

                        // 내장 session 객체 사용
                        session.setMaxInactiveInterval(15 * 60); // 15분 유지
                        session.setAttribute("userName", name);
                        session.setAttribute("email", email);

                        response.sendRedirect("main.jsp");
                        return;
                    } else {
                        errorMessage = "아이디 또는 비밀번호가 잘못되었습니다.";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    errorMessage = "서버 오류가 발생했습니다. 다시 시도해주세요.";
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            }
        %>

        <% if (errorMessage != null) { %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% } %>

        <form method="post" action="login.jsp">
            <div class="input-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" placeholder="이메일을 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>
            <button type="submit" class="login-btn">로그인</button>
        </form>
    </div>
</body>
</html>
