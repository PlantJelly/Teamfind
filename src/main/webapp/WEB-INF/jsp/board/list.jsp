<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <style>
        main { padding: 20px; max-width: 960px; margin: 0 auto; }
        h2 { margin-bottom: 16px; }
        table { width: 100%; border-collapse: collapse; background: #fff; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #eee; text-align: left; font-size: 13px; }
        th { background: #1a1a2e; color: #fff; font-weight: normal; }
        tr:hover td { background: #f9f9f9; }
        .search-form { display: flex; gap: 8px; margin-bottom: 16px; }
        select, input[type=text] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; font-size: 13px; }
        .btn { padding: 7px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .btn-search { background: #1a1a2e; color: #fff; }
        .btn-write { background: #333; color: #fff; float: right; margin-bottom: 10px; text-decoration: none;
                     padding: 8px 16px; border-radius: 4px; font-size: 13px; }
        .paging { margin-top: 16px; display: flex; gap: 6px; justify-content: center; }
        .paging a { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; text-decoration: none; color: #333; font-size: 13px; }
        .paging .active { background: #1a1a2e; color: #fff; border-color: #1a1a2e; }
        a { color: #333; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<main>
    <h2>게시판</h2>
    <form class="search-form" action="${pageContext.request.contextPath}/board" method="get">
        <select name="searchType">
            <option value="title"        ${searchType=='title'        ? 'selected' : ''}>제목</option>
            <option value="content"      ${searchType=='content'      ? 'selected' : ''}>내용</option>
            <option value="titleContent" ${searchType=='titleContent' ? 'selected' : ''}>제목+내용</option>
            <option value="writer"       ${searchType=='writer'       ? 'selected' : ''}>작성자</option>
        </select>
        <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력"/>
        <button type="submit" class="btn btn-search">검색</button>
        <a href="${pageContext.request.contextPath}/board" style="line-height:2.2;">전체보기</a>
    </form>
    <c:if test="${not empty loginMember}">
        <a href="${pageContext.request.contextPath}/board/write" class="btn-write">글쓰기</a>
    </c:if>
    <table>
        <thead>
        <tr>
            <th style="width:60px;">번호</th>
            <th>제목</th>
            <th style="width:90px;">작성자</th>
            <th style="width:60px;">조회</th>
            <th style="width:100px;">작성일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="b" items="${boardList}">
            <tr>
                <td>${b.no}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/board/${b.no}">${b.title}</a>
                    <span style="font-size:12px; margin-left:4px;">[${b.replyCnt}]</span>
                </td>
                <td>${b.writer}</td>
                <td>${b.viewCnt}</td>
                <td>${b.regDate}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty boardList}">
            <tr><td colspan="5" style="text-align:center; padding:30px; color:#aaa;">게시글이 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>
    <div class="paging">
        <c:forEach begin="1" end="${totalPage}" var="p">
            <a href="${pageContext.request.contextPath}/board?page=${p}&searchType=${searchType}&keyword=${keyword}"
               class="${p == currentPage ? 'active' : ''}">${p}</a>
        </c:forEach>
    </div>
</main>
</body>
</html>
