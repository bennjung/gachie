<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 페이지</title>
    <link rel="stylesheet" href="css/navstyles.css">
    <link rel="stylesheet" href="css/signup.css">
    
    <script>
        function showAlert(message) {
            alert(message); // 경고 창 띄우기
        }
    </script>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="signup-container">
        <div class="signup-header">
            <a href="login.jsp">로그인</a>
            <a href="signup.jsp" class="active">회원가입</a>
        </div>
        <form action="signup.jsp" method="POST">
            <div class="input-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" placeholder="이메일을 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="confirm-password">비밀번호 확인</label>
                <input type="password" id="confirm-password" name="confirm_password" placeholder="비밀번호를 다시 입력하세요" required>
            </div>
            <button type="submit" class="signup-btn">회원가입</button>
        </form>

        <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");

            if (!password.equals(confirmPassword)) {
                // 비밀번호 불일치 시 경고 창 표시
        %>
                <script>
                    showAlert("비밀번호가 일치하지 않습니다.");
                </script>
        <%
            } else {
                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    // 데이터베이스 연결
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");

                    // 이메일 중복 확인
                    String checkSql = "SELECT COUNT(*) FROM MypageTable WHERE email = ?";
                    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                        checkStmt.setString(1, email);
                        ResultSet rs = checkStmt.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) {
                            // 중복 이메일 시 경고 창 표시
        %>
                            <script>
                                showAlert("이미 사용 중인 이메일입니다.");
                            </script>
        <%
                            return;
                        }
                    }

                    // 데이터 삽입 쿼리
                    String sql = "INSERT INTO MypageTable (email, password, name, school, github) VALUES (?, ?, ?, NULL, NULL)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, email);
                    pstmt.setString(2, password); // 비밀번호는 해시화하는 것이 좋습니다.
                    pstmt.setString(3, email);

                    int result = pstmt.executeUpdate();

                    if (result > 0) {
                        // 회원가입 성공 시 로그인 페이지로 리디렉션
                        response.sendRedirect("login.jsp");
                    } else {
        %>
                        <script>
                            showAlert("회원가입에 실패했습니다. 다시 시도해주세요.");
                        </script>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
        %>
                    <script>
                        showAlert("서버 오류가 발생했습니다. 관리자에게 문의하세요.");
                    </script>
        <%
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            }
        }
        %>
    </div>
</body>
</html>
