package kr.ac.kopo.notification.dao;

import kr.ac.kopo.notification.vo.NotificationVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class NotificationDAOImpl implements NotificationDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public void insertNotification(NotificationVO notification) {
        sqlSessionTemplate.insert("notification.dao.NotificationDAO.insertNotification", notification);
    }

    @Override
    public List<NotificationVO> selectUnreadList(int memberNo) {
        return sqlSessionTemplate.selectList("notification.dao.NotificationDAO.selectUnreadList", memberNo);
    }

    @Override
    public int countUnread(int memberNo) {
        return sqlSessionTemplate.selectOne("notification.dao.NotificationDAO.countUnread", memberNo);
    }

    @Override
    public void deleteOne(int no) {
        sqlSessionTemplate.delete("notification.dao.NotificationDAO.deleteOne", no);
    }

    @Override
    public void deleteAllByMemberNo(int memberNo) {
        sqlSessionTemplate.delete("notification.dao.NotificationDAO.deleteAllByMemberNo", memberNo);
    }

    @Override
    public void deleteByTeamNo(int teamNo) {
        sqlSessionTemplate.delete("notification.dao.NotificationDAO.deleteByTeamNo", teamNo);
    }
}
