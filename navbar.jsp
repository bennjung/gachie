<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String userName = (session != null) ? (String) session.getAttribute("userName") : null;
    System.out.println("DEBUG - navbar userName: " + userName);
%>

<header class = "navbar">
  <div class="logo">
    <a href="main.jsp">가치해요</a>
  </div>
  <nav>
    <a href="registe.jsp">프로젝트 등록</a>
    <a href="projectLists.jsp">프로젝트 찾기</a>
    <a href="myproject.jsp">내 프로젝트</a>
    <% if (userName != null) { %>
        <a href="myPage.jsp">마이페이지</a>
    <% } %>
  </nav>
  <div class="auth-buttons">
    <% if (userName != null) { %>
      <span>환영합니다, <%= userName %>님</span>
      <a href="logout.jsp" class="logout">로그아웃</a>
    <% } else { %>
      <a href="login.jsp" class="login">로그인</a>
      <a href="signup.jsp" class="signup">회원가입</a>
    <% } %>
  </div>
</header>
