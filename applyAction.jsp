<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="queryExecutor.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 폼에서 전송된 데이터 받기
    String projectId = request.getParameter("project_id");
    String userEmail = request.getParameter("user_email");
    String role = "Member";
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = getConnection();
        String sql = "INSERT INTO user_projects (user_email, project_id, role, status) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, userEmail);
        pstmt.setInt(2, Integer.parseInt(projectId));
        pstmt.setString(3, role);
        pstmt.setString(4, status);

        // 쿼리 실행
        pstmt.executeUpdate();

        // 성공 시 상세 페이지로 리다이렉트
        response.sendRedirect("projectDetail.jsp?id=" + projectId + "&success=true");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("projectDetail.jsp?id=" + projectId + "&error=true");
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>