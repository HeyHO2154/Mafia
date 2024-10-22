package Main.Game;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class GameLogic {

	//밤에 행동
	static void Night(Game gameData) {
        
        int N = gameData.getN();
        int player = gameData.getPlayer();
        int[] personal = gameData.getPersonal();
		int[] Job = gameData.getJob();
		int[] Job_claim = gameData.getJob_claim();
		int[] pick = gameData.getPick();
		Map<Integer, List<Integer>> Alive = gameData.getAlive();
		Map<Integer, List<Integer>> Enemy = gameData.getEnemy();
	    
		//밤
		gameData.setKill(-1); //죽일 타겟 초기화
		gameData.setLive(-1);; //살릴 대상 초기화
		for (int i = 0; i < N; i++) {
			if(Alive.get(1).contains(i) || Alive.get(-1).contains(i)) {
				if(i==player) {
					switch (Job[player]) {
					case -1:
						GameAct.Kill(player, pick[player], gameData);
						break;
					case 1:
						GameAct.Find(player, pick[player], gameData);
						break;
					case 2:
						GameAct.Live(player, pick[player], gameData);
						break;
					}
				}else {
					List<Integer> list = new ArrayList<>();
					if(Alive.get(1).contains(i)) {
						switch (personal[i]) {
						case 1:	
							switch(Job[i]) {
								case 1:
									//특수 직업 검증하거나 랜덤 조사
									list = new ArrayList<>();
									for (int j = 0; j < Job_claim.length; j++) {
										if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
											list.add(j);
										}
									}
									if(!list.isEmpty()) {
										GameAct.Find(i, GameAct.RandomWho(list, i), gameData);
									}else {
										GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
								case 2:
									//특수 직업 치료하거나 랜덤 치료
									list = new ArrayList<>();
									for (int j = 0; j < Job_claim.length; j++) {
										if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
											list.add(j);
										}
									}
									if(!list.isEmpty()) {
										GameAct.Live(i, GameAct.RandomWho(list, i), gameData);
									}else {
										GameAct.Live(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
							}
							break;
						case 0:
							switch(Job[i]) {
								case 1:
									GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									break;
								case 2:
									GameAct.Live(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									break;
							}
							break;
						case -1:
							switch(Job[i]) {
								case 1:
									//특수 직업 조사나, 적대인물 조사나, 랜덤 조사
									list = new ArrayList<>();
									for (int j = 0; j < Job_claim.length; j++) {
										if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
											list.add(j);
										}
									}
									if(!list.isEmpty()) {
										GameAct.Find(i, GameAct.RandomWho(list, i), gameData);
									}else if(!Enemy.get(i).isEmpty()){
										GameAct.Find(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
									}else {
										GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
								case 2:
									GameAct.Live(i, i, gameData);
									break;
							}
							break;
						case -2:
							switch(Job[i]) {
								case 1:
									//적대인물 조사나, 랜덤 조사
									if(!Enemy.get(i).isEmpty()){
										GameAct.Find(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
									}else {
										GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
								case 2:
									GameAct.Live(i, i, gameData);
									break;
							}
							break;
						}
					}else if(Alive.get(-1).contains(i)) {
						switch (personal[i]) {
						case 1:
							//경찰 살인이나 랜덤 살인
							list = new ArrayList<>();
							for (int j = 0; j < Job_claim.length; j++) {
								if(Job_claim[j]==1 && Alive.get(1).contains(j) && i!=j) {
									list.add(j);
								}
							}
							if(!list.isEmpty()) {
								GameAct.Kill(i, GameAct.RandomWho(list, i), gameData);
							}else {
								GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							}
							break;
						case 0:
							GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							break;
						case -1:
							//경찰 살인이나, 적대인물 살인이나, 랜덤 살인
							list = new ArrayList<>();
							for (int j = 0; j < Job_claim.length; j++) {
								if(Job_claim[j]==1 && Alive.get(1).contains(j) && i!=j) {
									list.add(j);
								}
							}
							if(!list.isEmpty()) {
								GameAct.Kill(i, GameAct.RandomWho(list, i), gameData);
							}else if(!Enemy.get(i).isEmpty()){
								GameAct.Kill(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
							}else {
								GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							}
							break;
						case -2:
							//적대인물 살인이나, 랜덤 살인
							if(!Enemy.get(i).isEmpty()){
								GameAct.Kill(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
							}else {
								GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							}
							break;
						}
					}
				}
			}
		}
			
	}
	
	//낮에 죽은사람 확인
	static boolean Day(Game gameData) {
		if(gameData.getKill()!=gameData.getLive()) {
			GameAct.Kick(gameData.getKill(), gameData);
			return true;
		}
		return false;
	}
	
	//낮에 각자 토론
	static String Discussion(Game gameData, int PlayerId, int Act, int FakeJob, int TargetId, boolean IsMafia) {
		String message = null;
		int i = PlayerId;
        int[] personal = gameData.getPersonal();
		int[] Job = gameData.getJob();
		int[] Job_claim = gameData.getJob_claim();
		int[] pick_fake = gameData.getPick_fake();
		boolean[] find_fake = gameData.getFind_fake();
		Map<Integer, List<Integer>> Alive = gameData.getAlive();
		Map<Integer, List<Integer>> Enemy = gameData.getEnemy();
		
		if(PlayerId == gameData.getPlayer()) {
			switch (Act) {
			case 1:
				message = GameAct.Suspect(PlayerId, TargetId, gameData);
				break;
			case 2:
				if(Alive.get(-1).contains(PlayerId)) {
					if(Job_claim[PlayerId]==99) {
						Job_claim[PlayerId] = FakeJob;	
					}
					if(Job_claim[PlayerId]>=1) {
						pick_fake[PlayerId] = TargetId;
						if(Job_claim[PlayerId]==1) {
							if(IsMafia) {
								find_fake[pick_fake[PlayerId]]=true;
							}
						}
					}
				}
				gameData.setJob_claim(Job_claim);
				gameData.setPick_fake(pick_fake);
				gameData.setFind_fake(find_fake);
				message = GameAct.OpenJob(PlayerId, gameData);
				break;
			case 3:
				message = GameAct.Nothing(PlayerId, gameData);
				break;
			}
			
		}else {
			int who;
			if(Alive.get(1).contains(i)) {
				//(명예로운, 순수한)경찰이면 무조건 직업공개
				if(Job[i]==1 && (personal[i]==1 || personal[i]==0)) {
					message = GameAct.OpenJob(i, gameData);
					return message;
				}
				//그 외
				switch (personal[i]) {
				case 1:
					message = GameAct.OpenJob(i, gameData);
					break;
				case 0:
					message = GameAct.Nothing(i, gameData);
					break;
				case -1:
					//적대인물 공격 - 직업 공개
					if(!Enemy.get(i).isEmpty()) {
						message = GameAct.Suspect(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
					}else {
						message = GameAct.OpenJob(i, gameData);
					}
					break;
				case -2:
					if(!Enemy.get(i).isEmpty()) {
						//적대인물 의견내기
						message = GameAct.Suspect(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
					}else {
						//아무나 의견내기
						message = GameAct.Suspect(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
					}
					break;
				}
			}else if(Alive.get(-1).contains(i)) {
				//마피아 일때,
				switch (personal[i]) {
				case 1:
					//경찰, 의사 주장자 있으면 공론화
					List<Integer> target = new ArrayList<>();
					for (int j = 0; j < Job_claim.length; j++) {
						if((Job_claim[j]==1 || Job_claim[j]==2) && Alive.get(1).contains(j)) {
							target.add(j);
						}
					}
					if(!target.isEmpty()) {
						who = (int) (Math.random()*target.size());
						message = GameAct.Suspect(i, who, gameData);
					}else {
						//가짜 직업 공개
						GameAct.FakeJob(i, gameData);
						message = GameAct.OpenJob(i, gameData);
					}
					break;
				case 0:
					message = GameAct.Nothing(i, gameData);
					break;
				case -1:
					//가짜 직업 공개
					GameAct.FakeJob(i, gameData);
					message = GameAct.OpenJob(i, gameData);
					break;
				case -2:
					//적대인물 또는 랜덤 의견내기
					if(!Enemy.get(i).isEmpty()) {
						message = GameAct.Suspect(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
					}else {
						message = GameAct.Suspect(i, GameAct.RandomWho(Alive.get(1), i), gameData);
					}
					break;
				}
			}
		}
				
		return message;
	}
	
}