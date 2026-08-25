<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
    <style>
        .container { max-width: 700px; margin: 30px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; font-size: 14px; }
        input[type=text], textarea { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        textarea { height: 200px; resize: vertical; }
        .btn-primary { background: #333; color: #fff; padding: 10px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn-cancel { background: #aaa; color: #fff; padding: 10px 24px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 14px; }
        .error { color: red; font-size: 12px; }
        .btn-area { display: flex; gap: 10px; margin-top: 16px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>게시글 작성</h2>
    <form:form action="${pageContext.request.contextPath}/board/write" method="post" modelAttribute="boardVO">
        <div class="form-group">
            <label>제목</label>
            <form:input path="title" placeholder="제목을 입력하세요 (2~100자)"/>
            <form:errors path="title" cssClass="error"/>
        </div>
        <div class="form-group">
            <label>내용</label>
            <form:textarea path="content" placeholder="내용을 입력하세요."/>
            <form:errors path="content" cssClass="error"/>
        </div>
        <div class="btn-area">
            <button type="submit" class="btn-primary">등록</button>
            <a href="${pageContext.request.contextPath}/board" class="btn-cancel">취소</a>
        </div>
    </form:form>
</div>
</body>
</html>
