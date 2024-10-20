package Main.User;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // 아이디로 사용자 찾기
    public Optional<User> findUserById(String userId) {
        return userRepository.findById(userId);
    }

    // 사용자 저장
    public void saveUser(User user) {
        userRepository.save(user);
    }
    
    // 유저의 포인트 가져오기
    public int getUserPoints(String userId) {
        Optional<User> user = userRepository.findById(userId);
        // 해당 유저가 존재하면 포인트 반환, 존재하지 않으면 기본값 0 반환
        return user.map(User::getPoint).orElse(0);
    }
}
