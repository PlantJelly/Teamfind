<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 480px; margin: 60px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type=text] { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn-primary { background: #333; color: #fff; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-cancel { background: #aaa; color: #fff; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .btn-area { display: flex; gap: 10px; margin-top: 20px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>회원정보 수정</h2>
    <form action="${pageContext.request.contextPath}/member/edit" method="post">
        <div class="form-group">
            <label>아이디</label>
            <input type="text" value="${member.memberId}" readonly style="background:#eee;"/>
        </div>
        <div class="form-group">
            <label>닉네임</label>
            <input type="text" name="nickname" value="${member.nickname}" required/>
        </div>
        <div class="form-group">
            <label>전화번호</label>
            <input type="text" name="phone" value="${member.phone}"/>
        </div>
        <div class="form-group">
            <label>이메일</label>
            <input type="text" name="email" value="${member.email}"/>
        </div>
        <div class="btn-area">
            <button type="submit" class="btn-primary">수정 완료</button>
            <a href="${pageContext.request.contextPath}/member/myPage" class="btn-cancel">취소</a>
        </div>
    </form>
</div>
</body>
</html>
