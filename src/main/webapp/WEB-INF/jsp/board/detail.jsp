<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${board.title}</title>
    <style>
        main { padding: 20px; max-width: 860px; margin: 0 auto; }
        .board-header { border-bottom: 2px solid #1a1a2e; padding-bottom: 10px; margin-bottom: 16px; }
        .board-header h2 { font-size: 20px; margin-bottom: 6px; }
        .board-meta { color: #777; font-size: 13px; }
        .board-content { min-height: 120px; padding: 16px 0; border-bottom: 1px solid #eee; white-space: pre-wrap; font-size: 14px; line-height: 1.7; }
        .btn-area { display: flex; gap: 8px; margin: 12px 0; }
        .btn { padding: 7px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; text-decoration: none; }
        .btn-edit   { background: #555; color: #fff; }
        .btn-delete { background: #c00; color: #fff; }
        .btn-back   { background: #aaa; color: #fff; }
        .reply-section { margin-top: 24px; }
        .reply-section h3 { font-size: 15px; border-bottom: 1px solid #eee; padding-bottom: 8px; margin-bottom: 12px; }
        .reply-item { padding: 10px 0; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
        .reply-meta { font-size: 12px; color: #aaa; margin-top: 4px; }
        .reply-form { display: flex; gap: 8px; margin-top: 12px; }
        .reply-form textarea { flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; resize: none; font-size: 13px; }
        .reply-form button { padding: 8px 16px; background: #333; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
        .child-form { display: none; margin-top: 6px; }
        .child-form textarea { width: calc(100% - 80px); padding: 6px; border: 1px solid #ccc; border-radius: 4px; resize: none; font-size: 12px; }
        .child-form button { padding: 6px 12px; background: #555; color: #fff; border: none; border-radius: 4px; cursor: pointer; margin-left: 6px; font-size: 12px; }
        .reply-btn-sm { font-size: 11px; color: #999; cursor: pointer; margin-left: 8px; background: none; border: none; padding: 0; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<main>
    <div class="board-header">
        <h2>${board.title}</h2>
        <div class="board-meta">
            작성자: ${board.writer} &nbsp;|&nbsp; 조회수: ${board.viewCnt} &nbsp;|&nbsp; 작성일: ${board.regDate}
        </div>
    </div>

    <div class="board-content">${board.content}</div>

    <div class="btn-area">
        <a href="${pageContext.request.contextPath}/board" class="btn btn-back">목록</a>
        <c:if test="${not empty loginMember and loginMember.nickname == board.writer}">
            <a href="${pageContext.request.contextPath}/board/${board.no}/edit" class="btn btn-edit">수정</a>
            <form action="${pageContext.request.contextPath}/board/${board.no}" method="post" style="display:inline;"
                  onsubmit="return confirm('삭제하시겠습니까?')">
                <input type="hidden" name="_method" value="DELETE"/>
                <button type="submit" class="btn btn-delete">삭제</button>
            </form>
        </c:if>
    </div>

    <div class="reply-section">
        <h3>댓글</h3>
        <div id="replyContainer"></div>
        <c:if test="${not empty loginMember}">
            <div class="reply-form">
                <textarea id="replyContent" placeholder="댓글을 입력하세요." rows="2"></textarea>
                <button onclick="submitReply()">등록</button>
            </div>
        </c:if>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() { loadReplies(); });

    var ctx = '${pageContext.request.contextPath}';
    var boardNo = ${board.no};
    var loginNickname = '<c:out value="${loginMember.nickname}" default=""/>';

    function loadReplies() {
        fetch(ctx + '/reply/' + boardNo)
            .then(function(r) { return r.json(); })
            .then(function(list) { renderReplies(list); });
    }

    function renderReplies(list) {
        var container = document.getElementById('replyContainer');
        if (list.length === 0) {
            container.innerHTML = '<p style="color:#aaa;font-size:13px;">댓글이 없습니다.</p>';
            return;
        }

        // 트리 빌드
        var map = {};
        list.forEach(function(r) { map[r.no] = r; r._children = []; });
        var roots = [];
        list.forEach(function(r) {
            if (r.parentNo === 0) {
                roots.push(r);
            } else if (map[r.parentNo]) {
                map[r.parentNo]._children.push(r);
            } else {
                roots.push(r);
            }
        });

        // DFS 순회로 평탄화
        var ordered = [];
        function dfs(nodes) {
            nodes.forEach(function(r) { ordered.push(r); dfs(r._children); });
        }
        dfs(roots);

        container.innerHTML = ordered.map(function(r) {
            var indent = r.depth * 24;
            var prefix = r.depth > 0 ? '↳ ' : '';
            var myReply = loginNickname && loginNickname === r.writer;
            return '<div class="reply-item" id="reply-' + r.no + '" style="padding-left:' + indent + 'px;">'
                + prefix
                + '<strong>' + escHtml(r.writer) + '</strong>: '
                + '<span id="reply-content-' + r.no + '">' + escHtml(r.content) + '</span>'
                + '<div class="reply-meta">' + r.regDate
                + (loginNickname ? ' <button class="reply-btn-sm" onclick="toggleChildForm(' + r.no + ')">답글</button>' : '')
                + (myReply ? ' <button class="reply-btn-sm" onclick="editReply(' + r.no + ')">수정</button>'
                           + ' <button class="reply-btn-sm" onclick="deleteReply(' + r.no + ')">삭제</button>' : '')
                + '</div>'
                + '<div class="child-form" id="child-form-' + r.no + '" style="padding-left:24px;">'
                + '<textarea id="child-content-' + r.no + '" rows="2" placeholder="답글을 입력하세요."></textarea>'
                + '<button onclick="submitChild(' + r.no + ',' + (r.depth + 1) + ')">등록</button>'
                + '</div>'
                + '</div>';
        }).join('');
    }

    function escHtml(str) {
        return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    function submitReply() {
        var content = document.getElementById('replyContent').value.trim();
        if (!content) { alert('댓글을 입력하세요.'); return; }
        fetch(ctx + '/reply/' + boardNo, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: content })
        }).then(function() {
            document.getElementById('replyContent').value = '';
            loadReplies();
        });
    }

    function toggleChildForm(parentNo, depth) {
        var el = document.getElementById('child-form-' + parentNo);
        el.style.display = el.style.display === 'block' ? 'none' : 'block';
    }

    function submitChild(parentNo, depth) {
        var content = document.getElementById('child-content-' + parentNo).value.trim();
        if (!content) { alert('답글을 입력하세요.'); return; }
        fetch(ctx + '/reply/' + boardNo + '/child/' + parentNo, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: content, depth: depth })
        }).then(function() { loadReplies(); });
    }

    function deleteReply(replyNo) {
        if (!confirm('삭제하시겠습니까?')) return;
        fetch(ctx + '/reply/' + replyNo, { method: 'DELETE' }).then(function() { loadReplies(); });
    }

    function editReply(replyNo) {
        var span = document.getElementById('reply-content-' + replyNo);
        var old = span.textContent;
        span.innerHTML = '<input type="text" id="edit-input-' + replyNo + '" value="' + escHtml(old) + '" style="width:65%"/>'
            + '<button onclick="saveReply(' + replyNo + ')">저장</button>'
            + '<button onclick="loadReplies()">취소</button>';
    }

    function saveReply(replyNo) {
        var content = document.getElementById('edit-input-' + replyNo).value.trim();
        if (!content) return;
        fetch(ctx + '/reply/' + replyNo, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: content })
        }).then(function() { loadReplies(); });
    }
</script>
</body>
</html>
