package kr.ac.kopo.team.dao;

import kr.ac.kopo.team.vo.TeamApplyVO;
import kr.ac.kopo.team.vo.TeamVO;
import java.util.List;

public interface TeamDAO {

    void insertTeam(TeamVO team);

    List<TeamVO> selectList();

    List<TeamVO> selectListByWriterNo(int writerNo);

    List<TeamApplyVO> selectApplyListByApplicant(int applicantNo);

    TeamVO selectTeamByNo(int teamNo);

    void updateTeamStatus(int teamNo, String status);

    void updateCurrentMember(int teamNo, int delta);

    void updateTeam(TeamVO team);

    void deleteAppliesByTeamNo(int teamNo);

    void deleteTeam(int no);

    void insertApply(TeamApplyVO apply);

    List<TeamApplyVO> selectApplyListByTeam(int teamNo);

    TeamApplyVO selectApplyByNo(int applyNo);

    void updateApplyStatus(int applyNo, String status);

    TeamApplyVO selectMyApply(int teamNo, int memberNo);
}
