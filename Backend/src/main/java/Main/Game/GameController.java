package Main.Game;

import java.util.HashMap;
import java.util.Map;

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

        // 플레이어별로 고유한 게임 데이터를 생성
        Game gameData = new Game();
        gameSessions.put(userId, gameData);
    }

    // 다른 API 로직 (게임 진행, 결과 처리 등)
    // "/end_game"하면 해당 id의 데이터를 지우게 하거나 놔둬도 될듯, 어차피 유저1명단 1데이터인 해시맵 구조니까
}
