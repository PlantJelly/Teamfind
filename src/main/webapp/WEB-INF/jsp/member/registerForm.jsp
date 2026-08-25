<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 480px; margin: 60px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { text-align: center; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type=text], input[type=password] { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        input[readonly] { background: #f0f0f0; color: #888; cursor: not-allowed; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary { background: #333; color: #fff; width: 100%; padding: 10px; font-size: 15px; }
        .btn-check { background: #777; color: #fff; margin-left: 6px; }
        .error { color: red; font-size: 12px; }
        .success { color: green; font-size: 12px; }
        .id-row { display: flex; align-items: center; }
        .id-row input { flex: 1; }
        a { color: #333; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>회원가입</h2>
    <c:if test="${not empty idError}">
        <div class="error">${idError}</div>
    </c:if>
    <form:form action="${pageContext.request.contextPath}/member/register" method="post" modelAttribute="memberVO">
        <div class="form-group">
            <label>아이디</label>
            <div class="id-row">
                <form:input path="memberId" id="memberId"/>
                <button type="button" id="idCheckBtn" class="btn btn-check">중복확인</button>
            </div>
            <form:errors path="memberId" cssClass="error"/>
            <span id="idCheckResult"></span>
        </div>
        <div class="form-group">
            <label>비밀번호</label>
            <form:password path="memberPwd"/>
            <form:errors path="memberPwd" cssClass="error"/>
        </div>
        <div class="form-group">
            <label>닉네임</label>
            <form:input path="nickname"/>
            <form:errors path="nickname" cssClass="error"/>
        </div>
        <div class="form-group">
            <label>전화번호</label>
            <form:input path="phone"/>
        </div>
        <div class="form-group">
            <label>이메일</label>
            <form:input path="email"/>
        </div>
        <button type="submit" class="btn btn-primary">회원가입</button>
    </form:form>
    <p style="text-align:center; margin-top:16px;"><a href="${pageContext.request.contextPath}/member/login">이미 계정이 있으신가요? 로그인</a></p>
</div>
<script>
    const ctx = '${pageContext.request.contextPath}';
    let idChecked = false;

    function checkId() {
        const memberIdInput = document.getElementById('memberId');
        const memberId = memberIdInput.value.trim();
        if (!memberId) { alert('아이디를 입력하세요.'); return; }
        fetch(ctx + '/member/checkId?memberId=' + encodeURIComponent(memberId))
            .then(r => r.json())
            .then(data => {
                const el = document.getElementById('idCheckResult');
                const btn = document.getElementById('idCheckBtn');
                if (data.available) {
                    el.textContent = '사용 가능한 아이디입니다.';
                    el.className = 'success';
                    idChecked = true;
                    memberIdInput.readOnly = true;
                    btn.textContent = '변경';
                    btn.style.background = '#e67e22';
                    btn.onclick = resetIdCheck;
                } else {
                    el.textContent = '이미 사용 중인 아이디입니다.';
                    el.className = 'error';
                    idChecked = false;
                }
            });
    }

    function resetIdCheck() {
        const memberIdInput = document.getElementById('memberId');
        const btn = document.getElementById('idCheckBtn');
        memberIdInput.readOnly = false;
        memberIdInput.focus();
        idChecked = false;
        document.getElementById('idCheckResult').textContent = '';
        btn.textContent = '중복확인';
        btn.style.background = '';
        btn.onclick = checkId;
    }

    document.getElementById('idCheckBtn').onclick = checkId;

    document.querySelector('form').addEventListener('submit', function(e) {
        if (!idChecked) {
            e.preventDefault();
            alert('아이디 중복확인을 해주세요.');
            document.getElementById('memberId').focus();
        }
    });
</script>
</body>
</html>
