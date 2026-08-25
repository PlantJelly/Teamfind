package kr.ac.kopo.team.vo;

public class TeamVO {

    private int no;
    private int writerNo;
    private String writer;
    private String title;
    private String description;
    private String requirements;
    private int maxMember;
    private int currentMember;
    private String status;
    private String applyDeadline;
    private String teamDeadline;
    private String regDate;

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public int getWriterNo() { return writerNo; }
    public void setWriterNo(int writerNo) { this.writerNo = writerNo; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }

    public int getMaxMember() { return maxMember; }
    public void setMaxMember(int maxMember) { this.maxMember = maxMember; }

    public int getCurrentMember() { return currentMember; }
    public void setCurrentMember(int currentMember) { this.currentMember = currentMember; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getApplyDeadline() { return applyDeadline; }
    public void setApplyDeadline(String applyDeadline) { this.applyDeadline = applyDeadline; }

    public String getTeamDeadline() { return teamDeadline; }
    public void setTeamDeadline(String teamDeadline) { this.teamDeadline = teamDeadline; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    @Override
    public String toString() {
        return "TeamVO{no=" + no + ", writer='" + writer + "', title='" + title + "', status='" + status + "'}";
    }
}
