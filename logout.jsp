<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // 기존 세션 무효화
    if (session != null) { // JSP 기본 내장 객체 session 사용
        session.invalidate(); // 세션 무효화
    }

    // 로그인 페이지로 리다이렉트
    response.sendRedirect("login.jsp");
%>
