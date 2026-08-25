package kr.ac.kopo.team.service;

import kr.ac.kopo.team.vo.TeamApplyVO;
import kr.ac.kopo.team.vo.TeamVO;
import java.util.List;

public interface TeamService {

    void insertTeam(TeamVO team);

    List<TeamVO> selectList();

    List<TeamVO> selectListByWriterNo(int writerNo);

    List<TeamApplyVO> selectApplyListByApplicant(int applicantNo);

    TeamVO selectTeamByNo(int teamNo);

    void updateTeamStatus(int teamNo, String status);

    void updateTeam(TeamVO team);

    void deleteTeam(int no);

    void applyTeam(TeamApplyVO apply, int teamWriterNo, String applicantNickname);

    List<TeamApplyVO> selectApplyListByTeam(int teamNo);

    TeamApplyVO selectApplyByNo(int applyNo);

    void approveApply(int applyNo, int teamNo);

    void rejectApply(int applyNo, int teamNo);

    TeamApplyVO selectMyApply(int teamNo, int memberNo);
}
