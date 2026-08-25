package kr.ac.kopo.team.vo;

public class TeamApplyVO {

    private int no;
    private int teamNo;
    private String teamTitle;
    private int applicantNo;
    private String applicantId;
    private String applyContent;
    private String applyStatus;
    private String regDate;

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public int getTeamNo() { return teamNo; }
    public void setTeamNo(int teamNo) { this.teamNo = teamNo; }

    public String getTeamTitle() { return teamTitle; }
    public void setTeamTitle(String teamTitle) { this.teamTitle = teamTitle; }

    public int getApplicantNo() { return applicantNo; }
    public void setApplicantNo(int applicantNo) { this.applicantNo = applicantNo; }

    public String getApplicantId() { return applicantId; }
    public void setApplicantId(String applicantId) { this.applicantId = applicantId; }

    public String getApplyContent() { return applyContent; }
    public void setApplyContent(String applyContent) { this.applyContent = applyContent; }

    public String getApplyStatus() { return applyStatus; }
    public void setApplyStatus(String applyStatus) { this.applyStatus = applyStatus; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    @Override
    public String toString() {
        return "TeamApplyVO{no=" + no + ", teamNo=" + teamNo + ", applicantId='" + applicantId
                + "', applyStatus='" + applyStatus + "'}";
    }
}
