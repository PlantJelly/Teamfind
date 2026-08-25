<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 목록 (관리자)</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h2 { margin-bottom: 16px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background: #333; color: #fff; }
        tr:nth-child(even) { background: #f9f9f9; }
        .paging { margin-top: 16px; display: flex; gap: 6px; }
        .paging a { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; text-decoration: none; color: #333; }
        .paging .active { background: #333; color: #fff; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div style="padding: 20px;">
<h2>회원 목록 (관리자)</h2>
<table>
    <thead>
    <tr>
        <th>회원번호</th>
        <th>아이디</th>
        <th>닉네임</th>
        <th>전화번호</th>
        <th>이메일</th>
        <th>SNS여부</th>
        <th>역할</th>
        <th>가입일</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="m" items="${memberList}">
        <tr>
            <td>${m.memberNo}</td>
            <td>${m.memberId}</td>
            <td>${m.nickname}</td>
            <td>${m.phone}</td>
            <td>${m.email}</td>
            <td>${empty m.snsType ? '일반' : m.snsType}</td>
            <td>${m.role}</td>
            <td>${m.regDate}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div class="paging">
    <c:forEach begin="1" end="${totalPage}" var="p">
        <a href="${pageContext.request.contextPath}/admin/members?page=${p}" class="${p == currentPage ? 'active' : ''}">${p}</a>
    </c:forEach>
</div>
<p><a href="${pageContext.request.contextPath}/">← 메인으로</a></p>
</div>
</body>
</html>
