package kr.ac.kopo.notification.service;

import kr.ac.kopo.notification.dao.NotificationDAO;
import kr.ac.kopo.notification.vo.NotificationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationDAO notificationDAO;

    @Override
    public void insertNotification(NotificationVO notification) {
        notificationDAO.insertNotification(notification);
    }

    @Override
    public List<NotificationVO> selectUnreadList(int memberNo) {
        return notificationDAO.selectUnreadList(memberNo);
    }

    @Override
    public int countUnread(int memberNo) {
        return notificationDAO.countUnread(memberNo);
    }

    @Override
    public void deleteOne(int no) {
        notificationDAO.deleteOne(no);
    }

    @Override
    public void deleteAllByMemberNo(int memberNo) {
        notificationDAO.deleteAllByMemberNo(memberNo);
    }
}
