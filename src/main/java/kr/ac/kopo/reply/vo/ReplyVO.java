package kr.ac.kopo.reply.vo;

public class ReplyVO {

    private int no;
    private int boardNo;
    private int parentNo;
    private String content;
    private String writer;
    private String regDate;
    private int depth;

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public int getBoardNo() { return boardNo; }
    public void setBoardNo(int boardNo) { this.boardNo = boardNo; }

    public int getParentNo() { return parentNo; }
    public void setParentNo(int parentNo) { this.parentNo = parentNo; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public int getDepth() { return depth; }
    public void setDepth(int depth) { this.depth = depth; }

    @Override
    public String toString() {
        return "ReplyVO{no=" + no + ", boardNo=" + boardNo + ", parentNo=" + parentNo
                + ", depth=" + depth + ", writer='" + writer + "'}";
    }
}
