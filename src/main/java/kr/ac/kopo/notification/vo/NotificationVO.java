package kr.ac.kopo.notification.vo;

public class NotificationVO {

    private int no;
    private int receiverNo;
    private String message;
    private String isRead;
    private String regDate;
    private int relatedBoardNo;
    private int relatedTeamNo;

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public int getReceiverNo() { return receiverNo; }
    public void setReceiverNo(int receiverNo) { this.receiverNo = receiverNo; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getIsRead() { return isRead; }
    public void setIsRead(String isRead) { this.isRead = isRead; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public int getRelatedBoardNo() { return relatedBoardNo; }
    public void setRelatedBoardNo(int relatedBoardNo) { this.relatedBoardNo = relatedBoardNo; }

    public int getRelatedTeamNo() { return relatedTeamNo; }
    public void setRelatedTeamNo(int relatedTeamNo) { this.relatedTeamNo = relatedTeamNo; }

    @Override
    public String toString() {
        return "NotificationVO{no=" + no + ", receiverNo=" + receiverNo + ", isRead='" + isRead + "'}";
    }
}
