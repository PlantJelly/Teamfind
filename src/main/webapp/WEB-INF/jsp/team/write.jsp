<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팀플 모집 등록</title>
    <style>
        .container { max-width: 700px; margin: 30px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { margin-bottom: 24px; font-size: 20px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 14px; }
        label .required { color: #e74c3c; margin-left: 2px; }
        input[type=text], input[type=number], input[type=date], textarea, select {
            width: 100%; padding: 9px; box-sizing: border-box;
            border: 1px solid #ccc; border-radius: 4px; font-size: 14px;
        }
        textarea { resize: vertical; }
        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .btn-area { display: flex; gap: 10px; margin-top: 24px; }
        .btn { padding: 10px 22px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; }
        .btn-submit { background: #e67e22; color: #fff; }
        .btn-cancel { background: #aaa; color: #fff; }
        .hint { font-size: 12px; color: #999; margin-top: 3px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>팀플 모집 등록</h2>
    <form action="${pageContext.request.contextPath}/team/write" method="post">
        <div class="form-group">
            <label>팀 이름 <span class="required">*</span></label>
            <input type="text" name="title" placeholder="팀 이름을 입력하세요." required maxlength="200"/>
        </div>
        <div class="form-group">
            <label>팀 설명 <span class="required">*</span></label>
            <textarea name="description" rows="4" placeholder="팀 소개, 프로젝트 목적 등을 설명해주세요." required></textarea>
        </div>
        <div class="form-group">
            <label>요구사항</label>
            <textarea name="requirements" rows="3" placeholder="원하는 기술 스택, 역할, 경험 등을 입력하세요."></textarea>
            <div class="hint">예: Spring Boot 경험자, React 가능자 우대</div>
        </div>
        <div class="row-2">
            <div class="form-group">
                <label>최대 인원 <span class="required">*</span></label>
                <input type="number" name="maxMember" min="2" max="20" placeholder="예: 4" required/>
            </div>
            <div></div>
        </div>
        <div class="row-2">
            <div class="form-group">
                <label>신청 마감일</label>
                <input type="date" name="applyDeadline"/>
                <div class="hint">비워두면 마감일 없음</div>
            </div>
            <div class="form-group">
                <label>팀플 마감일</label>
                <input type="date" name="teamDeadline"/>
                <div class="hint">프로젝트 종료 예정일</div>
            </div>
        </div>
        <div class="btn-area">
            <button type="submit" class="btn btn-submit">등록</button>
            <a href="${pageContext.request.contextPath}/team" class="btn btn-cancel">취소</a>
        </div>
    </form>
</div>
</body>
</html>
