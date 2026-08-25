package kr.ac.kopo.member.vo;

import jakarta.validation.constraints.NotEmpty;
import org.hibernate.validator.constraints.Length;

public class MemberVO {

    private int memberNo;

    @NotEmpty(message = "필수항목입니다.")
    @Length(min = 4, max = 20)
    private String memberId;

    @NotEmpty(message = "필수항목입니다.")
    private String memberPwd;

    @NotEmpty(message = "필수항목입니다.")
    private String nickname;

    private String phone;
    private String email;
    private String snsType;
    private String regDate;
    private String role;

    public int getMemberNo() { return memberNo; }
    public void setMemberNo(int memberNo) { this.memberNo = memberNo; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getMemberPwd() { return memberPwd; }
    public void setMemberPwd(String memberPwd) { this.memberPwd = memberPwd; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSnsType() { return snsType; }
    public void setSnsType(String snsType) { this.snsType = snsType; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    @Override
    public String toString() {
        return "MemberVO{memberNo=" + memberNo + ", memberId='" + memberId + "', nickname='" + nickname
                + "', snsType='" + snsType + "', role='" + role + "'}";
    }
}
