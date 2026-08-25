package kr.ac.kopo.board.vo;

import jakarta.validation.constraints.NotEmpty;
import org.hibernate.validator.constraints.Length;

public class BoardVO {

    private int no;

    @Length(min = 2, max = 100)
    private String title;

    private String writer;

    @NotEmpty(message = "필수항목입니다.")
    private String content;

    private int viewCnt;
    private String regDate;
    private int replyCnt;

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getViewCnt() { return viewCnt; }
    public void setViewCnt(int viewCnt) { this.viewCnt = viewCnt; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public int getReplyCnt() { return replyCnt; }
    public void setReplyCnt(int replyCnt) { this.replyCnt = replyCnt; }

    @Override
    public String toString() {
        return "BoardVO{no=" + no + ", title='" + title + "', writer='" + writer + "'}";
    }
}
