<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 700px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type=text], textarea { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        textarea { height: 200px; resize: vertical; }
        .btn-primary { background: #333; color: #fff; padding: 10px 24px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-cancel { background: #aaa; color: #fff; padding: 10px 24px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .btn-area { display: flex; gap: 10px; margin-top: 16px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>게시글 수정</h2>
    <form action="${pageContext.request.contextPath}/board/${board.no}" method="post">
        <input type="hidden" name="_method" value="PUT"/>
        <div class="form-group">
            <label>제목</label>
            <input type="text" name="title" value="${board.title}" required/>
        </div>
        <div class="form-group">
            <label>내용</label>
            <textarea name="content" required>${board.content}</textarea>
        </div>
        <div class="form-group">
            <label>
                <input type="checkbox" name="isTeamPost" value="Y" ${board.isTeamPost == 'Y' ? 'checked' : ''}/>
                팀플 모집글
            </label>
        </div>
        <div class="btn-area">
            <button type="submit" class="btn-primary">수정 완료</button>
            <a href="${pageContext.request.contextPath}/board/${board.no}" class="btn-cancel">취소</a>
        </div>
    </form>
</div>
</body>
</html>
