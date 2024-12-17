<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="queryExecutor.jsp" %>

<%
  String projectTitle = null;
  String projectIdParam = request.getParameter("id");
  ResultSet rs = null;

  if (projectIdParam == null || projectIdParam.trim().isEmpty()) {
    response.sendRedirect("project-list");
    return;
  }

  try {
    int projectId = Integer.parseInt(projectIdParam);
    rs = selectProject(projectId);  // QueryExecutor의 메소드 직접 사용
    if (rs != null && rs.next()) {
      projectTitle = rs.getString("title");
    }
  } catch (Exception e) {
    projectTitle = "오류가 발생했습니다.";
    e.printStackTrace();
  } finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>프로젝트 지원하기</title>
  <link rel="stylesheet" href="css/navstyles.css">
  <link rel="stylesheet" href="css/projectApply.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<%
  // 세션에서 이메일 가져오기
  String userEmail = (String) session.getAttribute("email");
%>
<div class="form-container">
  <a href="projectDetail.jsp?id=<%= projectIdParam %>" class="back-btn">돌아가기</a>
  <h1><%= projectTitle %></h1>

  <form action="applyAction.jsp" method="post" onsubmit="return validateForm(event)">
    <input type="hidden" name="project_id" value="<%= projectIdParam %>">
    <input type="hidden" name="status" value="지원중">
    <input type="hidden" name="user_email" value="<%= userEmail %>">
    <div class="form-group">
      <label for="apply-field">지원 분야</label>
      <select id="apply-field" name="apply_field">
        <option value="">지원 분야 선택</option>
        <%
          ResultSet recruitRs = null;
          try {
            recruitRs = selectProjectRecruits(Integer.parseInt(projectIdParam));
            while (recruitRs != null && recruitRs.next()) {
        %>
        <option value="<%= recruitRs.getString("recruit_field") %>">
          <%= recruitRs.getString("recruit_field") %>
        </option>
        <%
            }
          } finally {
            if (recruitRs != null) try { recruitRs.close(); } catch (Exception e) {}
          }
        %>
      </select>
    </div>

    <div class="form-group">
      <label for="self-intro">자기 소개</label>
      <textarea id="self-intro" name="self_intro" rows="5" placeholder="자기소개를 입력해주세요"></textarea>
    </div>

    <div class="form-group">
      <label for="tech-stack">보유 기술 스택</label>
      <input type="text" id="tech-stack" name="tech_stack" placeholder="보유하고 계신 기술 스택을 입력해주세요">
    </div>

    <div class="form-group">
      <label for="email">연락 가능한 이메일</label>
      <input type="email" id="email" name="email" placeholder="이메일을 입력해주세요">
    </div>

    <div class="button-group">
      <button type="submit">지원하기</button>
    </div>
  </form>
</div>

<script src="js/projectApply.js"></script>
</body>
</html>
