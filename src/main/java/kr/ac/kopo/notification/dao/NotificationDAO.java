package kr.ac.kopo.notification.dao;

import kr.ac.kopo.notification.vo.NotificationVO;
import java.util.List;

public interface NotificationDAO {

    void insertNotification(NotificationVO notification);

    List<NotificationVO> selectUnreadList(int memberNo);

    int countUnread(int memberNo);

    void deleteOne(int no);

    void deleteAllByMemberNo(int memberNo);

    void deleteByTeamNo(int teamNo);
}
