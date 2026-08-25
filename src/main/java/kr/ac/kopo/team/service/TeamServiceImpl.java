package kr.ac.kopo.team.service;

import kr.ac.kopo.notification.dao.NotificationDAO;
import kr.ac.kopo.notification.service.NotificationService;
import kr.ac.kopo.notification.vo.NotificationVO;
import kr.ac.kopo.team.dao.TeamDAO;
import kr.ac.kopo.team.vo.TeamApplyVO;
import kr.ac.kopo.team.vo.TeamVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeamServiceImpl implements TeamService {

    @Autowired
    private TeamDAO teamDAO;

    @Autowired
    private NotificationDAO notificationDAO;

    @Autowired
    private NotificationService notificationService;

    @Override
    public void insertTeam(TeamVO team) {
        teamDAO.insertTeam(team);
    }

    @Override
    public List<TeamVO> selectList() {
        return teamDAO.selectList();
    }

    @Override
    public List<TeamVO> selectListByWriterNo(int writerNo) {
        return teamDAO.selectListByWriterNo(writerNo);
    }

    @Override
    public List<TeamApplyVO> selectApplyListByApplicant(int applicantNo) {
        return teamDAO.selectApplyListByApplicant(applicantNo);
    }

    @Override
    public TeamVO selectTeamByNo(int teamNo) {
        return teamDAO.selectTeamByNo(teamNo);
    }

    @Override
    public void updateTeamStatus(int teamNo, String status) {
        teamDAO.updateTeamStatus(teamNo, status);
    }

    @Override
    public void updateTeam(TeamVO team) {
        teamDAO.updateTeam(team);
    }

    @Override
    public void deleteTeam(int no) {
        notificationDAO.deleteByTeamNo(no);
        teamDAO.deleteAppliesByTeamNo(no);
        teamDAO.deleteTeam(no);
    }

    @Override
    public void applyTeam(TeamApplyVO apply, int teamWriterNo, String applicantNickname) {
        teamDAO.insertApply(apply);

        TeamVO team = teamDAO.selectTeamByNo(apply.getTeamNo());
        NotificationVO noti = new NotificationVO();
        noti.setReceiverNo(teamWriterNo);
        noti.setMessage(applicantNickname + "님이 '" + team.getTitle() + "' 에 팀플 신청을 했습니다.");
        noti.setRelatedTeamNo(team.getNo());
        notificationService.insertNotification(noti);
    }

    @Override
    public List<TeamApplyVO> selectApplyListByTeam(int teamNo) {
        return teamDAO.selectApplyListByTeam(teamNo);
    }

    @Override
    public TeamApplyVO selectApplyByNo(int applyNo) {
        return teamDAO.selectApplyByNo(applyNo);
    }

    @Override
    public void approveApply(int applyNo, int teamNo) {
        teamDAO.updateApplyStatus(applyNo, "APPROVED");
        teamDAO.updateCurrentMember(teamNo, 1);

        TeamApplyVO apply = teamDAO.selectApplyByNo(applyNo);
        TeamVO team = teamDAO.selectTeamByNo(teamNo);

        NotificationVO noti = new NotificationVO();
        noti.setReceiverNo(apply.getApplicantNo());
        noti.setMessage("'" + team.getTitle() + "' 팀플 신청이 승인되었습니다.");
        noti.setRelatedTeamNo(team.getNo());
        notificationService.insertNotification(noti);
    }

    @Override
    public void rejectApply(int applyNo, int teamNo) {
        teamDAO.updateApplyStatus(applyNo, "REJECTED");

        TeamApplyVO apply = teamDAO.selectApplyByNo(applyNo);
        TeamVO team = teamDAO.selectTeamByNo(teamNo);

        NotificationVO noti = new NotificationVO();
        noti.setReceiverNo(apply.getApplicantNo());
        noti.setMessage("'" + team.getTitle() + "' 팀플 신청이 반려되었습니다.");
        noti.setRelatedTeamNo(team.getNo());
        notificationService.insertNotification(noti);
    }

    @Override
    public TeamApplyVO selectMyApply(int teamNo, int memberNo) {
        return teamDAO.selectMyApply(teamNo, memberNo);
    }
}
