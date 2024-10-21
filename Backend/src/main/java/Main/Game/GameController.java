package Main.Game;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class GameController {

    private Map<String, Game> gameSessions = new HashMap<>();

    @PostMapping("/start_game")
    public void startGame(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        Game gameData = new Game();	// 플레이어별로 고유한 게임 데이터를 생성
        gameSessions.put(userId, gameData); //중복 요청시 초기화
    }
    
    @PostMapping("/night")
    public ResponseEntity<Map<String, Object>> night(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        Game gameData = gameSessions.get(userId);

        Map<String, Object> response = new HashMap<>();
        response.put("player", gameData.getPlayer());  // player 정보를 반환
        response.put("Job", gameData.getJob());        // Job[] 배열 반환
        response.put("Alive", gameData.getAlive());        // Alive<> 반환

        return ResponseEntity.ok(response);
    }

    @PostMapping("/night_target")
    public void night_target(@RequestBody Map<String, Object> request) {
        String userId = (String) request.get("userId");
        Game gameData = gameSessions.get(userId);

        gameData.getPick()[gameData.getPlayer()] = (Integer) request.get("target");
    }
    
}
