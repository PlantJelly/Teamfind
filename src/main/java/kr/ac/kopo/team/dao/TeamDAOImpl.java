package kr.ac.kopo.team.dao;

import kr.ac.kopo.team.vo.TeamApplyVO;
import kr.ac.kopo.team.vo.TeamVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class TeamDAOImpl implements TeamDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public void insertTeam(TeamVO team) {
        sqlSessionTemplate.insert("team.dao.TeamDAO.insertTeam", team);
    }

    @Override
    public List<TeamVO> selectList() {
        return sqlSessionTemplate.selectList("team.dao.TeamDAO.selectList");
    }

    @Override
    public List<TeamVO> selectListByWriterNo(int writerNo) {
        return sqlSessionTemplate.selectList("team.dao.TeamDAO.selectListByWriterNo", writerNo);
    }

    @Override
    public List<TeamApplyVO> selectApplyListByApplicant(int applicantNo) {
        return sqlSessionTemplate.selectList("team.dao.TeamDAO.selectApplyListByApplicant", applicantNo);
    }

    @Override
    public TeamVO selectTeamByNo(int teamNo) {
        return sqlSessionTemplate.selectOne("team.dao.TeamDAO.selectTeamByNo", teamNo);
    }

    @Override
    public void updateTeamStatus(int teamNo, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("teamNo", teamNo);
        params.put("status", status);
        sqlSessionTemplate.update("team.dao.TeamDAO.updateTeamStatus", params);
    }

    @Override
    public void updateCurrentMember(int teamNo, int delta) {
        Map<String, Object> params = new HashMap<>();
        params.put("teamNo", teamNo);
        params.put("delta", delta);
        sqlSessionTemplate.update("team.dao.TeamDAO.updateCurrentMember", params);
    }

    @Override
    public void insertApply(TeamApplyVO apply) {
        sqlSessionTemplate.insert("team.dao.TeamDAO.insertApply", apply);
    }

    @Override
    public List<TeamApplyVO> selectApplyListByTeam(int teamNo) {
        return sqlSessionTemplate.selectList("team.dao.TeamDAO.selectApplyListByTeam", teamNo);
    }

    @Override
    public TeamApplyVO selectApplyByNo(int applyNo) {
        return sqlSessionTemplate.selectOne("team.dao.TeamDAO.selectApplyByNo", applyNo);
    }

    @Override
    public void updateApplyStatus(int applyNo, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("applyNo", applyNo);
        params.put("status", status);
        sqlSessionTemplate.update("team.dao.TeamDAO.updateApplyStatus", params);
    }

    @Override
    public void updateTeam(TeamVO team) {
        sqlSessionTemplate.update("team.dao.TeamDAO.updateTeam", team);
    }

    @Override
    public void deleteAppliesByTeamNo(int teamNo) {
        sqlSessionTemplate.delete("team.dao.TeamDAO.deleteAppliesByTeamNo", teamNo);
    }

    @Override
    public void deleteTeam(int no) {
        sqlSessionTemplate.delete("team.dao.TeamDAO.deleteTeam", no);
    }

    @Override
    public TeamApplyVO selectMyApply(int teamNo, int memberNo) {
        Map<String, Integer> params = new HashMap<>();
        params.put("teamNo", teamNo);
        params.put("memberNo", memberNo);
        return sqlSessionTemplate.selectOne("team.dao.TeamDAO.selectMyApply", params);
    }
}
