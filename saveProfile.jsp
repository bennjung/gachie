<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userEmail = (session != null) ? (String) session.getAttribute("email") : null;

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = request.getParameter("name");
    String school = request.getParameter("school");
    String github = request.getParameter("github");
    String techStack = request.getParameter("techStack");

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234")) {
        String sql = "UPDATE MypageTable SET name = ?, school = ?, github = ?, tech_stack = ? WHERE email = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, school);
            pstmt.setString(3, github);
            pstmt.setString(4, techStack);
            pstmt.setString(5, userEmail);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("myPage.jsp?success=true");
            } else {
                out.println("<p>프로필 업데이트 실패</p>");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>오류 발생: " + e.getMessage() + "</p>");
    }
%>
