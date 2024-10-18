package com.example.demo;

import java.util.Collections;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login_or_register")
    public ResponseEntity<String> loginOrRegister(@RequestBody User user) {
        String userId = user.getUserId();
        String password = user.getPassword();

        // 아이디가 있는지 확인
        Optional<User> existingUser = userService.findUserById(userId);

        if (existingUser.isPresent()) {
            // 아이디가 존재하는 경우 비밀번호 대조
            if (existingUser.get().getPassword().equals(password)) {
                // 비밀번호 일치 -> 로그인 성공
                return ResponseEntity.ok("로그인 성공");
            } else {
                // 비밀번호 불일치
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("비밀번호가 일치하지 않습니다.");
            }
        } else {
            // 아이디가 없으면 새로 등록
            userService.saveUser(user);
            return ResponseEntity.ok("회원가입 성공");
        }
    }
    
    @GetMapping("/points")
    public ResponseEntity<?> getUserPoints(@RequestParam String userId) {
        // userId에 맞는 사용자 포인트를 가져오는 로직
        int points = userService.getUserPoints(userId); // 가상의 서비스 메서드
        return ResponseEntity.ok(Collections.singletonMap("point", points));
    }
}
