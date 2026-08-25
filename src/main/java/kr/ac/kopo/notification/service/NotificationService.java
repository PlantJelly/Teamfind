package kr.ac.kopo.notification.service;

import kr.ac.kopo.notification.vo.NotificationVO;
import java.util.List;

public interface NotificationService {

    void insertNotification(NotificationVO notification);

    List<NotificationVO> selectUnreadList(int memberNo);

    int countUnread(int memberNo);

    void deleteOne(int no);

    void deleteAllByMemberNo(int memberNo);
}
